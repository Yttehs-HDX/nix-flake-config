# Docs
本目录用于记录 `nix-flake-config` 的设计文档。  
这些文档不是零散笔记，而是一套逐层收敛的架构规范，用来回答这个项目最核心的问题：
- 为什么要这样设计
- 系统里有哪些对象
- 这些对象分别表达什么
- 数据如何流动
- 模块边界如何划分
- 目录结构如何映射架构
- 声明层 option 应该长什么样

也就是说，这里的文档共同描述的是：
> `nix-flake-config` 如何从“一个 Nix 配置仓库”，演化成“一套面向多用户、多主机、多后端的声明式配置编排系统”。

---
## 文档阅读顺序
推荐按下面的顺序阅读：
1. [`vision.md`](./vision.md)
2. [`architecture.md`](./architecture.md)
3. [`core-concepts.md`](./core-concepts.md)
4. [`data-model.md`](./data-model.md)
5. [`resolution-flow.md`](./resolution-flow.md)
6. [`module-boundaries.md`](./module-boundaries.md)
7. [`directory-layout.md`](./directory-layout.md)
8. [`option-schema.md`](./option-schema.md)

这个顺序对应的是从“为什么”逐步走到“怎么落地”的过程。

---
## 文档说明
### `vision.md`
说明项目动机与整体目标。

它主要回答：
- 为什么这个项目不能只停留在普通的 Nix 配置拼接
- 为什么需要支持多用户与多主机的任意组合
- 为什么要采用“用户声明 -> 后端实现”的自动化方案
- 为什么配置需要精确落地到系统中的任意位置

这是整个文档体系的起点。

---
### `architecture.md`
说明系统的总体架构与对象分工。

它主要回答：
- `User`、`Host`、`Relation` 分别是什么
- 为什么用户配置应独立于主机配置
- 为什么主机不能反向改写用户语义
- 为什么需要关系网而不是让用户或主机单方面决定拓扑
- 为什么 `NixOS` 是一种同时拥有 `system + home` 双实现面的特殊主机

这是系统结构层面的总图。

---
### `core-concepts.md`
定义核心术语。

它主要回答：
- `Declaration`
- `Subject`
- `User`
- `Host`
- `Relation`
- `Instance`
- `Backend`
- `Scope`
- `Projection`
- `Realization`
- `Context`
- `Capability`

这些词各自是什么意思，以及它们之间如何区分。

这份文档的作用，是冻结术语，避免后续讨论中概念漂移。

---
### `data-model.md`
定义数据模型。

它主要回答：
- `profile.users`
- `profile.hosts`
- `profile.relations`

这三类对象在数据层到底长什么样。

同时它还规定了：
- 哪些字段属于 `User`
- 哪些字段属于 `Host`
- 哪些字段必须属于 `Relation`
- 为什么 `instances` 和 `current` 应作为派生模型存在

这份文档是从“概念”走向“结构”的关键一层。

---
### `resolution-flow.md`
定义配置从声明到实现的解析流程。

它主要回答：
- source model 如何进入系统
- normalize 如何整理结构
- validate 如何进行引用与合法性校验
- instantiate 如何生成实例
- context 如何形成统一读取接口
- projection 如何把语义映射到 backend
- assembly 如何合并结果并接入最终 outputs

这份文档本质上是项目的“解析流水线规范”。

---
### `module-boundaries.md`
定义模块职责边界。

它主要回答：
- 哪类模块负责 source
- 哪类模块负责 normalize
- 哪类模块负责 validate
- 哪类模块负责 instantiate
- 哪类模块负责 context
- 哪类模块负责 projection
- 哪类模块负责 assembly
- 各类模块可以读取什么，不可以读取什么

这份文档的作用，是防止代码实现重新退回无边界拼装。

---
### `directory-layout.md`
定义推荐目录结构。

它主要回答：
- 目录结构如何映射前面的架构阶段
- 为什么 `users / hosts / relations` 应作为独立声明入口存在
- 为什么 `modules/` 应按阶段组织，而不是按软件名平铺
- 为什么 `projection` 与 `assembly` 应拆开
- 为什么 `schema`、`interfaces`、`internal` 需要分层

这份文档把抽象边界进一步压成了仓库骨架。

---
### `option-schema.md`
定义声明层 option 规范。

它主要回答：
- `profile.users.*` 可以写哪些字段
- `profile.hosts.*` 可以写哪些字段
- `profile.relations.*` 可以写哪些字段
- 每个字段的类型、默认值、必填性是什么
- 哪些字段允许 `null`
- 哪些字段不应该跨对象乱放

这份文档已经非常接近实际 Nix `mkOption` / `submodule` 的实现形状。

---
## 文档之间的关系
可以把这些文档理解为一条逐步收敛的链：
- `vision.md`：为什么做
- `architecture.md`：系统怎么分工
- `core-concepts.md`：术语是什么
- `data-model.md`：数据长什么样
- `resolution-flow.md`：数据怎么流动
- `module-boundaries.md`：模块怎么分责
- `directory-layout.md`：仓库怎么组织
- `option-schema.md`：声明层怎么落成 options

也可以简单理解为：
> 从理念，走到结构；  
> 从结构，走到数据；  
> 从数据，走到流程；  
> 从流程，走到代码骨架；  
> 从骨架，走到可实现的 option 规范。

---
## 当前文档体系覆盖了什么
当前这套文档已经覆盖了项目最关键的设计层内容：
- 项目动机
- 核心对象
- 核心术语
- 数据模型
- 解析流程
- 模块边界
- 目录结构
- 声明层 schema

也就是说，项目的“设计骨架”已经基本成型。

---
## 当前文档体系还没有覆盖什么
虽然设计层已经比较完整，但目前还没有专门展开以下内容：
- 最小实现闭环的代码设计
- 各阶段模块的实际 Nix 实现方式
- flake outputs 的接线策略
- 测试策略与测试样例
- projector 的具体拆分方式
- backend adapter 的实现细节
- `current` / `projectionInputs` 的最终公共接口形状

这些内容更适合在代码开始落地后，再继续补充新的文档。

---
## 当前代码已实现的最小支持面
截至当前仓库实现，代码层已经具备一条可验证的最小闭环，但支持面仍然刻意保持收敛。

当前已落地并被测试覆盖的内容主要包括：
- `profile.users / hosts / relations` 的 source schema 与最小 normalize / validate / instantiate / context 流水线
- `Relation` 作为唯一实例化入口
- `current` 与 `projectionInputs` 两个中间接口
- `nixos`、`home-manager`、`nix-darwin` 三类 backend 的最小组装闭环
- 用户身份、home 路径、home state version、统一 `packages` 抽象与主题资源解析这几类最小投影能力

当前尚未作为稳定实现面的字段包括但不限于：
- `theme`
- `networking`
- `security`
- `desktop`
- 各类 `policy` / `overrides`

其中：
- `packages` 已作为稳定 source/context/projection 接口进入实现，用于统一表达 package / program / service 类软件意图。
- `programs` / `services` 仍保留在 schema 中作为兼容入口，但会在 normalize 阶段被收束进 `packages`，不再作为 projector 的主消费接口。
- `theme` 当前只实现了最小资源解析闭环，不应被视为已经覆盖所有桌面与 toolkit 投影。

---
## 一句话总结
`docs/` 目录记录的不是一些分散的说明文件，  
而是 `nix-flake-config` 的完整设计骨架。

它试图确保这个项目从一开始就不是靠模块堆叠和临时补丁生长，  
而是沿着一条清晰的路径演化：

> 从多用户、多主机、多后端的配置问题出发，  
> 建立一套声明式、可解析、可投影、可精确落地的配置系统。
