# Package Metadata
## 目标
本文档定义 `nix-flake-config` 中的**软件包元数据注册表**。

它回答以下问题：
- 一个软件包需要哪些元数据
- 这些元数据按什么分类体系组织
- 元数据如何决定包的可见性、支持性、落地方式
- 注册表按什么职责拆分成文件

本文档是从 `1.md`（原始设计草案）与重构实现中提炼出的正式规范。

---
## 坐标系：taxonomy

软件包的分类基于一套四维坐标系，定义在 `modules/packages/taxonomy.nix` 中。

### 主机类型（Host Kind）

| 值 | 含义 |
|---|---|
| `nixos` | NixOS 主机，同时拥有 system 与 home 两个 scope |
| `darwin` | nix-darwin 主机，同时拥有 system 与 home |
| `standaloneHomeManager` | 纯 home-manager 主机，home scope 真实启用，system scope 为 dummy |

### 部署目标（Target）

Target 是 `hostKind × scope` 的笛卡尔积，唯一标识一条部署路径。

| Target | 主机类型 | Scope |
|---|---|---|
| `nixosHome` | nixos | home |
| `nixosSystem` | nixos | system |
| `darwinHome` | darwin | home |
| `darwinSystem` | darwin | system |
| `standaloneHomeManagerHome` | standaloneHomeManager | home |
| `standaloneHomeManagerSystem` | standaloneHomeManager | system（dummy） |

说明：
- `standaloneHomeManagerSystem` 本质是 dummy target，不产生真正的系统配置，但为坐标系完整性保留。
- 便捷集合：`allHomeTargets`、`allSystemTargets`、`allTargets` 在 taxonomy 中预定义。

### 归属（Owner）

| 值 | 含义 |
|---|---|
| `user` | 由用户声明，出现在 `profile.users.*.packages` |
| `host` | 由主机声明，出现在 `profile.hosts.*.packages` |

### 缺失策略（Missing Strategy）

当包被声明但当前主机不支持时，系统如何处理：

| 值 | 行为 |
|---|---|
| `notApplicable` | 此包理论上不会出现主机不匹配的情况 |
| `error` | 直接报错拒绝 |
| `skip` | 静默跳过，不生成任何输出 |
| `hintManual` | 跳过但生成诊断信息，提示用户手动安装 |

### 映射关系

taxonomy 还定义以下映射：
- `backendToHostKind`：`backend.type` → `hostKind`
- `resolveTarget`：`(backend, scope)` → `target`
- `hostKindToHomeTarget` / `hostKindToSystemTarget`：`hostKind` → 对应的 home/system target

---
## 元数据字段

每个包的元数据记录包含以下字段：

| 字段 | 类型 | 说明 |
|---|---|---|
| `kind` | string | 包类型分类，如 `"package"`, `"gui"`, `"service"`, `"desktop-component"`, `"desktop-session"`, `"environment"`, `"theme-consumer"`, `"integration-heavy"`, `"custom"`, `"desktop-input-method"` |
| `owner` | `"user"` \| `"host"` | 包归属 |
| `allowedHostKinds` | list of hostKind | 此包在哪些主机类型上可用 |
| `allowedTargets` | list of target | 此包允许落地到哪些部署目标 |
| `requiresDesktop` | bool | 是否需要桌面能力启用 |
| `missingStrategy` | missingStrategy | 不支持时的处理方式 |
| `unsupportedReason` | string（可选） | 自定义不支持原因 |
| `unsupportedSuggestion` | string（可选） | 自定义替代建议 |

### 默认值策略

**未注册的包不会获得宽松默认值。**  
如果一个包未出现在 catalog 中，它的元数据会被设为：
- `allowedHostKinds = []`
- `allowedTargets = []`
- `missingStrategy = "error"`

这意味着未注册的包在所有目标上都被拒绝，并在评估时输出 `builtins.trace` 警告。

---
## 预设模板：presets

`modules/packages/presets.nix` 提供以下预设，每个预设生成一条完整的元数据记录。  
catalog 条目直接选择最匹配的预设，不需要再用 `//` 覆盖字段。

| 预设 | 语义 | owner | allowedHostKinds | allowedTargets | requiresDesktop | missingStrategy |
|---|---|---|---|---|---|---|
| `crossPlatformUserPackage` | 全平台用户包 | user | 全部 | 所有 home targets | false | notApplicable |
| `linuxDesktopUser` | Linux 桌面用户包 | user | nixos + standaloneHomeManager | nixosHome + standaloneHomeManagerHome | true | skip |
| `linuxDesktopHost` | Linux 桌面主机控制包 | host | nixos + standaloneHomeManager | nixosHome + standaloneHomeManagerHome | true | skip |
| `darwinHintManual` | Darwin 手动安装提示包 | user | nixos + standaloneHomeManager | nixosHome + standaloneHomeManagerHome | false | hintManual |
| `linuxSystemHost` | Linux 系统主机包 | host | nixos | nixosSystem | false | skip |
| `crossPlatformSystemHost` | 全平台系统主机包 | host | 全部 | 所有 system targets | false | notApplicable |
| `linuxDesktopSystemHost` | Linux 桌面系统主机包 | host | nixos | nixosSystem | true | skip |

超出预设覆盖范围的特殊包（如 `embedded-dev`、`gnome-keyring`、`pipewire`）可以直接手写完整元数据记录。

### 设计原则
- 每个预设产生的记录都是完整的，不需要后续 `//` 覆盖
- 如果一个包不完全匹配任何预设，优先手写完整记录
- 不鼓励 "模板 + override" 风格

---
## 注册表：catalog

注册表分为两个独立文件，按 scope 拆分：

### `modules/packages/catalog/home.nix`
所有 **home scope** 的包元数据，按分类分组：
1. 跨平台用户包
2. Linux 桌面用户包
3. Linux 桌面主机控制包
4. Darwin 手动安装提示包
5. 自定义约束包

### `modules/packages/catalog/system.nix`
所有 **system scope** 的包元数据，按分类分组：
1. Linux 系统包
2. 跨平台系统包
3. Linux 桌面系统包

### 注册要求
- 每个使用到的包都必须在对应 scope 的 catalog 中有显式条目
- 不存在"隐式全平台支持"的漏洞
- 同一个包如果同时在 home 和 system scope 使用，两边各自需要条目

---
## 规则引擎：rules

`modules/packages/rules.nix` 提供以下运行时判定函数：

### 上下文解析

| 函数 | 说明 |
|---|---|
| `resolveBackendType current` | 从 `current` 提取 `backend.type` |
| `resolveHostPlatform current` | 从 `current` 提取 `host.platform.system` |
| `resolveDesktopEnabled scope current` | 判定当前是否启用了桌面能力 |
| `resolvePlatformLabel current` | 返回人类可读平台标签（`"linux"`, `"darwin"`, `"unknown"`） |

### 元数据查询

| 函数 | 说明 |
|---|---|
| `hasEntryFor scope packageId` | 包是否在 catalog 中注册 |
| `metadataFor scope packageId` | 返回包的完整元数据（未注册则返回限制性 fallback） |
| `ownerFor scope packageId` | 返回包的 owner |

### 可见性 / 声明合法性

| 函数 | 说明 |
|---|---|
| `isReachableFromSource scope declaredBy packageId` | 包是否可以从给定的声明来源（user/host）在给定 scope 下被声明 |

此函数的逻辑：
1. 如果 `ownerFor` 与 `declaredBy` 不匹配 → 不可达
2. home scope 下主机声明的包 → 必须在 home catalog 中注册
3. system scope → 要么在 system catalog 中注册，要么在 home catalog 中不存在

### 支持性判定

| 函数 | 说明 |
|---|---|
| `allowedOnHostKind scope hostKind packageId` | 包是否允许在给定主机类型上使用 |
| `supportsTarget scope target packageId` | 包是否支持给定部署目标 |
| `supportsBackend scope backend packageId` | 便捷函数：解析 backend → target，然后检查 |
| `supportedFor scope current packageId` | 完整运行时支持检查：检查 hostKind、target 和 desktop 要求 |

---
## 诊断输出：diagnostics

`modules/packages/diagnostics.nix` 提供：

| 函数 | 说明 |
|---|---|
| `unsupportedInfoFor scope current packageId` | 若包不受支持，返回诊断记录；否则返回 `null` |

诊断记录结构：
```nix
{
  name = "packageId";
  scope = "home" | "system";
  backend = "nixos" | "nix-darwin" | "home-manager";
  platform = "linux" | "darwin" | "unknown";
  strategy = missingStrategy;
  reason = "...";
  suggestion = "...";
}
```

---
## 文件结构

```
modules/packages/
├── default.nix           # 公共 API 入口，re-export rules + diagnostics
├── taxonomy.nix          # 坐标系：hostKind、target、owner、missingStrategy、映射
├── presets.nix           # 元数据预设模板
├── rules.nix             # 规则判定逻辑
├── diagnostics.nix       # 诊断输出（unsupportedInfo）
└── catalog/
    ├── home.nix          # home scope 包元数据注册表
    └── system.nix        # system scope 包元数据注册表
```

### 依赖方向
```
taxonomy.nix  ← presets.nix ← catalog/{home,system}.nix
     ↑                              ↑
     └──────── rules.nix ───────────┘
                    ↑
              diagnostics.nix
                    ↑
               default.nix  ← 外部消费者
```

### 消费者
以下模块通过 `import ../packages { inherit lib; }` 使用此系统：
- `modules/validate/default.nix`：校验阶段，使用 `isReachableFromSource` 和 `supportsBackend`
- `modules/context/packages.nix`：上下文阶段，过滤已启用且可见且受支持的包
- `modules/context/unsupported-packages.nix`：上下文阶段，收集不受支持的包诊断信息

---
## 命名对照表（旧 → 新）

以下是从 `1.md` 设计草案中的缩写命名到正式命名的完整对照。  
项目代码中不再使用任何旧缩写。

### 主机类型
| 旧 | 新 |
|---|---|
| N | `nixos` |
| D | `darwin` |
| M | `standaloneHomeManager` |

### 部署目标
| 旧 | 新 |
|---|---|
| NH | `nixosHome` |
| NS | `nixosSystem` |
| DH | `darwinHome` |
| DS | `darwinSystem` |
| MH | `standaloneHomeManagerHome` |
| MS | `standaloneHomeManagerSystem` |

### 归属
| 旧 | 新 |
|---|---|
| U | `user` |
| H | `host` |

### 缺失策略
| 旧 | 新 |
|---|---|
| n | `notApplicable` |
| e | `error` |
| s | `skip` |
| h | `hintManual` |

### 预设模板
| 旧 | 新 |
|---|---|
| `desktopLinux` | `linuxDesktopUser` |
| `darwinManualGui` | `darwinHintManual` |
| `linuxSystem` | `linuxSystemHost` |
| （无对应） | `crossPlatformUserPackage` |
| （无对应） | `crossPlatformSystemHost` |
| （无对应） | `linuxDesktopHost` |
| （无对应） | `linuxDesktopSystemHost` |

### 函数命名
| 旧 | 新 |
|---|---|
| `visibleForSource` | `isReachableFromSource` |
| `backendSupports` | `supportsBackend` |
| `declaredByFor` | `ownerFor` |

---
## 新增包的流程

当需要在 catalog 中注册一个新包时：

1. **确定 scope**：包落地到 home 还是 system？
2. **确定 owner**：包由 user 还是 host 声明？
3. **确定平台约束**：全平台、仅 Linux、需要桌面？
4. **选择预设**：从预设模板中选择最匹配的，或手写完整记录
5. **写入 catalog**：在 `catalog/home.nix` 或 `catalog/system.nix` 的对应分组下添加条目
6. **验证**：运行 `nix flake check` 确认无警告和错误
