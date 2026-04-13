# Package Metadata
## 目标
本文档定义当前仓库中软件包系统的两个层次及其关系：
- `modules/packages/`：每个 package 的 definition 与 backend 实现（单点真源）
- `modules/package-governance/`：元数据坐标系、预设、catalog 派生、判定与诊断规则

---
## 当前结构
### 1. Package Definitions（实现层）
目录：`modules/packages/`

每个包一个目录：
```text
modules/packages/<packageId>/
├── default.nix
├── home.nix
├── nixos.nix
└── darwin.nix
```

语义：
- `default.nix`：定义 `packageId`、`metadata`、`backends` 路径引用
- `home.nix` / `nixos.nix` / `darwin.nix`：具体 backend 行为实现
- loader 通过 `modules/packages/default.nix` 自动发现所有子目录

### 2. Package Governance（规则层）
目录：`modules/package-governance/`

```text
modules/package-governance/
├── default.nix
├── taxonomy.nix
├── presets.nix
├── rules.nix
├── diagnostics.nix
└── catalog/
    ├── from-definitions.nix
    ├── home.nix
    └── system.nix
```

语义：
- `taxonomy.nix`：host kind / target / owner / missing strategy 坐标系
- `presets.nix`：常用 metadata 模板
- `catalog/*.nix`：从 definitions 派生 scope 元数据视图
- `rules.nix`：可见性与支持性判定
- `diagnostics.nix`：unsupported 信息生成

---
## Definition Schema
单个 package definition（`modules/packages/<packageId>/default.nix`）包含：

```nix
{
  packageId = "<packageId>";

  metadata = {
    kind = "package" | "gui" | "service" | ...;
    owner = "user" | "host";
    allowedHostKinds = [ ... ];
    allowedTargets = [ ... ];
    requiresDesktop = bool;
    missingStrategy = ...;
    unsupportedReason = null or string;
    unsupportedSuggestion = null or string;
  };

  backends = {
    home-manager = { home = ./home.nix or null; system = null; };
    nixos        = { home = ./home.nix or null; system = ./nixos.nix or null; };
    nix-darwin   = { home = ./home.nix or null; system = ./darwin.nix or null; };
  };
}
```

---
## 坐标系（taxonomy）
定义于 `modules/package-governance/taxonomy.nix`：
- `hostKinds`
- `targets`
- `owners`
- `missingStrategies`
- `backendToHostKind`
- `resolveTarget`
- `hostKindToHomeTarget` / `hostKindToSystemTarget`

这些是纯数据与映射，不承载业务实现。

---
## Catalog 与 Rule 流程
1. `modules/package-governance/catalog/from-definitions.nix` 读取 `modules/packages/`
2. 派生 `home` 与 `system` 两个 catalog
3. `rules.nix` 使用 catalog 做：
   - `ownerFor`
   - `isReachableFromSource`
   - `supportsBackend` / `supportedFor`
4. `diagnostics.nix` 基于规则输出 unsupported 信息

注意：未注册包不会获得宽松默认值，走限制性 fallback。

---
## Projection 连接点
当前与 package definitions 的主要连接点：
- `modules/projection/common/package-modules.nix`
  - 将 `input.packages.<scope>` 映射为 module 列表
  - 按 `(backendType, scope)` 读取 definition 中的 backend path
- `modules/projection/common/nixos-home-system-modules.nix`
  - 处理在 NixOS 下由 home 声明触发的 system 集成模块

因此，旧的 `modules/projection/backends/nixos/user-packages/` 已被迁移掉，相关逻辑应落在对应包的 `modules/packages/<packageId>/nixos.nix`。

---
## 新增包流程
1. 新建目录 `modules/packages/<packageId>/`
2. 填写 `default.nix`（metadata + backends）
3. 实现 `home.nix` / `nixos.nix` / `darwin.nix`（不适用可返回空模块或设 `null`）
4. 运行 `nix flake check`

---
## 边界约束
- package 语义实现在 `modules/packages/`，不要回流到 backend registry 目录
- package taxonomy/判定逻辑在 `modules/package-governance/`，不要散落到 projection/assembly
- 需要用户组、shell、服务等 NixOS 侧集成时，应在对应 package 的 `nixos.nix` 中实现
