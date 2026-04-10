# Resolution Flow
## 目标
本文档定义 `nix-flake-config` 中配置从声明到实现的完整解析流程。

它回答的问题是：
- `users`、`hosts`、`relations` 如何被系统读取
- 系统如何把原始声明整理成稳定结构
- 系统如何生成实例
- 系统如何决定 backend 与 scope
- 系统如何把实例投影为最终配置输出
- 各阶段分别允许做什么，不允许做什么

这份文档的意义，是冻结“配置如何流动”的过程。  
`data-model.md` 解决的是“数据长什么样”，而 `resolution-flow.md` 解决的是“数据如何变成结果”。

---
## 为什么必须定义 Resolution Flow
如果没有明确的解析流程，系统很快就会退化为以下状态：
- 某些模块直接读取原始 `users`
- 某些模块直接拼接 `hosts`
- 某些逻辑偷偷在 `relations` 中做半投影
- 某些 backend 自己做一套私有归一化
- 不同模块对同一个字段的默认值理解不一致
- 错误发生时，无法判断是声明层错误、关系层错误，还是投影层错误

这会导致整个项目从“声明式配置架构”退回“多处隐式拼装”。

因此，本项目要求配置必须经过一条明确、可解释、可分阶段校验的解析流水线。

---
## 总体流程
整个系统的推荐解析流如下：
1. 读取 Source Model
2. 执行结构校验
3. 执行归一化（Normalize）
4. 建立关系索引
5. 生成实例（Instantiate）
6. 派生 backend 与 scope
7. 合并上下文（Resolve Context）
8. 执行能力裁剪与合法性校验
9. 生成投影输入（Projection Input）
10. 投影到各 backend / scope
11. 合并输出结果
12. 生成最终 realized outputs

可以简写为：
```
source
-> validate
-> normalize
-> index
-> instantiate
-> derive backend/scope
-> resolve context
-> validate capabilities
-> project
-> realize
```

---
## 核心原则
在定义各阶段之前，先定义几条不可破坏的总原则。

### 1. 每一阶段只做一类事情
例如：
- 校验阶段只负责发现错误
- 归一化阶段只负责整理结构和补默认值
- 实例阶段只负责生成实例对象
- 投影阶段只负责把实例映射到 backend 输出

不允许某一阶段偷偷承担另一阶段的职责。

---
### 2. 越靠前的阶段，越接近“语义输入”
越靠后的阶段，越接近“实现输出”。

也就是说：
- 前半段应尽量保持声明语义
- 后半段才逐渐靠近 backend 细节

---
### 3. 早发现错误，晚做实现
如果某项错误能够在前面阶段被发现，就不应拖到 backend 投影时才报错。

例如：
- `relation.user` 不存在，应在引用校验阶段报错
- 用户能力未声明却在实例中启用，应在实例合法性阶段报错
- 目标 host 没有 `system` scope 却试图写入 `extraGroups`，应在投影前报错

---
### 4. 原始声明不应被 backend 直接消费
backend 不应直接读取松散的 `users / hosts / relations` 原始结构，  
而应尽量只读取已经规范化、实例化后的稳定输入。

---
### 5. 投影只能依赖稳定上下文接口
投影逻辑应依赖统一的上下文对象，而不是在不同模块中手工横跨多个层级去读取原始字段。

---
## 阶段一：读取 Source Model
## 目标
读取用户手写的原始声明。

输入应来自：
- `profile.users`
- `profile.hosts`
- `profile.relations`

这三类对象共同构成系统的 `Source Model`。

---
## 输入
推荐输入形态：
```nix
profile = {
  users = { ... };
  hosts = { ... };
  relations = { ... };
};
```

---
## 输出
这一阶段的输出仍然是原始结构，只是被系统读入内存或模块上下文中。  
此时不应对语义做重写，只允许做最基础的存在性读取。

---
## 这一阶段允许做什么
- 读取 attrset
- 判断顶层字段是否存在
- 补最外层空集合默认值，例如缺省时视为 `{ }`

---
## 这一阶段不允许做什么
- 不允许生成实例
- 不允许执行 backend 投影
- 不允许做字段语义重写
- 不允许偷偷注入某些与 backend 强耦合的结果

---
## 阶段二：结构校验
## 目标
确认 `Source Model` 至少满足基本结构约束。

这一步只解决“结构是否合法”，不解决“语义是否合理”。

---
## 需要校验的内容
### 1. 顶层对象存在性
应确认：
- `users` 是 attrset
- `hosts` 是 attrset
- `relations` 是 attrset

---
### 2. 对象类型合法性
例如：
- 每个 `users.<id>` 必须是 attrset
- 每个 `hosts.<id>` 必须是 attrset
- 每个 `relations.<id>` 必须是 attrset

---
### 3. 明显缺失字段
例如 `Relation` 至少应显式包含：
- `user`
- `host`

若缺失，应在此阶段报错。

---
## 输出
这一阶段输出的仍然是 `Source Model`，  
但它已经通过最基本的结构检查，可以进入归一化阶段。

---
## 阶段三：归一化（Normalize）
## 目标
将原始声明转换为结构一致、默认值明确、字段命名稳定的 `Normalized Model`。

这是整个解析流中非常重要的一步。

---
## 为什么需要 Normalize
因为用户手写的声明通常具有这些特点：
- 某些字段省略
- 某些字段只有部分填写
- 某些对象启用了短写法
- 不同对象的默认值并不完整
- 某些字段存在语义别名或历史写法

如果不先归一化，后续阶段会被迫反复处理这些松散情况。

---
## Normalize 应做的事
### 1. 补默认值
例如：
- `enable` 缺省时补成 `true`
- `meta.tags` 缺省时补成空列表
- `packages.<name>.enable` 缺省时补成 `true`
- `activation.*` 缺省时补成 `null` 或继承待决状态

---
### 2. 固定字段形态
例如：
- 把单值写法整理成统一 attrset 写法
- 把可选字段补成完整结构
- 保证每个对象都具备稳定路径

---
### 3. 生成规范化 ID 记录
虽然对象本身已经通过 attr key 拥有 ID，  
但规范化后仍建议在对象内部显式持有：
- `userId`
- `hostId`
- `relationId`

这样后续阶段处理会更稳定。

---
### 4. 保持语义不变
归一化只能整理结构，不能改写对象归属。  
例如：
- 不能把 `Relation.identity.name` 自动提升成 `User`
- 不能把 `Host.roles` 改写成 `User.capabilities`
- 不能让 backend 推导结果反向写回用户语义

---
## Normalize 输出
推荐输出形态：
```nix
normalized = {
  users = AttrSet NormalizedUser;
  hosts = AttrSet NormalizedHost;
  relations = AttrSet NormalizedRelation;
};
```

---
## 阶段四：引用校验与关系索引
## 目标
确认对象之间的引用完整、唯一、可追踪，  
并生成供后续实例化使用的索引结构。

---
## 需要校验的内容
### 1. Relation 引用有效性
每个 `relation` 的：
- `user`
- `host`

都必须指向真实存在的 `users.<id>` 和 `hosts.<id>`。

---
### 2. Relation 唯一性
同一个 `(userId, hostId)` 只能对应一个 relation。

也就是说：
- `alice@laptop`
- `alice-on-laptop`

如果都指向同一组 `(alice, laptop)`，则应视为重复关系并报错。

---
### 3. 交叉启用合法性
例如：
- `User.enable = false`，但 relation 仍然启用
- `Host.enable = false`，但 relation 仍然启用

这种情况必须在这里或下一阶段被标记为不可实例化。

推荐做法：
- 记录错误并阻止该 relation 实例化
- 或将其标记为 disabled instance，但不应悄悄忽略

---
## 可生成的索引

例如：
```nix
indexes = {
  userToRelations = { ... };
  hostToRelations = { ... };
  relationByPair = { "${userId}@${hostId}" = relationId; };
};
```

这些索引不是公共接口，主要用于系统内部解析提速与一致性保证。

---
## 阶段五：实例生成（Instantiate）
## 目标
从 `Normalized User + Normalized Host + Normalized Relation` 生成实例对象。

这一步会把抽象对象组合成真正可投影的单位。

---
## 为什么 Instance 是必要层
因为后续 backend 并不关心抽象上的“用户”或“主机”本身，  
它真正需要的是：
- 某个用户
- 在某台主机上
- 通过某个 relation
- 当前可用哪些能力
- 应投影到哪些 scope

这就是 `Instance`。

---
## 实例生成逻辑
对每个合法 relation：
1. 取出其引用的 `user`
2. 取出其引用的 `host`
3. 复制 relation 本身
4. 合成为一个实例对象

---

## 推荐输出形态
```nix
instances."<relationId>" = {
  relationId = "...";
  userId = "...";
  hostId = "...";

  user = { ...normalized user... };
  host = { ...normalized host... };
  relation = { ...normalized relation... };
};
```

---
## 这一阶段只做组合，不做投影
这一点非常重要。

实例阶段的任务只是：
- 组合对象
- 建立稳定实例视图

而不是：
- 决定某字段写进 `users.users`
- 决定某字段写进 `home.packages`
- 生成具体 backend 代码片段

这些都属于后面的投影阶段。

---
## 阶段六：派生 Backend 与 Scope
## 目标
从实例中的 host 信息派生出：
- backend 类型
- 可用 scope 集合

---
## 为什么这一阶段独立存在
因为 backend 和 scope 虽然主要来自 host，  
但它们是整个投影层最重要的上下文，必须被显式派生并冻结。

不应让各模块自己重复推导。

---
## 推荐派生规则
### 当 `host.backend.type = "home-manager"`
派生：
```nix
backend.type = "home-manager"
scopes.system.enable = false
scopes.home.enable = true
```

---
### 当 `host.backend.type = "nixos"`
派生：
```nix
backend.type = "nixos"
scopes.system.enable = true
scopes.home.enable = true
```

---
### 当 `host.backend.type = "nix-darwin"`
推荐至少派生：
```nix
backend.type = "nix-darwin"
```

至于是否具备 `home` scope，可以根据未来实现策略确定。  
但无论如何，这一步都应产出明确结论，而不是让投影模块自行猜测。

---
## 输出
实例对象此时可扩展为：
```nix
instances."<relationId>" = {
  ...
  backend = {
    type = "...";
  };

  scopes = {
    system.enable = ...;
    home.enable = ...;
  };
};
```

---
## 阶段七：上下文合并（Resolve Context）
## 目标
把投影所需的上下文信息整理成一份统一、稳定、可被模块消费的 `Context`。

---
## 为什么必须有 Context
如果没有统一 Context，模块会被迫自己去读：
- `instance.user.preferences`
- `instance.host.capabilities`
- `instance.relation.activation`
- `instance.backend.type`
- `instance.scopes.*`

这样做虽然技术上可行，但会造成：
- 模块接口松散
- 不同模块读取路径不一致
- 未来数据模型调整时大面积破坏兼容性

所以推荐在这里生成一层稳定上下文。

---
## Context 至少应包含
- `relationId`
- `userId`
- `hostId`
- `backend.type`
- `scope`
- `capabilities`
- `preferences`
- `theme`
- `identity`
- `membership`
- `roles`
- `platform`

---
## Context 的两种形态
推荐区分两类上下文：

### 1. Instance Context
不区分 scope 的实例上下文。  
适合前置校验和能力合并。

### 2. Scoped Context
已经固定到某个具体 scope 的上下文。  
例如：

- `alice@laptop` 的 `home` 上下文
- `alice@laptop` 的 `system` 上下文

后续投影模块更适合读取 `Scoped Context`。

---
## 推荐输出形态
```nix
contexts."<relationId>" = {
  instance = { ... };
  scopes = {
    home = { ...scoped context... };
    system = { ...scoped context... };
  };
};
```

若某 scope 不存在，则不生成该子项。

---
## 阶段八：能力解析与合法性校验
## 目标
在真正投影前，确认“用户声明的能力”和“关系实例启用的能力”以及“主机承载能力”三者能够合法组合。

这是从语义层走向实现层前的最后一道关键检查。

---
## 三种能力来源
### 1. User Capability
用户声明“我具备或允许哪些能力”。

例如：
- `desktop.enable = true`
- `development.enable = true`

---
### 2. Relation Activation
实例声明“我在这个主机上启用哪些能力”。

例如：
- 在 `laptop` 启用桌面
- 在 `server-a` 关闭桌面

---
### 3. Host Capability
主机声明“我能承载哪些能力”。

例如：
- 支持图形桌面
- 具备用户管理能力
- 具备 system scope

---
## 解析规则
推荐采用“交集式启用”原则：
```text
effective capability
= user allows
AND relation activates
AND host supports
```

也就是说，最终能力必须同时满足三方条件。

---
## 典型错误
### 1. Relation 越权启用
用户未声明桌面能力，  
relation 却试图启用桌面。

应报错。

---

### 2. Host 无法承载
relation 启用了桌面，用户也支持桌面，  
但 host 没有 `desktop` capability。

应报错，或至少禁止生成该能力的投影结果。

---
### 3. Scope 不支持目标字段
例如实例配置了：
- `membership.extraGroups`

但 host 没有 `system` scope。

应报错，而不是静默忽略。

---
## 输出
经过这一阶段后，实例应拥有一组已经解析完成的有效能力：
```nix
effective = {
  capabilities = {
    desktop.enable = true;
    development.enable = true;
    theme.enable = false;
  };
};
```

这个结果是后续投影的直接依据之一。

---
## 阶段九：生成 Projection Input
## 目标
将实例、上下文、有效能力等信息，整理成真正供后端投影模块消费的输入对象。

可以理解为：
> 从“可解析实例”转换为“可投影实例”

---
## 为什么需要这一步
因为即使已经有 `Instance` 和 `Context`，  
后端投影模块仍不应该自己做太多前置整理。

投影模块最理想的输入应该已经明确回答：
- 当前是谁
- 当前在哪台主机
- 当前 scope 是什么
- 当前哪些能力已生效
- 当前允许写入哪些目标

---
## 推荐输出
为每个实例、每个可用 scope 生成一个 projection input。

例如：
```nix
projectionInputs."<relationId>".home = { ... };
projectionInputs."<relationId>".system = { ... };
```

---
## Projection Input 至少应包含
- `identity`
- `account`
- `preferences`
- `theme`
- `packages`
- `programs`
- `services`
- `effective capabilities`
- `backend.type`
- `scope`
- `host.platform`
- `host.roles`
- `membership`（若 scope 合法）
- 其他公共接口字段

共享用户初始密码哈希若存在，应在这一步以稳定接口形态进入投影输入，  
例如 `account.initialHashedPassword`。  
这样 backend projector 只需要消费统一的 `projectionInputs`，而不需要回头读取原始 `users`。

---
## 阶段十：投影（Project）
## 目标
将 `Projection Input` 映射为 backend 可接受的具体配置结果。
这是从抽象模型进入具体实现的关键阶段。

---
## 投影的本质
投影不是“执行声明”，而是：
> 根据上下文，把语义稳定的声明翻译为 backend 对应的配置结构。

例如：
- `programs.git.enable = true`
  可以投影为某 backend 的 `programs.git.enable`
- `packages.ripgrep = { }`
  可以投影为 `programs.ripgrep.enable = true`
- `packages.fastfetch = { }`
  可以投影为 `home.packages`
- `membership.extraGroups = [ "wheel" ]`
  可以投影为 `users.users.<name>.extraGroups`

---
## 投影必须遵循的规则
### 1. 投影不改写上游语义
投影只能翻译，不应重新定义对象归属。

---
### 2. 投影必须 scope-aware
同一个功能在不同 scope 下投影路径可能不同，  
模块不能忽略当前 scope。

---
### 3. 投影必须 backend-aware
不同 backend 的实现方式不同，  
投影模块必须显式区分，而不是假设所有 backend 等价。

---
### 4. 投影应尽量模块化
推荐按语义模块投影，例如：
- packages projector
- programs projector
- theme projector
- membership projector
- desktop projector

而不是做一个巨大的单体 projector。

---
## 投影模块的输入输出
### 输入
- 一个 `Projection Input`
- 一个固定的 `backend.type`
- 一个固定的 `scope`

### 输出
- 一段 backend 配置片段
- 或一个语义子结果集，等待后续合并

---
## 示例性的投影结果
对于 `alice@laptop.home`：
- 用户软件包进入 `home.packages`
- 用户 shell 进入用户级 shell 配置
- 用户主题进入相关 home 层模块

对于 `alice@laptop.system`：
- 用户 identity 进入 `users.users.<name>`
- `account.initialHashedPassword` 进入 `users.users.<name>.initialHashedPassword`
- `extraGroups` 进入用户组配置
- 可能需要的系统级桌面支持进入主机 system 配置

如果某项共享用户初始化语义只在系统用户创建时生效，  
那么 system projector 还应在合适层显式设置与之匹配的 backend 约束。  
例如 NixOS 中的初始密码哈希应与 `users.mutableUsers = true` 配合，  
以保证它只在用户首次创建时参与初始化，而不是被实现成持续覆盖密码的声明式机制。  
当前实现会在需要时为该选项提供 `mkDefault true`，并在外部显式设为 `false` 时直接报错。

这类逻辑仍然属于 system / backend 投影，  
不应被塞进 host 声明，也不应由 home-manager 模块承担。

---
## 阶段十一：结果合并（Merge）
## 目标
把多个投影模块的输出合并为每个 backend / 每个目标实例的完整结果。

---
## 为什么需要合并阶段
因为投影通常是分模块完成的，例如：
- packages 模块产出一段结果
- theme 模块产出一段结果
- membership 模块产出一段结果
- desktop 模块产出一段结果

这些结果必须以稳定规则被合并，  
否则整个系统会退化为“最后 import 谁谁赢”。

---
## 合并原则
### 1. 同层合并，跨层隔离
例如：
- `home` scope 内部结果彼此合并
- `system` scope 内部结果彼此合并
- 不应把 `home` 结果误并到 `system`

---
### 2. 结构化合并优于文本拼接
应尽量合并 attrset 结构，而不是在更晚阶段做字符串或片段拼接。

---
### 3. 冲突必须可解释
如果两个投影模块输出冲突结果，  
系统应尽量能报告冲突来源，而不是静默覆盖。

---
## 合并输出
推荐至少得到：
```nix
realizedByInstance."<relationId>" = {
  home = { ...merged result... };
  system = { ...merged result... };
};
```

若某 scope 不存在，则不生成对应结果。

---
## 阶段十二：生成最终 Realized Outputs
## 目标
把按实例、按 scope 合并后的结果，接入最终 flake outputs 或 backend outputs。

这是整个解析流的终点。

---
## 可能的输出目标
例如：

- `nixosConfigurations.<hostId>`
- `homeConfigurations."<user@host>"`
- `darwinConfigurations.<hostId>`

---
## 一个关键事实
最终输出的组织形式可以随着项目演化调整，  
但它不应反向破坏前面的模型层与解析层。

也就是说：
- outputs 结构可以变
- realization 的挂载路径可以变
- 但 `source -> normalized -> instance -> projection -> realized` 这条主线不应轻易改变

---
## 全流程中的不变量
以下不变量贯穿整个 Resolution Flow。

### 1. User 不直接绑定 Host
用户声明不能偷偷在前面阶段被改写成“用户内置主机列表”。

---
### 2. Host 不直接重写 User 语义
主机可以影响实现条件，但不能反向篡改用户本体意图。

---
### 3. Relation 是唯一实例化入口
从抽象对象走向部署实例，必须经过 relation。

---
### 4. 投影只消费实例上下文，不直接消费原始松散声明
backend 不应直接读原始 `users / hosts / relations`。

---
### 5. Scope 与 Backend 必须在投影前被明确派生
不允许投影模块自行猜测。

---
### 6. 能力启用必须满足三方约束
必须同时满足：
- 用户声明允许
- relation 显式启用
- host 具备承载能力

---
## 推荐的内部数据演化图
可以把整个解析流理解为下面这张图：
```text
Source Model
  -> Structure Validation
  -> Normalized Model
  -> Reference Validation + Indexes
  -> Instances
  -> Backend/Scope Derivation
  -> Context Resolution
  -> Capability Validation
  -> Projection Inputs
  -> Projectors
  -> Merged Realizations
  -> Final Outputs
```

---
## 错误分层
为了让系统在出错时更可维护，推荐把错误按阶段分类。

### 1. Source Errors
原始声明结构错误，例如：
- 顶层字段类型错误
- relation 缺少 `user`
- 非法字段类型

---
### 2. Reference Errors
引用关系错误，例如：
- relation 指向不存在的 user
- relation 指向不存在的 host
- `(user, host)` 重复 relation

---
### 3. Semantic Errors
语义错误，例如：
- relation 越权启用用户未声明能力
- host 无法承载实例启用能力
- User / Host / Relation 字段归属混乱

---
### 4. Projection Errors
投影错误，例如：
- system-only 配置被投影到无 system scope 的 host
- backend 不支持某项实现
- 某 projector 收到不完整 projection input

---
## 最小示例：从声明到实例
假设存在：
- `users.alice`
- `hosts.laptop`
- `relations."alice@laptop"`

那么解析流可以理解为：

### 1. Source
读取三类原始对象。

### 2. Normalize
补齐：
- `enable = true`
- `meta.tags = [ ]`
- 缺省 capability 字段
- 缺省 policy 字段

### 3. Validate References
确认：
- `alice` 存在
- `laptop` 存在

### 4. Instantiate
生成：
```nix
instance."alice@laptop" = {
  user = normalized.users.alice;
  host = normalized.hosts.laptop;
  relation = normalized.relations."alice@laptop";
};
```

### 5. Derive Backend/Scope
若 `laptop.backend.type = "nixos"`，则派生：
```nix
backend.type = "nixos"
scopes.system.enable = true
scopes.home.enable = true
```

### 6. Resolve Context
整理：
- user preferences
- user theme
- host roles
- identity
- membership
- effective capabilities

### 7. Project
对 `home` 和 `system` 分别进行投影。

### 8. Realize
合并结果并接入最终 outputs。

---
## 对后续实现的指导意义
这份文档写完以后，后续模块设计就应遵循下面这套节奏：
- option 设计优先服务于 `Source Model`
- 内部 helper 优先服务于 `Normalized Model`
- backend 模块优先消费 `Projection Input`
- 公共读取接口优先暴露 `Context` / `Current`
- 不要让实现层反向污染前端声明层

也就是说，后续真正写 Nix 代码时，不是“想到哪拼到哪”，而是：
> 每一段实现代码都能明确说出自己属于哪一个阶段。

---
## 一句话总结
`resolution-flow.md` 规定的是：
- 原始声明如何被读取
- 结构如何被整理
- 关系如何生成实例
- backend 与 scope 如何被派生
- 上下文如何被统一
- 能力如何被校验
- 实例如何被投影
- 投影结果如何被合并并接入最终输出

它的核心目标只有一个：
> 让 `users + hosts + relations` 经过一条稳定、可解释、可校验的流水线，最终变成准确且可追踪的配置结果。
