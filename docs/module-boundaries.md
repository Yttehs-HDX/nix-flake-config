# Module Boundaries
## 目标
本文档定义 `nix-flake-config` 中各类模块的职责边界。

前面的文档已经分别回答了这些问题：
- `vision.md`：为什么要这样做
- `architecture.md`：系统有哪些核心对象
- `core-concepts.md`：术语分别是什么意思
- `data-model.md`：数据模型长什么样
- `resolution-flow.md`：数据如何流动并变成结果

而本文档要回答的是最后一个关键问题：
> 这些概念和流程，具体应由哪些模块负责？

也就是说，本文档的职责不是再讲一遍架构，而是把架构压成工程边界，防止后续实现再次退化为：
- imports 到处乱串
- helper 到处生长
- backend 模块直接读原始声明
- 某个阶段偷偷做另一个阶段的事
- 模块之间通过私有字段互相耦合

---
## 为什么必须定义模块边界
如果没有模块边界，哪怕前面的概念设计得再漂亮，实际实现时仍然会很快失控。

最常见的问题有：

### 1. 阶段边界失守
例如：
- normalize 模块偷偷开始做实例生成
- projector 模块偷偷去补默认值
- backend 模块直接决定对象归属

这样一来，`resolution-flow.md` 就会沦为纸面设计。

---
### 2. 数据读取无边界扩散
例如：
- 某个包模块直接去读 `profile.users`
- 某个主题模块直接去读 `profile.relations`
- 某个 backend 模块依赖另一个模块的 `_internal` 字段

最终整个系统会变成一张隐式依赖网。

---
### 3. 公共接口与私有实现混在一起
如果没有边界，系统内部临时计算字段很容易被普通模块当成长期接口使用。  
这会让重构几乎不可能进行。

---
### 4. 目录结构失去语义
没有模块边界时，目录只是文件堆放位置，而不是架构映射。  
这会使“架构设计”和“代码实现”再次脱节。

---
## 核心原则
在进入具体模块之前，先定义几条总原则。

### 1. 模块边界必须服从解析阶段
模块的职责划分，应优先服从 `resolution-flow.md` 中的阶段边界，  
而不是按“方便写”临时拆分。

也就是说，模块不是随便分文件，  
而是要映射到：
- Source
- Normalize
- Instantiate
- Context
- Project
- Realize

这些阶段。

---
### 2. 越靠后的模块，越不应该读原始声明
靠近 backend 的模块，不应直接读取原始 `users / hosts / relations`。  
它们应尽量只消费：
- normalized model
- instance model
- context
- projection input

---
### 3. 模块只应依赖稳定输入，不应依赖上游私有细节
如果一个模块需要跨层读取别人的 `_internal` 字段，  
说明模块边界已经设计失败。

---
### 4. 一个模块只能拥有一类解释权
例如：
- 归一化模块拥有“补默认值和整理结构”的解释权
- 实例模块拥有“生成 instance”的解释权
- 投影模块拥有“语义映射到 backend”的解释权

不应出现两个模块同时解释同一类事情。

---
### 5. 公共接口必须集中暴露，不允许任意横穿
其他模块如果需要消费统一上下文，应从公共入口读取，  
而不是自己穿透整个模型树到处找字段。

---
## 模块分层总览
推荐将整个实现层分为以下几类模块：
1. Source Modules
2. Normalize Modules
3. Index / Validation Modules
4. Instance Modules
5. Context Modules
6. Projection Modules
7. Backend Assembly Modules
8. Shared Schema / Interface Modules
9. Internal Helper Modules

这些模块不是必须严格对应目录名，  
但它们必须对应职责边界。

---
## 1. Source Modules
## 职责
`Source Modules` 负责接住用户手写配置，也就是最前端的声明层。

它们的职责包括：
- 定义 `profile.users`
- 定义 `profile.hosts`
- 定义 `profile.relations`
- 为这些对象提供结构化入口
- 提供最前端的 option schema 映射点

---
## 可以做什么
- 定义顶层入口
- 定义手写字段结构
- 定义声明层字段文档
- 提供最基础的类型约束
- 组织前端配置子模块

---
## 不可以做什么
- 不应生成 instance
- 不应执行 backend 投影
- 不应做复杂派生计算
- 不应读取 backend-specific 输出结构
- 不应承担 normalize 之后的解释职责

---
## 允许读取的内容
- 用户手写输入
- 顶层 `profile.*` 声明
- 少量基础 schema 常量

---
## 禁止依赖的内容
- `instances`
- `current`
- `projectionInputs`
- backend realization
- 其他阶段的 `_internal` 派生结果

---
## 一句话总结
`Source Modules` 负责“定义用户可以写什么”，  
不负责“这些东西最终怎么实现”。

---
## 2. Normalize Modules
## 职责
`Normalize Modules` 负责把松散的手写声明整理成稳定的规范模型。

它们的职责包括：
- 补默认值
- 固定字段形态
- 规范化对象结构
- 生成对象内部显式 ID
- 清理短写法差异

---
## 可以做什么
- 结构整理
- 默认值补全
- 统一字段路径
- 生成 `normalized.users`
- 生成 `normalized.hosts`
- 生成 `normalized.relations`

---
## 不可以做什么
- 不应决定最终 backend 节点
- 不应生成具体 `users.users.<name>` 一类输出
- 不应做实例级能力启用决策
- 不应根据 host 改写 user 本体语义
- 不应承担 projector 职责

---
## 允许读取的内容
- `profile.users`
- `profile.hosts`
- `profile.relations`
- schema 常量
- 默认值规则

---
## 禁止依赖的内容
- backend outputs
- 具体 scope realization
- projector 结果
- 其他模块私有缓存

---
## 一句话总结
`Normalize Modules` 负责“把声明整理干净”，  
不负责“把声明变成实现”。

---
## 3. Index / Validation Modules
## 职责
这一层负责：
- 交叉引用校验
- 唯一性校验
- 基础语义一致性检查
- 生成内部索引结构

例如：
- `relation.user` 是否存在
- `relation.host` 是否存在
- `(user, host)` 是否重复
- 某对象被禁用时是否还被引用

---
## 可以做什么
- 做错误检查
- 建立索引
- 生成错误报告上下文
- 标记不可实例化对象

---
## 不可以做什么
- 不应偷偷修正错误输入
- 不应替用户自动决定语义
- 不应直接开始投影
- 不应发明新的业务字段

---
## 允许读取的内容
- `normalized.users`
- `normalized.hosts`
- `normalized.relations`

---
## 禁止依赖的内容
- backend outputs
- projection results
- 当前 scope realization
- 任何需要实例化之后才存在的数据

---
## 一句话总结
`Index / Validation Modules` 负责“确认对象关系合法”，  
而不是“代替系统自动纠错”。

---
## 4. Instance Modules
## 职责
`Instance Modules` 负责从：
- `Normalized User`
- `Normalized Host`
- `Normalized Relation`

生成真正的 `Instance Model`。
这是从“抽象对象”进入“部署对象”的唯一合法阶段。

---
## 可以做什么
- 组合 user / host / relation
- 生成 `instances.<relationId>`
- 注入 `userId / hostId / relationId`
- 生成实例级视图

---
## 不可以做什么
- 不应在这里写 backend 节点
- 不应在这里做 packages / programs 的具体投影
- 不应在这里决定 theme 落到哪个模块路径
- 不应在这里做最终 merge

---
## 允许读取的内容
- `normalized.*`
- validation 结果
- relation 索引

---
## 禁止依赖的内容
- realization outputs
- backend assembly 结果
- 其他 projector 的私有规则

---
## 一句话总结
`Instance Modules` 负责“生成实例对象”，  
不负责“实现实例对象”。

---
## 5. Context Modules
## 职责
`Context Modules` 负责生成统一的可消费上下文。

这是整个系统中最重要的"公共读取层"之一。

它们的职责包括：
- 从 instance 派生 backend / scope
- 合并 user / host / relation 的公共语义
- 计算 effective capabilities
- 生成 `current` 或其他公共读取接口
- 为 projector 提供统一上下文输入
- **执行语义丰富化和业务逻辑**，包括：
  - 基于 scope/backend/platform 的包过滤（通过 package catalog 查询）
  - 基于能力的主题解析（条件导入、主题资源合并）
  - 能力感知的字段派生

**重要说明**：Context 不仅仅是数据传递层。它可以包含业务逻辑以构建**丰富的、可直接投影的接口**。
这是有意的设计选择——Context 提供的是"投影就绪"的上下文，而非原始数据的简单聚合。

---
## 为什么这一层必须单独存在
因为如果没有统一 context，后续模块会各自去读：
- `instance.user.preferences`
- `instance.host.roles`
- `instance.relation.activation`
- `instance.host.backend.type`

这样会导致：
- 读取路径不统一
- 数据模型一变，模块全碎
- 模块边界被绕开

所以，`Context Modules` 是整个系统里**最关键的稳定接口层**。

---
## 可以做什么
- 派生 backend
- 派生 scope
- 合并公共 capability
- 生成 instance context
- 生成 scoped context
- 暴露 `profile.current` 一类统一读取面

---
## 不可以做什么
- 不应直接输出 backend result
- 不应执行具体 projector 逻辑
- 不应承担最终 merge 职责
- 不应让实现模块反向改写上游声明模型

---
## 允许读取的内容
- `instances`
- 规范化后的 capability / policy / preferences / theme
- 校验结果

---
## 禁止依赖的内容
- 某个 projector 的局部输出
- backend assembly 的最终结果
- realization 后才存在的配置节点

---
## 一句话总结
`Context Modules` 负责“把实例整理成统一上下文接口”，  
它是普通模块最推荐依赖的读取入口。

---
## 6. Projection Modules
## 职责
`Projection Modules` 负责把稳定语义映射到 backend 可接受的配置结构。

这是语义层走向实现层的核心边界。

推荐按语义领域拆分 projector，而不是按大文件单体实现。

例如可以拆成：
- packages projector
- programs projector
- services projector
- theme projector
- identity projector
- membership projector
- desktop projector
- policy projector

---
## 可以做什么
- 读取 `Projection Input`
- 判断当前 `backend.type`
- 判断当前 `scope`
- 把语义字段映射到实现字段
- 产出局部 realization fragment

---
## 不可以做什么
- 不应直接读原始 `profile.users`
- 不应补 Source Model 默认值
- 不应重新生成 instance
- 不应决定 relation 是否存在
- 不应越权发明上游没有的语义

---
## 允许读取的内容
- `projectionInputs`
- `scoped context`
- 明确暴露的公共 schema / interface
- backend capability descriptor

---
## 禁止依赖的内容
- 原始 `profile.*`
- `normalized.*` 私有细节
- 其他 projector 的私有字段
- 最终 merge 之后的 realization

---
## 一句话总结
`Projection Modules` 负责“翻译”，  
不是负责“定义”。

---
## 7. Backend Assembly Modules
## 职责
`Backend Assembly Modules` 负责把多个 projector 的结果合并并接入最终 outputs。

这是整个系统最接近 flake outputs 的一层。

它们的职责包括：
- 收集各 projector 输出
- 按 backend / host / scope 组织结果
- 合并 realization fragments
- 组装成最终 backend 入口

例如：
- `nixosConfigurations.<hostId>`
- `homeConfigurations."<relationId>"`
- `darwinConfigurations.<hostId>`

---
## 可以做什么
- 结果合并
- 输出挂载
- 冲突检测与报告
- backend final wiring

---
## 不可以做什么
- 不应读取原始 source model
- 不应补 normalize 默认值
- 不应重新定义 capability 规则
- 不应直接承担某个语义 projector 的实现职责

---
## 允许读取的内容
- projector 输出
- scoped realization fragments
- backend grouping 信息

---
## 禁止依赖的内容
- 原始 `profile.users`
- 原始 `profile.hosts`
- 原始 `profile.relations`
- 任何只应属于 normalize 阶段的临时规则

---
## 一句话总结
`Backend Assembly Modules` 负责“把已经翻译好的结果接起来”，  
不负责重新解释前面的世界。

---
## 8. Shared Schema / Interface Modules
## 职责
这一层负责定义那些被多个阶段稳定复用的公共结构。

例如：
- field schema
- capability names
- backend type 枚举
- scope 枚举
- context public interface
- projection input schema
- 公共 option shape

这是系统中“共享语义常量”的主要归属层。

---
## 可以做什么
- 定义枚举
- 定义公共字段结构
- 定义 capability 命名规范
- 定义 interface contract
- 定义公共 schema helper

---
## 不可以做什么
- 不应读业务实例数据
- 不应承担 normalize 结果生产
- 不应承担 backend assemble
- 不应把共享层变成万能 helper 垃圾桶

---
## 一句话总结
`Shared Schema / Interface Modules` 负责“定义全系统共用的语义契约”，  
而不是处理具体业务数据。

---
## 9. Internal Helper Modules
## 职责
`Internal Helper Modules` 只负责提供局部实现辅助能力。

例如：
- attrset 操作
- merge helper
- path helper
- option builder helper
- diagnostic formatting helper

---
## 重要边界
这一层最容易失控。  
因为 helper 往往会不断膨胀，最终变成：
- 偷偷依赖业务字段
- 偷偷依赖某个 backend
- 偷偷承担语义判断

这是必须避免的。

---
## Helper 的规则
### 1. helper 应尽量无业务语义
一个真正健康的 helper，应该更像：
- map / fold / merge / transform 工具
- schema 构造器
- 错误格式化器

而不是：
- “判断某用户是否应该属于某 host”
- “自动修正某个 relation 的语义错误”
- “把某个 user 直接投影成 nixos users.users”

这些已经不是 helper，而是业务逻辑。

---
### 2. helper 不应拥有解释权
helper 可以帮忙写代码，  
但不能代替模块本身决定架构含义。

---
## 一句话总结
`Internal Helper Modules` 只负责“辅助实现”，  
绝不能变成隐形架构层。

---
## 推荐的依赖方向
整个系统推荐遵循单向依赖。

从高层到低层大致如下：
- Source Modules
- Normalize Modules
- Validation / Index Modules
- Instance Modules
- Context Modules
- Projection Modules
- Backend Assembly Modules

共享层和 helper 层为横向支撑，但不应反向拥有业务主导权。

可以抽象成：
```
source
  -> normalize
  -> validate/index
  -> instantiate
  -> context
  -> project
  -> assemble
```

---
## 不允许的依赖方向
以下依赖应视为危险信号。

### 1. Projector 直接读取 Source Model
如果 projector 直接去读 `profile.users`，  
说明中间层设计已经失效。

---
### 2. Normalize 依赖 Backend Output
如果 normalize 要看 `nixosConfigurations` 才知道怎么补默认值，  
说明阶段顺序已经倒置。

---
### 3. Source Module 依赖 Instance / Current
前端声明层不应依赖解析后的世界。

---
### 4. Assembly 反向改写上游模型
最终输出层不能反过来决定上游对象该长什么样。

---
### 5. 模块读取其他模块私有 `_internal`
若某个普通模块依赖别人的 `_internal` 字段，  
说明没有走公共接口。

---
## 公共接口暴露规则
为了避免模块随意横穿模型，系统必须明确哪些接口是公共接口。

推荐只暴露以下几类稳定读取面：

### 1. `profile.normalized`
主要给内部中间阶段使用。  
不建议普通 projector 大范围直接依赖其内部全部细节。

---
### 2. `profile.instances`
实例级数据入口。  
适合 context 层与更上游的内部模块读取。

---
### 3. `profile.current`
最推荐普通语义模块读取的公共接口之一。  
它代表当前实例、当前 scope 下的统一上下文。

---
### 4. `profile.projectionInputs`
最推荐 projector 读取的直接输入接口。

---
## 公开程度建议
### 面向普通 projector 的接口
优先：
- `profile.current`
- `profile.projectionInputs`

### 面向解析中间层的接口
优先：
- `profile.normalized`
- `profile.instances`

### 不应公开依赖的接口
- `_internal`
- `_cache`
- `_normalizedRaw`
- `_projectionWork`
- `_temporary`

---
## 各类模块的“谁能读什么”
下面用更直接的方式冻结读取边界。

### Source Modules
可读：
- 原始用户声明
- 顶层 schema

不可读：
- `instances`
- `current`
- projector outputs
- backend outputs

---
### Normalize Modules
可读：
- `profile.users`
- `profile.hosts`
- `profile.relations`

不可读：
- projector outputs
- backend outputs
- realization fragments

---
### Validation / Index Modules
可读：
- `profile.normalized.*`

不可读：
- backend outputs
- realization fragments

---
### Instance Modules
可读：
- `profile.normalized.*`
- validation results

不可读：
- projector outputs
- final outputs

---
### Context Modules
可读：
- `profile.instances`
- normalized public fields
- validation results

不可读：
- raw source
- final assembly outputs

---
### Projection Modules
可读：
- `profile.current`
- `profile.projectionInputs`
- shared schema contracts

不可读：
- raw source
- arbitrary `_internal`
- final backend outputs

---
### Backend Assembly Modules
可读：
- projector fragments
- backend grouping metadata

不可读：
- raw source
- normalize internals
- relation semantics beyond finalized projection input

---
## 对 config 读取的边界约束
前面提过一个关键点：
> 各个软件包之间可以任意读取 config，以此改变自身行为，达到针对性适配效果

这个能力是要保留的，但必须加边界。  
否则系统很快会退化成“任何模块都能看到整个宇宙”。

所以这里明确规定：

### 允许
模块可以读取 `config`，但应优先读取：
- `profile.current`
- `profile.projectionInputs`
- shared public interfaces

这些接口是**专门为了被读而设计的**。

---
### 不鼓励
模块直接读取：
- 其他模块的内部 option 路径
- 某个阶段的私有计算字段
- backend assembly 中间缓存
- 非公共命名空间下的临时结构

---
### 明确禁止
普通业务模块依赖：
- `_internal`
- `_cache`
- `_tmp`
- 其他模块的未公开实现路径

---
## 为什么这样设计
因为“允许模块读取 config”与“允许无边界耦合”不是一回事。

前者是能力，后者是退化。

本项目要的是：
> 模块具备全局感知能力，但这种感知必须通过稳定接口发生。

---
## 模块边界与目录结构的关系
本文档先冻结的是“职责边界”，而不是具体目录树。  
但后续写 `directory-layout.md` 时，目录设计应尽量映射这里的边界。

也就是说，目录不应只是按软件名字分堆，  
而应让人一眼看出：
- 哪一部分属于 source
- 哪一部分属于 normalize
- 哪一部分属于 context
- 哪一部分属于 projection
- 哪一部分属于 assembly

如果目录结构无法映射这些边界，  
那目录设计就还是偏实现堆叠，而不是架构投影。

---
## 推荐的模块责任矩阵
可以把整个系统粗略理解为下面这张矩阵：
| 模块类别 | 输入 | 输出 | 拥有的解释权 |
| --- | --- | --- | --- |
| Source | 手写声明 | 原始 source model | 用户可以写什么 |
| Normalize | source model | normalized model | 结构如何被整理 |
| Validate / Index | normalized model | 校验结果 / 索引 | 对象关系是否合法 |
| Instance | normalized + relation | instances | 对象如何实例化 |
| Context | instances | current / scoped context | 模块应读取什么上下文 |
| Projection | projection input | realization fragments | 语义如何翻译到 backend |
| Assembly | realization fragments | final outputs | 结果如何被挂接与合并 |

---
## 模块边界中的不变量
以下不变量在整个实现过程中都不应被破坏。

### 1. Relation 是唯一实例化入口
不能让 `Host` 或 `User` 绕过 relation 直接生成实例。

---
### 2. Projector 不直接消费原始声明
backend 实现必须依赖稳定中间层，而不是依赖手写源。

---
### 3. Context 是普通模块最主要的读取入口
如果普通模块大量绕过 context 直读底层对象，  
说明公共接口设计失败。

---
### 4. Assembly 不拥有语义解释权
最终组装层不应重新决定上游对象是什么意思。

---
### 5. Helper 不拥有业务决策权
helper 只能辅助，不能替代架构层判断。

---
## 一句话总结
`module-boundaries.md` 规定的是：
- 哪类模块负责哪一阶段
- 每类模块拥有哪些解释权
- 每类模块能读什么、不能读什么
- 公共接口暴露到哪一层
- backend 模块应消费什么，而不应消费什么

它的核心目标只有一个：
> 让 `nix-flake-config` 的实现层真正服从架构层，而不是在代码落地时重新滑回无边界拼装。
