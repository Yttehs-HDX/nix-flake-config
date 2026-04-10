# Option Schema
## 目标
本文档定义 `nix-flake-config` 的声明层 option schema。

它回答的问题是：
- `profile.users.*` 可以写哪些字段
- `profile.hosts.*` 可以写哪些字段
- `profile.relations.*` 可以写哪些字段
- 每个字段的类型是什么
- 每个字段的默认值是什么
- 哪些字段必须显式填写
- 哪些字段允许为 `null`
- 哪些字段属于公共声明接口
- 哪些字段只能由系统内部派生

这份文档的定位非常明确：
> 它不是实现代码，但它应该足够精确到可以直接映射为 Nix options。

也就是说，写完这份文档后，下一步进入 `modules/source/` 时，不应该再靠感觉命名字段、随手决定默认值、临时改变层级结构。

---
## 与前面文档的关系
这份文档建立在以下文档之上：
- `core-concepts.md`：定义术语
- `data-model.md`：定义对象结构
- `resolution-flow.md`：定义数据流
- `module-boundaries.md`：定义阶段归属
- `directory-layout.md`：定义仓库映射

其中：
- `data-model.md` 定义“对象应该长什么样”
- `option-schema.md` 定义“这些对象在声明层到底如何被写成 options”

所以它是从抽象数据模型进入具体 option 设计的桥梁。

---
## 设计原则
在定义具体 schema 之前，先冻结几条原则。

### 1. Schema 只定义 Source Model
本文档只定义用户可写的声明层 schema，也就是：
- `profile.users`
- `profile.hosts`
- `profile.relations`

它不定义：
- `normalized`
- `instances`
- `current`
- `projectionInputs`
- backend outputs

这些都属于派生层或实现层。

---
### 2. 字段归属必须服从数据模型
如果某字段在 `data-model.md` 中被判定为属于 `Relation`，  
那么它就不应出现在 `User` 或 `Host` 的 option schema 中。

这条原则比“写起来顺不顺手”更重要。

---
### 3. 默认值必须服务于稳定解析，而不是偷渡语义
默认值的职责是：
- 让结构稳定
- 减少无意义样板
- 方便 normalize 阶段处理

默认值不应偷偷表达强语义判断。

例如：
- `enable = true` 是合理默认
- `desktop.enable = true` 作为所有用户默认值，就不合理

---
### 4. 类型设计优先表达语义，而不是贴 backend 路径
字段应先表达“这是什么”，  
而不是先表达“最后写到哪个 Nix 节点”。

例如：
- `preferences.shell`
- `theme.accent`
- `activation.desktop.enable`

这些都是语义字段。

而像：
- `home-manager.programs.zsh.enable`
- `nixos.users.users.<name>.shell`

不应出现在 Source Model schema 中。

---
### 5. 可空值必须有明确意义
如果某字段允许 `null`，必须能回答：
> `null` 代表未指定、交给后续推导，还是显式无值？

不能随便把不确定都塞给 `null`。

---
## Schema 总览
顶层推荐 schema 形态如下：
```nix
profile = {
  users = attrsOf User;
  hosts = attrsOf Host;
  relations = attrsOf Relation;
};

```
其中：
- `users`：键为 `userId`
- `hosts`：键为 `hostId`
- `relations`：键为 `relationId`

---
## 顶层 Schema
## `profile`
### 类型
attrset

### 必填
是

### 说明
整个配置系统的声明根节点。

---
## `profile.users`
### 类型
`attrsOf User`

### 默认值
空 attrset

### 必填
否，但通常应存在

### 说明
保存所有用户声明对象。  
key 即 `userId`。

---
## `profile.hosts`
### 类型
`attrsOf Host`

### 默认值
空 attrset

### 必填
否，但通常应存在

### 说明
保存所有主机声明对象。  
key 即 `hostId`。

---
## `profile.relations`
### 类型
`attrsOf Relation`

### 默认值
空 attrset

### 必填
否，但通常应存在

### 说明
保存所有关系声明对象。  
key 即 `relationId`，推荐使用 `userId@hostId`。

---
# User Schema
## 定义
`User` 表示用户级声明对象。

它应描述：
- 长期用户偏好
- 用户能力
- 用户软件与程序意图
- 用户主题语义
- 可跨主机复用的个人配置模型

它不应描述：
- 某台主机上的实例身份
- 某台主机上的用户组
- 某台主机上的 uid
- 某台主机上的 home 路径

---
## User 总体结构
推荐结构如下：
```nix
User = {
  enable = true;

  meta = {
    displayName = null;
    description = null;
    tags = [ ];
  };

  preferences = {
    shell = null;
    editor = null;
    terminal = null;
  };

  capabilities = {
    desktop.enable = false;
    development.enable = false;
    theme.enable = false;
  };

  packages = {
    common = [ ];
  };

  programs = { };

  services = { };

  theme = { };

  policy = { };
};

```
---
## `profile.users.<userId>.enable`
### 类型
bool

### 默认值
`true`

### 必填
否

### 含义
表示该用户声明对象是否启用。

### 说明
若为 `false`：
- 该用户不应参与正常实例化
- 任何引用它的 relation 应在校验或实例化阶段报错，或被标记为不可实例化

---
## `profile.users.<userId>.meta`
### 类型
submodule

### 默认值
空结构

### 必填
否

### 说明
仅用于说明性信息与分类，不直接参与核心投影。

---
## `profile.users.<userId>.meta.displayName`
### 类型
null or string

### 默认值
`null`

### 含义
用户可读名称，用于展示与文档化。

---
## `profile.users.<userId>.meta.description`
### 类型
null or string

### 默认值
`null`

### 含义
用户说明文本。

---
## `profile.users.<userId>.meta.tags`
### 类型
list of string

### 默认值
空列表

### 含义
用于分类、筛选或语义标签。

---
## `profile.users.<userId>.preferences`
### 类型
submodule

### 默认值
空结构

### 必填
否

### 说明
表达用户级默认偏好。

这些偏好是语义型偏好，不是 backend 路径。

---
## `profile.users.<userId>.preferences.shell`
### 类型
null or string

### 默认值
`null`

### 含义
用户偏好的默认 shell。

### 说明
`null` 表示未指定，允许后续由投影层、策略层或其他默认机制决定。

---
## `profile.users.<userId>.preferences.editor`
### 类型
null or string

### 默认值
`null`

### 含义
用户偏好的默认编辑器。

---
## `profile.users.<userId>.preferences.terminal`
### 类型
null or string

### 默认值
`null`

### 含义
用户偏好的默认终端。

---
## `profile.users.<userId>.capabilities`
### 类型
submodule

### 默认值
空结构，但每个已知 capability 默认关闭

### 必填
否

### 说明
表达用户“允许参与实例化和投影的能力集合”。

这里不是“所有主机都启用”，  
而是“这个用户具备这些能力的声明空间”。

---
## `profile.users.<userId>.capabilities.desktop.enable`
### 类型
bool

### 默认值
`false`

### 含义
该用户是否声明桌面能力。

### 说明
若为 `false`，任何 relation 都不应越权启用桌面能力。

---
## `profile.users.<userId>.capabilities.development.enable`
### 类型
bool

### 默认值
`false`

### 含义
该用户是否声明开发能力。

---
## `profile.users.<userId>.capabilities.theme.enable`
### 类型
bool

### 默认值
`false`

### 含义
该用户是否声明主题能力。

---
## 扩展 capability 的规范
后续若新增 capability，应满足：
- 名称具备语义稳定性
- 不直接绑定某个 backend
- 能被 Host capability 与 Relation activation 一起参与能力交集解析

例如未来可以扩展：
- `cli.enable`
- `gaming.enable`
- `audio.enable`

但不推荐直接出现：
- `nixos.enable`
- `home-manager.enable`

因为那不是用户能力，而是 backend 语义。

---
## `profile.users.<userId>.packages`
### 类型
submodule

### 默认值
空结构

### 说明
表达用户长期持有的软件需求。

推荐按语义类别组织，而不是一开始完全平铺。

---
## `profile.users.<userId>.packages.common`
### 类型
list of package-like value

### 默认值
空列表

### 含义
所有主机上都可能参与投影的公共软件集合。

### 说明
这里的 `package-like value` 在实现层可具体定义为：
- package
- derivation
- package reference

本文档只冻结语义，不强行绑定底层实现表示。

---
## 是否允许更多 package 分组
推荐允许扩展以下字段，但不要过早固定太多：
- `development`
- `desktop`
- `cli`

若项目当前阶段还不想复杂化，可以暂时只实现 `common`，  
其余保留为未来扩展空间。

---
## `profile.users.<userId>.programs`
### 类型
attrsOf ProgramDeclaration

### 默认值
空 attrset

### 说明
表达用户级程序意图。

推荐 key 为程序语义名，例如：
- `git`
- `zsh`
- `neovim`

而 value 为统一的小型 declaration submodule。

---
## `ProgramDeclaration` 推荐结构
```nix
ProgramDeclaration = {
  enable = false;
  package = null;
  settings = { };
};

```
这是推荐最小形态，不要求一开始实现所有字段。

---
## `profile.users.<userId>.programs.<name>.enable`
### 类型
bool

### 默认值
`false`

### 含义
用户是否声明启用该程序语义。

---
## `profile.users.<userId>.programs.<name>.package`
### 类型
null or package-like value

### 默认值
`null`

### 含义
该程序可选的包实现覆盖。

### 说明
如果为 `null`，通常由 projector 或 backend adapter 使用默认包。

---
## `profile.users.<userId>.programs.<name>.settings`
### 类型
attrset

### 默认值
空 attrset

### 含义
该程序的语义级配置参数。

### 约束
这里应尽量保持程序语义配置，而不是直接塞 backend-specific 路径。

---
## `profile.users.<userId>.services`
### 类型
attrsOf ServiceDeclaration

### 默认值
空 attrset

### 说明
表达用户级服务意图。

和 `programs` 类似，建议采用统一 declaration 形态。

---
## `ServiceDeclaration` 推荐结构
```nix
ServiceDeclaration = {
  enable = false;
  settings = { };
};

```
---
## `profile.users.<userId>.theme`
### 类型
submodule

### 默认值
空结构

### 说明
表达主题语义，而不是 toolkit-specific 实现。

建议仅在 `capabilities.theme.enable = true` 时参与有效投影。

---
## `profile.users.<userId>.theme.name`
### 类型
null or string

### 默认值
`null`

### 含义
主题名称，例如 `catppuccin`。

---
## `profile.users.<userId>.theme.accent`
### 类型
null or string

### 默认值
`null`

### 含义
主题强调色。

---
## `profile.users.<userId>.theme.flavor`
### 类型
null or string

### 默认值
`null`

### 含义
主题风味，例如 `mocha`。

---
## `profile.users.<userId>.theme.fonts`
### 类型
submodule

### 默认值
空结构

### 说明
表达字体语义集合。

---
## `profile.users.<userId>.theme.fonts.sans`
### 类型
null or string

### 默认值
`null`

---
## `profile.users.<userId>.theme.fonts.mono`
### 类型
null or string

### 默认值
`null`

---
## `profile.users.<userId>.theme.fonts.emoji`
### 类型
null or string

### 默认值
`null`

---
## `profile.users.<userId>.policy`
### 类型
attrset

### 默认值
空 attrset

### 说明
用于表达用户级规则与策略开关。

### 约束
必须保持主机无关。  
若某策略只对某个实例成立，应放入 `Relation.policy`，而不是这里。

---
## User Schema 中明确禁止的字段
以下字段不应出现在 `User` schema 中：
- `username`
- `uid`
- `gid`
- `homeDirectory`
- `extraGroups`
- `primaryGroup`
- `host`
- `hosts`
- `deployments`
- `home.stateVersion`

若需要这些字段，应通过 `Relation` 表达。

---
# Host Schema
## 定义
`Host` 表示主机级声明对象。

它描述一台主机自身的事实、能力与系统环境。

---
## Host 总体结构
推荐结构如下：
```nix
Host = {
  enable = true;

  meta = {
    displayName = null;
    description = null;
    tags = [ ];
  };

  backend = {
    type = "nixos";
  };

  platform = {
    system = null;
  };

  capabilities = {
    system.enable = false;
    home.enable = false;
    desktop.enable = false;
    userManagement.enable = false;
  };

  roles = [ ];

  system = { };

  hardware = { };

  networking = { };

  security = { };

  desktop = { };

  packages = {
    system = [ ];
  };

  policy = { };
};

```
---
## `profile.hosts.<hostId>.enable`
### 类型
bool

### 默认值
`true`

### 含义
该主机声明对象是否启用。

---
## `profile.hosts.<hostId>.meta`
### 类型
submodule

### 默认值
空结构

### 说明
说明性字段，不直接承担核心投影职责。

---
## `profile.hosts.<hostId>.meta.displayName`
### 类型
null or string

### 默认值
`null`

---
## `profile.hosts.<hostId>.meta.description`
### 类型
null or string

### 默认值
`null`

---
## `profile.hosts.<hostId>.meta.tags`
### 类型
list of string

### 默认值
空列表

---
## `profile.hosts.<hostId>.backend`
### 类型
submodule

### 默认值
完整结构

### 说明
描述该主机采用的 backend 类型。

---
## `profile.hosts.<hostId>.backend.type`
### 类型
enum

### 可选值
- `home-manager`
- `nixos`
- `nix-darwin`

### 默认值
建议不要强行给全局默认值；若当前实现必须有默认，可暂时设为 `nixos`

### 推荐策略
从 schema 设计角度，更推荐将其设为：
- 必填字段
- 或实现层在未填写时明确报错

### 原因
backend 类型是主机的核心身份，过于关键，不适合隐藏在默认值里。

---
## `profile.hosts.<hostId>.platform`
### 类型
submodule

### 默认值
空结构

### 说明
描述平台相关信息。

---
## `profile.hosts.<hostId>.platform.system`
### 类型
null or string

### 默认值
`null`

### 含义
平台系统字符串，例如：
- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin`

### 说明
`null` 表示尚未声明，允许由更高层入口或外部组合时补充，但推荐在实际主机声明中尽量显式填写。

---
## `profile.hosts.<hostId>.capabilities`
### 类型
submodule

### 默认值
空结构，但已知 capability 默认关闭

### 说明
描述主机承载能力。

---
## `profile.hosts.<hostId>.capabilities.system.enable`
### 类型
bool

### 默认值
`false`

### 含义
该主机是否具备 system scope。

---
## `profile.hosts.<hostId>.capabilities.home.enable`
### 类型
bool

### 默认值
`false`

### 含义
该主机是否具备 home scope。

---
## `profile.hosts.<hostId>.capabilities.desktop.enable`
### 类型
bool

### 默认值
`false`

### 含义
该主机是否能够承载桌面能力。

---
## `profile.hosts.<hostId>.capabilities.userManagement.enable`
### 类型
bool

### 默认值
`false`

### 含义
该主机是否支持系统级用户管理能力。

---
## Host capability 与 backend 的关系
部分 capability 在语义上可由 backend 派生，例如：
- `nixos` 通常意味着 `system.enable = true`
- `home-manager` 通常意味着 `home.enable = true`

但在 Source Schema 中，仍允许显式声明这些字段。  
原因是：
- 它们是主机能力语义的一部分
- 规范层应允许可读、可检查的能力声明
- 派生与校验可以在后续阶段决定是否自动补齐或验证一致性

---
## `profile.hosts.<hostId>.roles`
### 类型
list of string

### 默认值
空列表

### 含义
主机逻辑角色列表，例如：
- `desktop`
- `laptop`
- `server`
- `workstation`
- `builder`

### 说明
角色用于分类和条件投影，  
但不应被当作某种无约束万能开关。

---
## `profile.hosts.<hostId>.system`
### 类型
attrset

### 默认值
空 attrset

### 说明
存放主机系统级语义配置。

### 约束
这里只允许主机本体语义。  
不允许偷偷塞某用户的个人偏好。

### 当前实现要求
当启用主机且 `backend.type` 为 `nixos` 或 `nix-darwin` 时，
实现层会要求 `system.stateVersion` 已经声明，
以便在校验阶段尽早失败，而不是拖到最终 backend 组装阶段。

---
## `profile.hosts.<hostId>.hardware`
### 类型
attrset

### 默认值
空 attrset

### 含义
硬件相关配置语义空间。

---
## `profile.hosts.<hostId>.networking`
### 类型
attrset

### 默认值
空 attrset

### 含义
网络相关配置语义空间。

---
## `profile.hosts.<hostId>.security`
### 类型
attrset

### 默认值
空 attrset

### 含义
安全策略与相关语义空间。

---
## `profile.hosts.<hostId>.desktop`
### 类型
attrset

### 默认值
空 attrset

### 含义
主机级桌面基础设施相关语义空间。

### 说明
这里描述的是主机能承载什么桌面基础设施，  
不是某个用户对桌面的长期偏好。

---
## `profile.hosts.<hostId>.packages`
### 类型
submodule

### 默认值
空结构

### 含义
主机级软件需求。

---
## `profile.hosts.<hostId>.packages.system`
### 类型
list of package-like value

### 默认值
空列表

### 含义
系统级软件集合。

---
## `profile.hosts.<hostId>.policy`
### 类型
attrset

### 默认值
空 attrset

### 含义
主机级规则与策略。

---
## Host Schema 中明确禁止的字段
以下内容不应直接出现在 `Host` schema 中：
- 某个用户的 `editor`
- 某个用户的 `theme`
- 某个用户的 `programs`
- 某个用户实例的 `username`
- 某个用户实例的 `uid`
- 某个用户实例的 `extraGroups`

这些分别属于 `User` 或 `Relation`。

---
# Relation Schema
## 定义
`Relation` 表示一个用户在一台主机上的实例化绑定关系。

它是：
- `User`
- `Host`

走向实例的唯一合法入口。

---
## Relation 总体结构
推荐结构如下：
```nix
Relation = {
  enable = true;

  user = null;
  host = null;

  identity = {
    name = null;
    uid = null;
    homeDirectory = null;
  };

  membership = {
    primaryGroup = null;
    extraGroups = [ ];
  };

  activation = {
    desktop.enable = null;
    development.enable = null;
    theme.enable = null;
  };

  state = {
    home.stateVersion = null;
  };

  policy = { };

  overrides = { };
};

```
---
## `profile.relations.<relationId>.enable`
### 类型
bool

### 默认值
`true`

### 含义
该 relation 是否启用。

---
## `profile.relations.<relationId>.user`
### 类型
string

### 默认值
无

### 必填
是

### 含义
引用的 `userId`。

### 说明
必须显式填写。  
不允许通过路径、文件名或上下文隐式推导。

---
## `profile.relations.<relationId>.host`
### 类型
string

### 默认值
无

### 必填
是

### 含义
引用的 `hostId`。

### 说明
必须显式填写。

---
## `profile.relations.<relationId>.identity`
### 类型
submodule

### 默认值
空结构

### 含义
该用户在该主机上的实例身份。

---
## `profile.relations.<relationId>.identity.name`
### 类型
null or string

### 默认值
`null`

### 含义
该实例在目标主机上的用户名。

### 推荐策略
若当前系统明确要求每个实例都有确定用户名，则此字段应在 normalize 或 validation 后成为必有值。  
但在 source schema 中允许 `null`，表示“尚未显式指定”。

---
## `profile.relations.<relationId>.identity.uid`
### 类型
null or int

### 默认值
`null`

### 含义
该实例在目标主机上的 UID。

### 说明
若目标主机不具备 system scope，则后续阶段应校验其合法性。

---
## `profile.relations.<relationId>.identity.homeDirectory`
### 类型
null or string

### 默认值
`null`

### 含义
该实例在目标主机上的 home 路径。

### 说明
若未显式填写，当前实现会在 context 阶段按 backend 推导默认值：
- `nix-darwin` 默认为 `/Users/<name>`
- 其他当前已实现 backend 默认为 `/home/<name>`

---
## `profile.relations.<relationId>.membership`
### 类型
submodule

### 默认值
空结构

### 含义
该实例在目标主机上的成员关系。

---
## `profile.relations.<relationId>.membership.primaryGroup`
### 类型
null or string

### 默认值
`null`

### 含义
该实例主组。

---
## `profile.relations.<relationId>.membership.extraGroups`
### 类型
list of string

### 默认值
空列表

### 含义
附加组列表。

### 说明
通常只在具备 system scope 的 host 上可合法投影。

---
## `profile.relations.<relationId>.activation`
### 类型
submodule

### 默认值
空结构

### 含义
该实例启用哪些能力。

### 说明
这是实例级能力启用层。

它与 `User.capabilities` 的关系是：
- `User.capabilities`：用户允许哪些能力存在
- `Relation.activation`：该实例启用哪些能力

---
## `profile.relations.<relationId>.activation.desktop.enable`
### 类型
null or bool

### 默认值
`null`

### 含义
该实例是否启用桌面能力。

### 为什么允许 `null`
因为 `null` 在这里有明确语义：
- 未显式指定
- 交由后续规则或默认推导决定

它不等于显式 `false`。

---
## `profile.relations.<relationId>.activation.development.enable`
### 类型
null or bool

### 默认值
`null`

---
## `profile.relations.<relationId>.activation.theme.enable`
### 类型
null or bool

### 默认值
`null`

---
## Relation activation 的校验语义
后续阶段必须保证：
- 若 `User.capabilities.<x>.enable = false`
- 则 `Relation.activation.<x>.enable = true` 非法

也就是说，relation 可以收缩启用范围，不能越权扩张用户语义空间。

---
## `profile.relations.<relationId>.state`
### 类型
submodule

### 默认值
空结构

### 含义
实例级状态字段。

---
## `profile.relations.<relationId>.state.home.stateVersion`
### 类型
null or string

### 默认值
`null`

### 含义
该实例的 home 状态版本。

### 说明
之所以属于 relation，而不是 user，是因为不同主机实例可能采用不同的状态迁移节奏。

---
## `profile.relations.<relationId>.policy`
### 类型
attrset

### 默认值
空 attrset

### 含义
实例级规则与策略开关。

### 说明
只有那些明确属于“用户-主机组合态”的规则才适合放这里。

---
## `profile.relations.<relationId>.overrides`
### 类型
attrset

### 默认值
空 attrset

### 含义
受控的实例级覆盖空间。

### 重要边界
它不是一个任意覆盖所有上游字段的逃生舱。  
保留这个字段的前提是：后续实现必须采用白名单式解释。

也就是说：
- 可以允许少量受控 override
- 不允许它变成“想改啥就改啥”的洞

### 当前推荐策略
在项目早期，甚至可以先保留字段但不开放实际能力，  
等真正需要时再引入明确白名单。

---
## Relation Schema 中明确禁止的字段
以下字段不应直接出现在 `Relation` 中：
- 某用户的长期 `editor`
- 某用户长期 `theme.name`
- 某用户长期 `programs.git.enable`
- 主机本体 `backend.type`
- 主机本体 `platform.system`
- 主机本体 `hardware`

这些分别属于 `User` 或 `Host`。

---
# 共享声明类型
为了让 option 设计可实现，下面冻结几类共享声明类型。

---
## `Meta`
推荐结构：
```nix
Meta = {
  displayName = null;
  description = null;
  tags = [ ];
};

```
---
## `CapabilitySwitch`
推荐结构：
```nix
CapabilitySwitch = {
  enable = false;
};

```
---
## `ActivationSwitch`
推荐结构：
```nix
ActivationSwitch = {
  enable = null;
};

```
### 区别
- `CapabilitySwitch` 默认 `false`
- `ActivationSwitch` 默认 `null`

原因是：
- capability 表示对象自有声明空间，默认关闭合理
- activation 表示实例是否显式启用，默认未指定更合理

---
## `ProgramDeclaration`
推荐结构：
```nix
ProgramDeclaration = {
  enable = false;
  package = null;
  settings = { };
};

```
---
## `ServiceDeclaration`
推荐结构：
```nix
ServiceDeclaration = {
  enable = false;
  settings = { };
};

```
---
## `ThemeDeclaration`
推荐结构：
```nix
ThemeDeclaration = {
  name = null;
  accent = null;
  flavor = null;

  fonts = {
    sans = null;
    mono = null;
    emoji = null;
  };
};

```
---
# 字段必填性规则
为了避免写 option 时又反复犹豫，下面直接冻结哪些字段必须显式填写。

---
## 顶层对象是否必填
### `profile.users`
不是严格必填，但应默认存在为空集

### `profile.hosts`
不是严格必填，但应默认存在为空集

### `profile.relations`
不是严格必填，但应默认存在为空集

---
## User 中哪些字段必填
严格来说，`User` 没有必须显式填写的内部字段。  
只要对象存在，就可以依赖默认值形成合法最小结构。

这符合“用户声明可以逐步长大”的需求。

---
## Host 中哪些字段必填
推荐至少要求：
- `backend.type`

其他字段可暂时允许依赖默认值或后续补充。

若项目当前想更保守，也可以把：
- `platform.system`

视为建议必填，但不是 schema 级硬必填。

---
## Relation 中哪些字段必填
必须显式填写：
- `user`
- `host`

其他实例字段允许为空或缺省。

---
# 默认值规范
下面对默认值再做一次统一总结。

---
## 通用默认值
### `enable`
默认 `true`

适用于：
- `User.enable`
- `Host.enable`
- `Relation.enable`

---
## 元数据字段
### `displayName`
默认 `null`

### `description`
默认 `null`

### `tags`
默认空列表

---
## capability 字段
默认 `false`

---
## activation 字段
默认 `null`

---
## 程序与服务 enable
默认 `false`

---
## attrset 类字段
默认空 attrset

适用于：
- `policy`
- `settings`
- `system`
- `hardware`
- `networking`
- `security`
- `desktop`

---
## list 类字段
默认空列表

适用于：
- `tags`
- `roles`
- `packages.*`
- `extraGroups`

---
# Null 的语义规范
为了避免后续实现混乱，明确规定 `null` 的含义。

---
## 在 `preferences.*` 中
`null` 表示未声明偏好。  
允许后续由默认策略决定。

---
## 在 `theme.*` 中
`null` 表示该主题字段未显式指定。  
不等于显式禁用主题能力。

---
## 在 `identity.*` 中
`null` 表示该实例身份字段尚未显式指定。  
后续可由 normalization、policy 或外部约定补齐。

---
## 在 `activation.*.enable` 中
`null` 表示该实例未显式声明启用与否。  
这是“未指定”，不是“关闭”。

---
## 在 `backend.type` 中
不推荐允许 `null`。  
因为主机 backend 身份过于关键。

---
# 公共接口字段与私有字段
本节定义哪些字段属于公共声明接口。

---
## 公共声明接口
以下字段应视为稳定声明接口的一部分：
- `enable`
- `meta.*`
- `preferences.*`
- `capabilities.*`
- `packages.*`
- `programs.*`
- `services.*`
- `theme.*`
- `backend.type`
- `platform.system`
- `roles`
- `identity.*`
- `membership.*`
- `activation.*`
- `state.home.stateVersion`
- `policy`
- `overrides`

这些字段可以出现在文档、source options、公共 schema 中。

---
## 私有字段
以下命名空间或命名风格不属于 Source Schema：
- `_internal`
- `_normalized`
- `_cache`
- `_derived`
- `_projection`
- `_tmp`

它们只能属于内部实现层，  
不应被写进 `option-schema.md` 的声明层规范。

---
# 最小可行 Option 子集
如果项目现在不想一次实现所有 schema，  
推荐先落一个最小可行子集。

---
## 最小 User 子集
```nix
User = {
  enable = true;
  preferences = {
    shell = null;
    editor = null;
    terminal = null;
  };
  capabilities = {
    desktop.enable = false;
    development.enable = false;
    theme.enable = false;
  };
  packages = {
    common = [ ];
  };
  programs = { };
  theme = { };
};

```
---
## 最小 Host 子集
```nix
Host = {
  enable = true;
  backend.type = ...;
  platform.system = null;
  capabilities = {
    system.enable = false;
    home.enable = false;
    desktop.enable = false;
    userManagement.enable = false;
  };
  roles = [ ];
};

```
---
## 最小 Relation 子集
```nix
Relation = {
  enable = true;
  user = ...;
  host = ...;

  identity = {
    name = null;
  };

  membership = {
    extraGroups = [ ];
  };

  activation = {
    desktop.enable = null;
    development.enable = null;
    theme.enable = null;
  };

  state = {
    home.stateVersion = null;
  };
};

```
---
## 为什么推荐先从最小子集开始
因为你下一步更重要的事情不是把所有字段都一次实现完，  
而是先跑通完整骨架：
- source
- normalize
- validate
- instantiate
- current
- project
- assemble

只要这条链跑通，剩余字段都能稳定扩展。  
反过来，如果骨架没跑通，字段越多，反而越容易乱。

---
# 示例声明
下面给出一份符合本 schema 的示例。

```nix
profile = {
  users = {
    alice = {
      meta = {
        displayName = "Alice";
        tags = [ "desktop" "dev" ];
      };

      preferences = {
        shell = "zsh";
        editor = "nvim";
        terminal = "ghostty";
      };

      capabilities = {
        desktop.enable = true;
        development.enable = true;
        theme.enable = true;
      };

      packages = {
        common = [ git ripgrep ];
      };

      programs = {
        git.enable = true;
        zsh.enable = true;
        neovim.enable = true;
      };

      theme = {
        name = "catppuccin";
        accent = "lavender";
        flavor = "mocha";
        fonts = {
          mono = "JetBrainsMono Nerd Font";
        };
      };
    };
  };

  hosts = {
    laptop = {
      backend.type = "nixos";
      platform.system = "x86_64-linux";

      capabilities = {
        system.enable = true;
        home.enable = true;
        desktop.enable = true;
        userManagement.enable = true;
      };

      roles = [ "desktop" "laptop" ];
    };
  };

  relations = {
    "alice@laptop" = {
      user = "alice";
      host = "laptop";

      identity = {
        name = "alice";
        uid = 1000;
        homeDirectory = "/home/alice";
      };

      membership = {
        extraGroups = [ "wheel" "networkmanager" ];
      };

      activation = {
        desktop.enable = true;
        development.enable = true;
        theme.enable = true;
      };

      state = {
        home.stateVersion = "25.05";
      };
    };
  };
};

```
---
# 与 Nix Option 实现的映射建议
虽然本文档不是实现代码，但为了帮助下一步落地，这里给出直接指导。

---
## 推荐使用 submodule 的部分
以下字段推荐在实现中使用 `types.submodule`：
- `User`
- `Host`
- `Relation`
- `meta`
- `preferences`
- `capabilities`
- `packages`
- `theme`
- `identity`
- `membership`
- `activation`
- `state`

---
## 推荐使用 attrsOf submodule 的部分
以下字段推荐使用 `attrsOf (submodule ...)`：
- `profile.users`
- `profile.hosts`
- `profile.relations`
- `programs`
- `services`

---
## 推荐使用 enum 的部分
以下字段推荐使用 enum：
- `backend.type`

未来如果 capability 名称集合需要更严格，也可以局部引入 enum，但当前阶段未必必要。

---
## 推荐使用 nullOr 的部分
以下字段推荐使用 `nullOr`：
- `preferences.*`
- `theme.*`
- `identity.*`
- `membership.primaryGroup`
- `activation.*.enable`
- `state.home.stateVersion`
- `platform.system`

---
# 一句话总结
`option-schema.md` 规定的是：
- `profile.users.*`
- `profile.hosts.*`
- `profile.relations.*`

这些声明层对象到底有哪些字段、字段类型是什么、默认值是什么、哪些是必填、哪些允许为空、哪些字段绝不能跨对象乱放。

它的核心目标只有一个：
> 让 `nix-flake-config` 的声明层在进入 Nix module 实现之前，就已经拥有稳定、清晰、可执行的 option 形状。
