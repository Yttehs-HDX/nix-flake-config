# Directory Layout
## 目标
本文档定义 `nix-flake-config` 的推荐目录结构。

前面的文档已经明确了：
- 为什么要这样设计
- 系统有哪些核心对象
- 数据模型长什么样
- 解析流程如何运作
- 模块边界如何划分

而本文档要解决的是最后一个落地问题：
> 这些抽象边界，如何映射为一棵真实、可维护、可演化的目录树？

这份文档的重点不是“列一个好看的树”，  
而是要让目录结构真正成为架构的投影。

也就是说，目录不能只是文件堆放位置，  
而应当直接体现：
- 数据从哪里进入
- 在哪里被归一化
- 在哪里被实例化
- 在哪里被整理为上下文
- 在哪里被投影
- 在哪里被组装为最终输出

---
## 设计目标
目录结构应满足以下目标：

### 1. 目录映射架构阶段
目录应尽量对应：
- source
- normalize
- validate
- instantiate
- context
- project
- assemble

这些阶段，而不是单纯按“软件名字”乱堆。

---
### 2. 目录映射对象边界
目录还应体现三类核心对象：
- users
- hosts
- relations

前端声明层应优先围绕它们组织。

---
### 3. 公共接口与私有实现可区分
目录结构要帮助开发者一眼分辨：
- 什么是对外稳定接口
- 什么是内部实现
- 什么是 schema
- 什么是 helper
- 什么是 backend-specific

---
### 4. 支持长期演化
目录不应因为新增一个软件包、一个桌面环境、一个 backend，就被迫重构整体骨架。

也就是说，目录必须优先稳定“主干”，  
把变化控制在叶子层。

---
## 核心原则
### 1. 先按阶段分，再按语义分
最外层优先按架构阶段切分，  
阶段内部再按语义领域切分。

不要一开始就在根目录把所有内容按软件名字平铺。

---
### 2. 前端声明层与后端实现层必须分离
定义用户可以写什么的目录，  
不能和最终如何实现的目录混在一起。

---
### 3. backend-specific 目录必须靠后出现
越靠近根目录，越不应带有强 backend 偏见。  
backend-specific 内容应尽量只存在于投影与组装阶段。

---
### 4. helper 不应污染主干目录
helper 应存在，但不能成为架构主轴。  
也就是说，不能让整个目录树围着 `lib/` 或 `helpers/` 转。

---
### 5. 目录名应表达语义，而不是历史偶然性
例如：
- `projection`
- `assembly`
- `schema`
- `source`

这些都是语义型名字。

而像：
- `misc`
- `tmp`
- `utils2`
- `new-modules`

这种名字应尽量避免。

---
## 推荐总目录结构
推荐将项目主要结构组织为如下形式：
```
.
├── flake.nix
├── flake.lock
├── docs
│   ├── vision.md
│   ├── architecture.md
│   ├── core-concepts.md
│   ├── data-model.md
│   ├── resolution-flow.md
│   ├── module-boundaries.md
│   ├── directory-layout.md
│   └── option-schema.md
├── modules
│   ├── source
│   │   ├── default.nix
│   │   ├── profile
│   │   │   ├── default.nix
│   │   │   ├── users.nix
│   │   │   ├── hosts.nix
│   │   │   └── relations.nix
│   │   └── declarations
│   │       ├── users
│   │       ├── hosts
│   │       └── relations
│   ├── normalize
│   │   ├── default.nix
│   │   ├── users.nix
│   │   ├── hosts.nix
│   │   ├── relations.nix
│   │   └── defaults
│   │       ├── users.nix
│   │       ├── hosts.nix
│   │       └── relations.nix
│   ├── validate
│   │   ├── default.nix
│   │   ├── references.nix
│   │   ├── uniqueness.nix
│   │   ├── ownership.nix
│   │   └── capabilities.nix
│   ├── instantiate
│   │   ├── default.nix
│   │   ├── instances.nix
│   │   ├── backend.nix
│   │   └── scopes.nix
│   ├── context
│   │   ├── default.nix
│   │   ├── current.nix
│   │   ├── instance-context.nix
│   │   ├── scoped-context.nix
│   │   └── effective-capabilities.nix
│   ├── projection
│   │   ├── default.nix
│   │   ├── common
│   │   │   ├── packages.nix
│   │   │   ├── programs.nix
│   │   │   ├── services.nix
│   │   │   ├── theme.nix
│   │   │   ├── identity.nix
│   │   │   ├── membership.nix
│   │   │   └── desktop.nix
│   │   ├── backends
│   │   │   ├── home-manager
│   │   │   │   ├── default.nix
│   │   │   │   ├── home.nix
│   │   │   │   ├── packages.nix
│   │   │   │   ├── programs.nix
│   │   │   │   └── theme.nix
│   │   │   ├── nixos
│   │   │   │   ├── default.nix
│   │   │   │   ├── system.nix
│   │   │   │   ├── home.nix
│   │   │   │   ├── identity.nix
│   │   │   │   ├── membership.nix
│   │   │   │   ├── desktop.nix
│   │   │   │   └── services.nix
│   │   │   └── nix-darwin
│   │   │       ├── default.nix
│   │   │       ├── system.nix
│   │   │       ├── home.nix
│   │   │       └── programs.nix
│   ├── assembly
│   │   ├── default.nix
│   │   ├── merge.nix
│   │   ├── nixos.nix
│   │   ├── home-manager.nix
│   │   └── nix-darwin.nix
│   ├── schema
│   │   ├── default.nix
│   │   ├── enums.nix
│   │   ├── capabilities.nix
│   │   ├── scopes.nix
│   │   ├── backends.nix
│   │   ├── interfaces.nix
│   │   └── options
│   │       ├── users.nix
│   │       ├── hosts.nix
│   │       └── relations.nix
│   ├── interfaces
│   │   ├── default.nix
│   │   ├── normalized.nix
│   │   ├── instances.nix
│   │   ├── current.nix
│   │   └── projection-inputs.nix
│   ├── internal
│   │   ├── default.nix
│   │   ├── helpers
│   │   │   ├── attrs.nix
│   │   │   ├── merge.nix
│   │   │   ├── ids.nix
│   │   │   └── diagnostics.nix
│   │   └── private
│   │       ├── normalization.nix
│   │       ├── projection.nix
│   │       └── assembly.nix
│   └── entrypoints
│       ├── default.nix
│       ├── nixos.nix
│       ├── home-manager.nix
│       └── nix-darwin.nix
├── hosts
│   ├── default.nix
│   ├── laptop
│   │   └── default.nix
│   └── server-a
│       └── default.nix
├── users
│   ├── default.nix
│   ├── alice
│   │   └── default.nix
│   └── bob
│       └── default.nix
├── relations
│   ├── default.nix
│   ├── alice@laptop.nix
│   └── alice@server-a.nix
└── tests
    ├── default.nix
    ├── normalize.nix
    ├── instantiate.nix
    ├── context.nix
    ├── projection.nix
    └── assembly.nix
```

---
## 目录分层解释
上面这棵树不是“唯一正确答案”，  
但它体现了一种非常明确的边界：
- `docs/`：设计文档层
- `modules/`：架构实现层
- `hosts/ users/ relations/`：声明数据入口层
- `tests/`：按解析阶段组织的验证层

也就是说，根目录下最重要的不是“软件包目录”，  
而是“架构骨架”。

---
## 顶层目录职责
## `docs/`
### 作用
保存架构与规范文档。

### 为什么必须独立存在
因为这个项目不是简单配置集合，而是一个配置系统。  
设计文档必须是代码结构的上游，而不是注释附属物。

---
## `modules/`
### 作用
保存真正的模块实现骨架。

### 地位
这是项目的主干目录。  
后续几乎所有系统逻辑都应围绕它展开。

---
## `users/`
### 作用

保存用户声明输入。

### 特点
这是 `Source Model` 的一部分，  
不应混入 normalize、projection 或 backend realize 逻辑。

---
## `hosts/`
### 作用
保存主机声明输入。

### 特点
和 `users/` 一样，属于最前端的声明层。

---
## `relations/`
### 作用
保存用户与主机的关系声明输入。

### 特点
它应作为独立一等对象存在，而不是被塞进 `users/` 或 `hosts/` 内部。

---
## `tests/`
### 作用
保存按解析阶段组织的测试。

### 原则
测试目录应尽量映射解析流，而不是仅按工具或文件位置胡乱分组。

---
## `modules/` 目录内部结构
`modules/` 是整个系统最核心的目录，  
因此下面分别说明它的子目录。

---
## `modules/source/`
### 作用
接住前端声明层。

它负责定义：
- `profile.users`
- `profile.hosts`
- `profile.relations`

以及这些对象的 source-level option 入口。

### 为什么单独存在
因为声明层必须独立于实现层。  
`source/` 只负责“用户可以写什么”，不负责“怎么落地”。

### 推荐内部组织
- `profile/`：顶层 profile 入口
- `declarations/users/`：用户声明层子模块
- `declarations/hosts/`：主机声明层子模块
- `declarations/relations/`：关系声明层子模块

---
## `modules/normalize/`
### 作用
把 source model 整理成 normalized model。

### 推荐包含
- 用户归一化
- 主机归一化
- 关系归一化
- 默认值规则

### 目录设计意图
让“结构整理”成为一个显式阶段，  
而不是散落在几十个模块的隐式逻辑里。

---
## `modules/validate/`
### 作用
执行校验逻辑。

### 推荐包含
- 引用校验
- 唯一性校验
- ownership 校验
- capability 合法性校验

### 为什么不和 normalize 放一起
因为“补默认值”和“判断是否合法”是两种不同职责。  
目录也应体现这个区分。

---
## `modules/instantiate/`
### 作用
把 `user + host + relation` 组合成实例。

### 推荐包含
- 实例对象生成
- backend 派生
- scope 派生

### 设计重点
这里是从“抽象对象”进入“实例对象”的唯一合法入口。  
因此应单独成层，不能被 backend 模块偷偷吞掉。

---
## `modules/context/`
### 作用
生成统一上下文接口。

### 推荐包含
- instance context
- scoped context
- current interface
- effective capabilities

### 地位
这是普通模块最应该依赖的公共读取层之一。

### 为什么非常重要
因为后续所有语义模块如果都自己去拼：
- user
- host
- relation
- backend
- scope

系统会立刻耦合爆炸。  
所以 `context/` 是整个实现中的“稳定中间层”。

---
## `modules/projection/`
### 作用
把语义稳定的声明映射为 backend 可接受的实现片段。

### 推荐内部拆法
先分两层：
#### 1. `common/`

放按语义划分的 projector，例如：
- packages
- programs
- services
- theme
- identity
- membership
- desktop

这一层偏“语义领域”。

#### 2. `backends/`
放 backend-specific 适配逻辑，例如：
- home-manager
- nixos
- nix-darwin

这一层偏“实现落点”。

### 为什么要两层拆分
因为“语义模块”和“backend 差异”是两种不同维度。  
如果直接把所有东西按 backend 平铺，很容易丢失通用语义层。  
如果只保留语义层，不区分 backend，又会把所有差异揉成一锅。

所以推荐：
- 语义层在前
- backend 层在后

---
## `modules/assembly/`
### 作用
合并 projector 结果并接入最终输出。

### 推荐包含
- realization fragment merge
- backend-specific final assembly
- flake output wiring

### 为什么必须独立目录
因为“翻译”与“组装”不是一回事。
- `projection/` 解决的是：某项语义该怎么翻译
- `assembly/` 解决的是：所有翻译结果该怎么接成最终 outputs

这两层混在一起会直接导致边界失守。

---
## `modules/schema/`
### 作用
保存跨阶段共享的 schema 与枚举。

### 推荐包含
- backend 枚举
- scope 枚举
- capability 名称
- 共享接口形状
- option schema 常量

### 为什么独立
因为这些内容是“共享语义契约”，  
不应藏在某个具体业务模块里。

---
## `modules/interfaces/`
### 作用
集中定义公开可读的接口层。

### 推荐包含
- `normalized`
- `instances`
- `current`
- `projection-inputs`

### 为什么不和 schema 放一起
`schema/` 偏“类型与枚举定义”，  
`interfaces/` 偏“对外暴露哪些读取面”。

前者是契约材料，后者是契约出口。

---
## `modules/internal/`
### 作用

保存内部 helper 与私有实现。

### 推荐子目录
- `helpers/`
- `private/`

### 为什么必须显式命名为 internal
就是为了告诉后续实现者：
> 这里不是公共 API。

普通业务模块不应依赖这里的私有细节。

---
## `modules/entrypoints/`
### 作用
提供最终入口模块，供 flake outputs 或外层组合使用。

### 推荐包含
- `nixos.nix`
- `home-manager.nix`
- `nix-darwin.nix`

### 定位
这是从模块世界走向 flake output 世界的桥。

---
## Source Model 的物理位置建议
现在已经把 `users`、`hosts`、`relations` 定义为一等对象，  
所以它们在物理目录上也应该有明确地位。

推荐：
```
users/
hosts/
relations/
```

这比把它们全塞进一个 `profiles/` 大文件里更清晰。

---
## `users/` 目录建议
推荐结构：
```
users
├── default.nix
├── alice
│   └── default.nix
└── bob
    └── default.nix
```

### 原则
- 一个目录对应一个用户抽象对象
- 目录内部只描述该用户本体
- 不应出现 host-specific 细节

### 适合放什么
- preferences
- programs
- packages
- theme
- user capabilities

### 不适合放什么
- extraGroups
- uid
- homeDirectory
- 某台主机专属配置

---
## `hosts/` 目录建议
推荐结构：
```
hosts
├── default.nix
├── laptop
│   └── default.nix
└── server-a
    └── default.nix
```

### 原则
- 一个目录对应一台主机抽象对象
- 目录内部只描述主机本体

### 适合放什么
- backend.type
- platform.system
- roles
- hardware
- networking
- system-level services

### 不适合放什么
- 用户长期偏好
- 某用户的主题
- 某用户的 editor

---
## `relations/` 目录建议
推荐结构：
```
relations
├── default.nix
├── alice@laptop.nix
└── alice@server-a.nix
```

### 原则
- 一个文件对应一个 relation
- 文件名优先使用 `user@host`
- relation 必须是一等对象，而不是 users/hosts 的附属字段

### 适合放什么
- identity.name
- uid
- homeDirectory
- membership.extraGroups
- activation.*
- state.*

### 不适合放什么
- 用户本体长期偏好
- 主机本体硬件事实

---
## 是否需要 `profiles/` 目录
### 推荐结论
不建议把整个项目重新包成一个大而全的 `profiles/` 目录，  
除非它只作为 very-thin 的聚合入口存在。

### 原因
因为 `profiles/` 这个名字很容易把：
- user
- host
- relation
- instance
- current

这些本来不同层级的对象重新揉到一起。

本项目更强调对象边界和阶段边界，  
因此应尽量避免一个语义过宽的总名词吞掉所有结构。

如果保留 `profile` 一词，建议只让它存在于：

- 顶层逻辑命名空间
- source entrypoint
- 统一 config 根路径

而不是把它变成目录结构的唯一支点。

---
## 为什么 `modules/` 和 `users/hosts/relations/` 要分开
这是一个非常关键的目录原则。

### `users/hosts/relations/`
表示“声明数据内容”。

### `modules/`
表示“解释、整理、投影这些声明的系统逻辑”。

这两者如果不分开，最终会出现：
- 声明文件开始塞 helper
- 实现模块开始偷改 source data
- 每个用户目录都长出一堆 backend-specific 逻辑

所以必须拆开：
- 数据是一层
- 系统是一层

---
## 推荐的实现顺序与目录启用顺序
你现在不必一次把整棵树全部建完。  
推荐按阶段逐步长出来。

### 第一步：先建立最小骨架
先建：
```
docs/
modules/source/
modules/normalize/
modules/validate/
modules/instantiate/
modules/context/
modules/projection/
modules/assembly/
modules/schema/
users/
hosts/
relations/
```

这是第一阶段最关键的骨架。

---
### 第二步：再补 interfaces 与 internal
当 `current`、`projection-inputs` 等公共读取面开始稳定时，再补：
```
modules/interfaces/
modules/internal/
```

---
### 第三步：最后再补 tests 与 entrypoints
当中间阶段跑通后，再补：
```
modules/entrypoints/
tests/
```

这样可以避免一开始建太多空壳目录。

---
## 按阶段映射目录
为了让目录真正反映 `resolution-flow.md`，  
可以用下面这张映射表来理解：
| 解析阶段 | 主要目录 |
| --- | --- |
| Source Model | `users/` `hosts/` `relations/` `modules/source/` |
| Normalize | `modules/normalize/` |
| Validate / Index | `modules/validate/` |
| Instantiate | `modules/instantiate/` |
| Resolve Context | `modules/context/` `modules/interfaces/` |
| Project | `modules/projection/` |
| Assemble | `modules/assembly/` `modules/entrypoints/` |
| Shared Contract | `modules/schema/` |
| Private Helpers | `modules/internal/` |

这样后面任何人看到目录树，都能直接逆推出架构阶段。

---
## 按对象映射目录
还可以从核心对象角度理解：
| 对象 | 主要目录 |
| --- | --- |
| User | `users/` `modules/source/declarations/users/` `modules/normalize/users.nix` |
| Host | `hosts/` `modules/source/declarations/hosts/` `modules/normalize/hosts.nix` |
| Relation | `relations/` `modules/source/declarations/relations/` `modules/normalize/relations.nix` |
| Instance | `modules/instantiate/` |
| Context | `modules/context/` `modules/interfaces/current.nix` |
| Projection Input | `modules/interfaces/projection-inputs.nix` |
| Realization | `modules/projection/` `modules/assembly/` |

---
## 命名规范建议
目录名与文件名尽量遵循下面的风格。

### 1. 目录使用语义名词
推荐：
- `source`
- `normalize`
- `instantiate`
- `context`
- `projection`
- `assembly`

避免：
- `logic`
- `stuff`
- `misc`
- `core2`

---
### 2. 文件名优先表达单一职责
例如：
- `references.nix`
- `capabilities.nix`
- `effective-capabilities.nix`
- `projection-inputs.nix`

而不是：
- `common.nix`
- `helpers2.nix`
- `main-extra.nix`

---
### 3. backend-specific 文件名显式带 backend 语义
例如：
- `nixos/system.nix`
- `nixos/home.nix`
- `home-manager/home.nix`
- `nix-darwin/programs.nix`

不要把 backend 差异藏在含糊文件名里。

---
## 什么不应该出现在目录设计里
下面这些是强烈不推荐的结构倾向。

### 1. 根目录全按软件平铺
例如：
```
modules/
├── git.nix
├── zsh.nix
├── hyprland.nix
├── waybar.nix
├── kitty.nix
```

这样会完全看不出：
- 这些模块属于哪个阶段
- 属于 source / context / projection 哪一层
- 是 user 语义还是 host 语义

### 2. 一个超级 `lib/` 吞掉所有逻辑
例如：
```
lib/
├── users.nix
├── hosts.nix
├── relations.nix
├── nixos.nix
├── hm.nix
├── everything.nix
```

这样会让 helper 层和架构层彻底混在一起。

### 3. relation 被塞进 host 或 user 目录内部
例如：
```
users/alice/hosts/laptop.nix
```

或者：
```
hosts/laptop/users/alice.nix
```

这会重新把 relation 降级为附属结构，  
破坏它作为一等对象的地位。

### 4. backend-specific 内容过早出现在根部
例如：
```
nixos/
home-manager/
darwin/
users/
hosts/
```

如果一开始就按 backend 切根目录，  
会导致 source layer 被 backend 语义吞掉。

---
## 最小可行目录版本
如果你现在想先跑起来，不想一次建太多目录，  
可以先采用这个最小版：

```
.
├── docs
├── modules
│   ├── source
│   ├── normalize
│   ├── validate
│   ├── instantiate
│   ├── context
│   ├── projection
│   ├── assembly
│   └── schema
├── users
├── hosts
└── relations
```

这已经足够承载你的核心架构了。

后面再逐渐长出：
- `interfaces/`
- `internal/`
- `entrypoints/`
- `tests/`

---
## 推荐的下一步落地顺序
写完这份文档后，最合适的不是继续写更多抽象文档，  
而是开始把目录和 option 设计对齐。

推荐顺序如下：

### 1. 写 `option-schema.md`
把：
- `users`
- `hosts`
- `relations`

真正映射成 option 结构规范。

### 2. 创建最小目录骨架
至少建出：
- `modules/source`
- `modules/normalize`
- `modules/validate`
- `modules/instantiate`
- `modules/context`
- `modules/projection`
- `modules/assembly`
- `users`
- `hosts`
- `relations`

### 3. 先实现最小闭环
先只跑通一条最小流水线：
- 一个 user
- 一个 host
- 一个 relation
- 一条 normalize
- 一条 instantiate
- 一个 current
- 一个简单 projector
- 一个简单 assemble

### 4. 再扩展语义模块
比如：
- packages
- programs
- membership
- theme

---
## 一句话总结
`directory-layout.md` 规定的是：
- 哪些目录承载声明数据
- 哪些目录承载解析阶段
- 哪些目录承载投影与组装
- 哪些目录是公共接口
- 哪些目录只是内部实现

它的核心目标只有一个：
> 让仓库目录本身就能看出 `nix-flake-config` 的架构骨架，而不是让实现重新滑回按软件堆叠、按历史偶然性增长的混乱结构。
