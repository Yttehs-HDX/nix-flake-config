# Data Model
## 目标
本文档定义 `nix-flake-config` 的数据模型规范。

它回答的问题不是“模块怎么写”，而是：
- 顶层配置对象有哪些
- 每类对象允许声明什么
- 每类对象不允许声明什么
- 对象之间如何引用
- 系统如何从手写配置得到可落地的实例模型

这份文档的意义在于冻结结构边界。  
后续无论目录如何调整、模块如何拆分、实现如何演化，这些数据模型都应尽量保持稳定。

---
## 为什么这一层必须先定义
在 `vision.md` 中，项目已经明确了方向：  
这是一个面向多用户、多主机、多后端的声明式配置编排系统。

在 `architecture.md` 中，项目已经明确了对象边界：  
- `User`
- `Host`
- `Relation`
- `Backend`
- `Projection`
- `Instance`

在 `core-concepts.md` 中，项目已经明确了术语语义。

因此，下一步自然不是直接写实现，而是先定义这些对象在配置中“到底长什么样”。

如果不先定义数据模型，后续很容易发生以下问题：
- 本应属于 `Relation` 的字段被塞进 `User`
- 本应属于 `Host` 的字段被塞进 `User`
- 某些模块绕开结构边界，直接读取临时字段
- 同一个概念在不同模块中拥有不同命名
- 运行时需要的上下文信息没有稳定来源

所以，`data-model.md` 的目的就是：  
**在进入实现之前，先冻结输入结构与归属边界。**

---
## 模型分层
本项目的数据模型分为四层，但只有前两层允许被用户直接声明。

### 1. Source Model
`Source Model` 是用户手写的原始配置模型。  
它由以下三个顶层对象组成：
- `users`
- `hosts`
- `relations`

这是最重要的输入层。

---
### 2. Normalized Model
`Normalized Model` 是系统在读取 `Source Model` 之后生成的规范化模型。  
它负责：
- 补默认值
- 校验引用关系
- 生成稳定 ID
- 消除歧义
- 将松散写法整理为统一结构

这一层通常不应由用户手写。

---
### 3. Instance Model
`Instance Model` 是系统根据 `Relation`、`User`、`Host` 组合后生成的实例模型。

它回答的是：
- 某个用户在某台主机上的具体实例是什么
- 这个实例运行在哪个 backend 上
- 它有哪些 scope
- 它能启用哪些能力
- 它最终将参与哪些投影

这一层是实现层最重要的输入。

---
### 4. Realized Model
`Realized Model` 是最终生成的 backend 配置结果。  

例如：
- `nixosConfigurations.<name>`
- `homeConfigurations.<name>`
- `darwinConfigurations.<name>`

这一层是输出，不属于手写数据模型。

---
## 顶层结构
推荐将整个项目的声明入口组织为如下结构：
```nix
{
  profile = {
    users = { ... };
    hosts = { ... };
    relations = { ... };
  };
}
```

其中：
- `profile.users`：用户声明集合
- `profile.hosts`：主机声明集合
- `profile.relations`：用户与主机的关系集合

`profile` 只是当前推荐的根名称。  
即使未来根路径调整，上述三个核心对象的语义也不应改变。

---
## 统一约束
在定义具体模型之前，先定义几条统一约束。

### 1. 所有对象必须有稳定 ID
`users`、`hosts`、`relations` 都必须通过稳定 ID 被引用。ID 应该是语义稳定的，而不是由文件路径或目录位置隐式决定。

推荐约定：
- `userId`：用户抽象身份 ID
- `hostId`：主机抽象身份 ID
- `relationId`：关系实例 ID

### 2. 引用必须显式，不允许隐式推断主体
例如：
```nix
Relation.user = "alice"
Relation.host = "laptop"
```

而不是通过文件路径、当前目录名或某个 import 顺序来猜测。

### 3. 一个字段只能有一个核心归属
例如：
- 用户偏好属于 `User`
- 主机硬件属于 `Host`
- 用户在某台主机上的组映射属于 `Relation`

不允许同一类语义在多个模型中重复拥有定义权。

### 4. 禁止把 backend 输出直接混进 Source Model
`Source Model` 用来表达意图与归属，不应直接塞入大段 backend 实现片段，除非未来专门设计了受控 escape hatch。

换句话说，手写层应优先表达“我要什么”，而不是直接写“生成哪个 Nix 节点”。

### 5. 私有字段与公共字段必须区分
推荐约定：
- 公开给其他模块稳定读取的字段：正常命名
- 内部计算、临时拼接、实现缓存字段：以下划线开头，例如 `_resolved`、`_internal`

模块可以依赖公共字段，  
但不应把私有字段当作稳定接口。

---
## 顶层数据模型
顶层模型定义如下：
```nix
Profile = {
  users = AttrSet User;
  hosts = AttrSet Host;
  relations = AttrSet Relation;
};
```

其中：
- `AttrSet User` 表示 `userId -> User`
- `AttrSet Host` 表示 `hostId -> Host`
- `AttrSet Relation` 表示 `relationId -> Relation`

---
## User Model
### 定义
`User` 表示用户级声明对象。  
它用于描述一个用户长期稳定的偏好、能力和需求，并且应尽量独立于具体主机存在。

### User 的职责
`User` 适合承载以下类型的信息：
- 用户长期软件偏好
- 用户 shell / editor / terminal 偏好
- 用户桌面体验偏好
- 用户主题偏好
- 用户开发环境偏好
- 用户级服务意图
- 用户能力声明
- 可跨主机复用的个人行为模型

### User 不应承载的内容
以下内容原则上不应直接放入 `User`：
- 某台主机专属硬件配置
- 某台主机专属服务
- 某台主机的网络配置
- 某台主机的引导配置
- 某台主机上的用户名映射
- 某台主机上的用户组分配
- 某台主机上的 UID / GID
- 某主机实例专属的 `home.stateVersion`
- 某后端专属且不可移植的落地细节

这些内容应当属于 `Host` 或 `Relation`。

### 推荐结构
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

  initialHashedPassword = null;

  capabilities = {
    desktop.enable = false;
    development.enable = false;
    theme.enable = false;
  };

  packages = { };

  programs = { };
  services = { };
  theme = { };
  policy = { };
};
```

### 字段说明
#### `enable`
是否启用该用户声明。  
禁用后，不代表 relation 自动消失，但系统在规范化阶段应报告不可部署状态或直接跳过相关实例。

#### `meta`
仅用于描述与分类，不参与核心投影逻辑。  
例如：
- `displayName`
- `description`
- `tags`

#### `preferences`
表达用户级默认偏好。  
例如：
- 默认 `shell`
- 默认编辑器
- 默认终端

它是语义型偏好，而不是 backend 节点路径。

#### `initialHashedPassword`
表达该用户在“首次创建系统账号时”可复用的初始密码哈希。  
它属于共享用户语义，而不是某台主机的局部细节，因为：
- host 只负责决定这个用户是否在该主机上启用
- relation 只负责实例身份、组、home 路径等实例化信息
- home-manager 不创建系统用户，因此不消费这类字段

当前这类语义主要会被具备系统用户管理能力的 backend 消费。  
对已经存在的账号，它不应被当作持续覆盖本机密码的声明式来源。

#### `capabilities`
表达用户“拥有哪些可被投影的能力”。  
这是一个很关键的字段。  
例如：
- 用户支持桌面体验
- 用户需要开发环境
- 用户支持主题系统

这里的意思不是“已经在所有主机上启用”，而是：
> 该用户声明允许这些能力参与实例化和投影。

也就是说，`User` 负责声明能力的存在可能性。

#### `packages`
表达用户级统一软件语义。  
这里的 key 应是稳定的软件语义名，例如：
- `git`
- `kitty`
- `direnv`
- `docker`

而 value 应尽量保持统一的小型 declaration 结构，例如：
- `enable`
- `settings`

这一层只表达“用户要这个软件能力”，  
不直接暴露它最终是 `programs.*`、`services.*`，还是包列表注入。

它描述的是用户级统一包/程序/服务能力入口。  
当前推荐做法是优先写入 `packages`，再由 normalize 统一整理。  
`programs` / `services` 若继续存在，也应被视为进入 `packages` 的过渡输入，而不是新的稳定 projector 接口。

#### `programs`
兼容旧声明形态保留的入口。  
它描述的仍然是用户软件意图，但在新架构里应被 normalize 到统一 `packages` 抽象，而不是由 projector 直接消费。

#### `services`
兼容旧声明形态保留的入口。  
它同样会被 normalize 到统一 `packages` 抽象。

#### `theme`
表达主题语义，而不是具体 toolkit 配置片段。  
例如：
- theme name
- accent
- flavor
- font family

这类字段应尽量保持语义稳定，便于不同模块读取后各自投影。

#### `policy`
存放用户级规则，但必须仍然保持主机无关。  
例如某些用户长期策略开关。  
如果某策略只在特定主机实例中有意义，则不应放在这里。

### User 的规范约束
#### 1. User 必须主机无关
`User` 不能通过内部字段直接绑定 `hostId`。  
也不应内嵌“我部署到哪些主机”这类拓扑信息。

#### 2. User 不拥有实例身份
以下字段不应直接属于 `User`：
- `username`
- `uid`
- `group`
- `extraGroups`
- `homeDirectory`

因为这些都属于“某个用户在某台主机上的实例身份”。

#### 3. `User` 可以声明能力，但不能假定所有主机都能实现
例如 `desktop.enable = true` 表示允许实例层选择启用，而不是要求所有主机必须启用。的意思不是“所有主机必须启用桌面”，  
而是“该用户支持桌面能力，允许实例层选择是否启用”。

---
## Host Model
### 定义
`Host` 表示主机级声明对象。  
它用于描述一台主机自身的事实、类型、能力与系统环境。

### Host 的职责
`Host` 适合承载以下类型的信息：
- backend 类型
- 平台类型
- 硬件信息
- 系统服务
- 网络配置
- 引导配置
- 文件系统
- 主机级安全策略
- 主机级桌面承载能力
- 主机自身的软件与系统包

### Host 不应承载的内容
以下内容不应直接属于 `Host`：
- 某个用户的长期偏好
- 某个用户的 editor / shell 选择
- 某个用户的主题偏好
- 某个用户的个人软件意图
- 某个用户在这台机器上的组分配明细
- 某个用户实例的用户名映射

这些要么属于 `User`，要么属于 `Relation`。

### 推荐结构
```nix
Host = {
  enable = true;

  meta = {
    displayName = null;
    description = null;
    tags = [ ];
  };

  backend = {
    type = "nixos"; # "home-manager" | "nixos" | "nix-darwin"
  };

  platform = {
    system = null; # e.g. "x86_64-linux"
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

  packages = { };

  policy = { };
};
```

### 字段说明
#### `backend.type`
这是 `Host` 最关键的字段之一。  
当前合法值为：
- `home-manager`
- `nixos`
- `nix-darwin`

#### `platform.system`
表达平台系统类型，例如：
- `x86_64-linux`
- `aarch64-linux`
- `aarch64-darwin`

#### `capabilities`
表达主机具备哪些实现能力。  
例如：
- 是否具备 `system` scope
- 是否具备 `home` scope
- 是否具备桌面环境承载能力
- 是否具备用户管理能力

其中部分能力可以从 backend 推导，  
但依然建议在规范模型中有明确语义位置。

#### `roles`
表达主机在逻辑上的角色，例如：
- `desktop`
- `laptop`
- `server`
- `builder`
- `workstation`

`roles` 主要用于语义分类和条件投影，  
不应被当作粗暴的实现开关滥用。

#### `system` / `hardware` / `networking` / `security` / `desktop`
这些字段都属于主机自身语义空间。  
它们可以继续向下拆分，但必须保持一个原则：
> 描述的是主机自己，而不是某个用户的实例。

#### `packages`
表达主机级统一软件语义。  
它适合承载：
- 系统级全局工具
- 主机级程序开关
- 主机级服务启用意图

与 `User.packages` 的区别在于：
- `User.packages` 表达个人长期偏好
- `Host.packages` 表达机器自身需要承载的系统级软件能力

#### `policy`
表达主机级策略，例如默认约束、安全策略、环境规则。

### Host 的规范约束
#### 1. Host 必须用户无关
`Host` 不应直接持有某个用户的长期偏好定义。

#### 2. Host 不拥有 Relation 语义
`Host` 不能直接定义“某个用户在本机上的具体身份映射”。

#### 3. Host 可以提供能力边界，但不能重写 User 本体语义

例如 Host 可以说：
- 本机没有桌面能力
- 本机不支持某类实现
- 本机是 Darwin

但不能直接说：
- 某个用户从此改用别的 editor
- 某个用户的 theme 被主机替换
- 某个用户的抽象程序偏好被主机重写

---
## Relation Model
### 定义
`Relation` 表示 `User` 与 `Host` 之间的关系对象。  
它是“用户实例化到主机”的唯一合法入口。

它回答的是：
- 哪个用户出现在什么主机上
- 该用户在该主机上的实例身份是什么
- 该实例启用了哪些能力
- 该实例附带哪些只属于组合态的参数

### 为什么 Relation 必须是一等公民
因为以下两种模型都不稳定：

#### 模型 A：用户直接选择主机
这样会让 `User` 携带过多部署拓扑信息，  
最终变成“半用户、半部署”的混合体。

#### 模型 B：主机直接选择用户
这样会让 `Host` 拥有过强控制权，  
容易反向吞掉 `User` 语义。

所以必须单独建立 `Relation`，  
让拓扑关系与主体本身解耦。

### 推荐结构
```nix
Relation = {
  enable = true;

  user = null; # userId
  host = null; # hostId

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

### 字段说明
#### `user`
引用某个 `userId`。  
必须显式存在，且目标用户必须在 `profile.users` 中存在。

#### `host`
引用某个 `hostId`。  
必须显式存在，且目标主机必须在 `profile.hosts` 中存在。

#### `identity`
表达该用户在该主机上的实例身份。  
例如：
- 实际用户名
- UID
- homeDirectory

注意：这些字段只属于实例，不属于抽象 `User`。

#### `membership`
表达该实例在该主机上的系统身份关系，例如：
- 主组
- 附加组

这类字段通常只会投影到具备 system scope 的 backend（例如 NixOS）。

#### `activation`
这是 `Relation` 中最重要的字段之一。

它表达的是：
> 在这个具体实例中，哪些用户能力被真正激活。

这意味着：
- `User.capabilities` 声明“可用能力”
- `Relation.activation` 声明“实例启用能力”

例如：
- 用户支持桌面能力
- 但在服务器 relation 中不启用桌面
- 在笔记本 relation 中启用桌面

这样就不会让“能力存在”与“实例启用”混为一谈。

#### `state`
表达实例级状态字段。  
例如 `home.stateVersion` 更适合放在这里，而不是抽象 `User`。

因为同一个用户在不同主机实例上，可能采用不同的状态版本或迁移节奏。

#### `policy`
表达组合态规则。  
例如某个实例是否是 primary user、某个实例是否允许自动创建用户等。

#### `overrides`
这是一个需要严格约束的字段。  
它不是用来随意重写 `User` 任意字段的。

它只应用于：
- 实例级参数补充
- 受控的小范围投影调整
- 只能在 relation 层表达的实例化差异

它**不应**允许这样做：
- `overrides.programs.git.enable = false` 来任意推翻用户长期偏好
- `overrides.theme.name = "..."` 偷偷改写用户本体主题

因此，`overrides` 如果保留，必须是**白名单式、受控的 override 空间**，而不是任意 attrset 漏斗。

### Relation 的规范约束
#### 1. 一个 Relation 只表示一个用户在一台主机上的一个实例
不允许一个 relation 同时绑定多个用户或多个主机。

#### 2. Relation 必须同时引用 `user` 和 `host`
不允许通过路径上下文省略任意一项。

#### 3. Relation 拥有实例身份，但不拥有用户本体语义
`Relation` 可以决定：
- 这个实例叫啥
- 这个实例在哪些组里
- 这个实例启用哪些能力

但不能任意发明用户本体没有声明的长期偏好。

#### 4. Relation 可以裁剪启用范围，但不能凭空创造 User 未声明的能力
例如：
```nix
User.capabilities.desktop.enable = true
Relation.activation.desktop.enable = false
```

这是合法的，因为 relation 只是关闭实例启用。

但如果：

```nix
User.capabilities.desktop.enable = false
Relation.activation.desktop.enable = true
```

这应当报错，或至少视为非法模型。

也就是说，Relation 可以收缩，但不能越权扩张用户语义空间。

---
## Relation ID 规范
推荐 `relationId` 使用如下稳定规则：
```text
${userId}@${hostId}
```

例如：
- `alice@laptop`
- `alice@workstation`
- `bob@server-a`

原因很简单：
- 它天然唯一
- 它直接表达实例语义
- 它不偏向 user 或 host 任意一边
- 它非常适合作为实例对象键

所以推荐结构如下：
```nix
profile.relations."alice@laptop" = {
  user = "alice";
  host = "laptop";
  ...
};
```

---
## 三类模型的边界总结
### User 负责什么
- 长期用户偏好
- 可跨主机复用的个人能力
- 用户抽象层语义

### Host 负责什么
- 主机自身事实
- `backend / platform / hardware / system`
- 主机环境能力

### Relation 负责什么
- 用户与主机的绑定
- 某用户在某主机上的实例身份
- 实例启用能力
- 仅属于组合态的参数

---
## 数据归属矩阵
下面这类归属建议应被视为规范。

### 属于 User
- 默认 shell
- 默认 editor
- 用户首次创建时的初始密码哈希
- 主题语义
- 用户级 packages
- 用户级 programs
- 用户长期开发环境偏好

### 属于 Host
- backend 类型
- platform.system
- 网络
- 引导
- 文件系统
- 硬件
- 系统服务
- 主机级桌面基础设施

### 属于 Relation
- username
- uid
- homeDirectory
- extraGroups
- home.stateVersion
- 该实例是否启用桌面
- 该实例是否作为主用户存在

---
## 派生模型
虽然 `Source Model` 只有三类对象，但系统实现层应生成稳定的派生模型。

推荐至少生成以下两个派生对象。

### 1. `instances`
`instances` 是从 `relations` 派生出的规范化实例集合。它是 `Relation + User + Host` 的合成结果。

推荐形态：
```nix
profile.instances."alice@laptop" = {
  relationId = "alice@laptop";
  userId = "alice";
  hostId = "laptop";

  user = { ...resolved user... };
  host = { ...resolved host... };
  relation = { ...resolved relation... };

  backend = {
    type = "nixos";
  };

  scopes = {
    system.enable = true;
    home.enable = true;
  };

  capabilities = {
    desktop.enable = true;
    development.enable = true;
  };
};
```

这层是后端投影最理想的输入。

### 2. `current`
`current` 是模块在“当前实例上下文”下读取的稳定公共接口。

推荐形态：
```nix
profile.current = {
  relationId = "alice@laptop";
  userId = "alice";
  hostId = "laptop";

  backend.type = "nixos";

  scope = "home"; # or "system"

  capabilities = { ... };
  preferences = { ... };
  theme = { ... };
};
```

它的作用是给模块一个统一读取面，  
避免模块到处手撕 `users / hosts / relations` 三层结构。

---
## 公共接口与私有接口
为了让各软件包或模块能够读取 `config` 并进行适配，  
本项目必须区分：
- 公共接口
- 私有实现

### 公共接口
适合跨模块稳定依赖的字段，例如：
- `profile.current.backend.type`
- `profile.current.scope`
- `profile.current.capabilities`
- `profile.current.theme`
- `profile.current.preferences`
- `profile.instances.<id>.capabilities`

这些字段应尽量保持长期稳定。

### 私有接口
例如：
- `_internal`
- `_normalized`
- `_cache`
- `_projection`

这些字段只允许系统内部使用，不应被普通模块依赖。

---
## Backend 与 Scope 派生规则
`Backend` 与 `Scope` 虽然不直接是 `Source Model` 中的独立对象，但必须能从 Host 派生出稳定结果。

推荐规则如下：

### 当 `backend.type = "home-manager"`
- `home.enable = true`
- `system.enable = false`

### 当 `backend.type = "nix-darwin"`
- 至少存在主机级实现面
- 如引入 Home Manager，可额外派生 `home` scope
- 具体细节由实现层决定，但 `Host` 语义上仍是 darwin 主机

### 当 `backend.type = "nixos"`
- `system.enable = true`
- `home.enable = true`

也就是说，`NixOS` 主机是一种天然双面主机。

---
## 校验规则
规范化阶段至少应执行以下校验：

### 1. 引用校验
每个 relation 的 `user` 和 `host` 必须存在。

### 2. 唯一性校验
同一个 `(user, host)` 对应的 relation 只能有一个。

### 3. 能力收缩校验
`Relation.activation` 不能启用 `User.capabilities` 中不存在的能力。

### 4. Scope 合法性校验
如果某 relation 填写了 system-only 字段，例如 `extraGroups`，  
而目标 host 不具备 `system` scope，则必须报错或拒绝投影。

### 5. 归属校验
实例身份相关字段不能出现在 `User` 中。
主机级硬件字段不能出现在 `User` 中。
用户长期偏好不能出现在 `Host` 中。

---
## 最小示例
下面是一份符合本数据模型的最小示例：
```nix
{
  profile = {
    users = {
      alice = {
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

        programs = {
          git.enable = true;
          zsh.enable = true;
          neovim.enable = true;
        };

        theme = {
          name = "catppuccin";
          accent = "lavender";
          flavor = "mocha";
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

      server-a = {
        backend.type = "nixos";
        platform.system = "x86_64-linux";

        capabilities = {
          system.enable = true;
          home.enable = true;
          desktop.enable = false;
          userManagement.enable = true;
        };

        roles = [ "server" ];
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

      "alice@server-a" = {
        user = "alice";
        host = "server-a";

        identity = {
          name = "alice";
        };

        activation = {
          desktop.enable = false;
          development.enable = true;
          theme.enable = false;
        };

        state = {
          home.stateVersion = "25.05";
        };
      };
    };
  };
}
```

这份例子很好地体现了三层边界：
- `alice` 的长期偏好放在 `users.alice`
- `laptop / server-a` 的主机事实放在 `hosts.*`
- `alice` 在不同主机上的实例差异放在 `relations.*`

---
## 一句话总结
`data-model.md` 规定的是：
- `User` 负责抽象用户语义
- `Host` 负责抽象主机环境
- `Relation` 负责实例化绑定
- `instances` 负责成为实现层输入
- `current` 负责成为模块读取接口

它的核心目标只有一个：
> 让每一项配置都知道自己属于谁、出现在哪一层、最终通过什么实例落地。
