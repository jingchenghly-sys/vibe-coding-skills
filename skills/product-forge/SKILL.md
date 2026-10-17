---
name: product-forge
description: >-
  Turn a product idea into project notes, per-module 结构草稿.json and PRD.md;
  add HTML prototype only when there is no runnable code yet; when web/server
  (or equivalent) already exists, update draft + PRD + the real project in sync.
  Structure draft is the negotiation surface. Use for product-forge, 结构草稿,
  PRD, HTML 原型, 产品方案, 页面原型, or turning an idea into syncable PRD and
  implementation. Works alone or alongside the vibe-coding skill.
---

# 结构草稿 → 操作说明 + 实现（或 HTML 原型）

把已决定要做的一页，收成可改的结构，再编译成下游。C 端、H5、工作台、配置页、列表页都按此产出。

**结构草稿是唯一协商面。** 对话不当需求文档。名称、顺序、枚举、操作同构；冲突时改上游。

权威顺序：项目说明 > 本模块结构草稿 > `PRD.md`（本页操作说明，不是立项）> 实现（有代码项目）或 `原型.html`（尚无代码）。新建项目先有项目根和项目说明；已在项目内则对齐已有说明。

与同仓 `vibe-coding` 配合时：工程骨架由 vibe-coding 生成；本 skill 的产品工件默认落在业务项目的 `product/` 下。本 skill **可单独安装使用**（拷贝整个 `skills/product-forge/`，含 `references/`）。

## 有代码时走实现；无代码时出 HTML 原型

仓库里已经有可运行实现（如 `web/`、`server/`、对应页面）时：

- 下游是 **结构草稿 + PRD + 项目代码**，三者同构。
- 已有的 `原型.html` 视为过期，后续改需求改草稿与 PRD，再直接改项目。
- 口述补需求：先改草稿与 PRD，再改项目。

尚无代码、只有产品文档（如仅有 `product/` 或独立产品目录）时：写出 HTML 原型。一旦项目落地，改需求走「有代码」路径。

## 工件

| 工件 | 文件 | 只回答 | 不回答 |
|---|---|---|---|
| 结构草稿 | `结构草稿.json` | 四问；有什么（模块、字段、选项、操作、端、入口）；字段级约束 | 文案展开、视觉、实现细节 |
| 操作说明 | `PRD.md` | 怎么表现：规则、空态、副作用 | 接口、库表、技术选型、用户故事、指标、里程碑 |
| 实现 | 仓库内对应页面 / 接口 | 怎么点、怎么存：与草稿同名同序 | 草稿没有的字段、按钮、步骤 |
| 原型 | `原型.html` | 仅无代码项目：怎么点；布局、交互、假数据 | 新字段、新规则、新术语 |

一个项目可以有多个功能/页面，每个占一个模块目录。结构草稿与 PRD 只放在模块里。项目名是产品，模块名是其中一页；第一页用页面/功能名作模块目录。

### 目录布局

**独立产品探索**（尚无 vibe-coding 工程，或用户指定路径）：

```
{项目}/
  概述.md
  {模块}/
    结构草稿.json
    PRD.md
    原型.html              ← 仅尚无代码时写
  {另一模块}/
    …
```

**与 vibe-coding 业务项目同仓时**（已有 `server/` / `web/` 等）：

```
~/workspace/projects/<project-name>/
  product/
    概述.md
    {模块}/
      结构草稿.json
      PRD.md
  server/  web/  admin/  deploy/  …
```

有代码时模块目录内只维护草稿与 PRD；页面改动落在 `web/` / `admin/` / `server/`。

- 用户指定路径则用指定路径。
- 已在某项目内 → 在该项目下新建 `{模块}/`。
- 不在任何项目内 → 先建 `{项目}/` 与 `概述.md`，再建 `{模块}/`。
- 已有模块目录就写入；旧布局（草稿直接铺在某目录）把该目录当模块，新功能建兄弟目录。
- 项目说明新建默认 `概述.md`；已有 `背景.md` 等则用已有。

## 工作流

**新建**

1. 定项目与模块。无项目根则先建 `{项目}/`（或 vibe-coding 下的 `product/`）并写 `概述.md`，再建 `{模块}/`。
2. 对齐同项目已有说明 / PRD / 页面的术语与视觉。
3. 先写四问（过及格线），再铺本页结构 → 详见 [`references/structure-draft.md`](references/structure-draft.md)。
4. **无代码**：写原型前做调研 → [`references/mechanical-mapping.md`](references/mechanical-mapping.md)。**有代码**：对齐已有页面壳与交互。
5. 按机械映射写 PRD 并落地到原型或项目 → 同上。
6. 用完成回覆 → [`references/sync-and-reply.md`](references/sync-and-reply.md)。

**同步**：重读 `结构草稿.json` → 同步 PRD 与实现（或原型）→ 回覆三行（改了什么、落在哪一层、另外两件如何跟上）。推断/冻结规则与改动表见 [`references/sync-and-reply.md`](references/sync-and-reply.md)。

## Deep Dive

- [`references/structure-draft.md`](references/structure-draft.md) — 四问、字段约束、三类 JSON 示例
- [`references/mechanical-mapping.md`](references/mechanical-mapping.md) — 映射表、默填、原型调研、PRD/HTML 约定
- [`references/sync-and-reply.md`](references/sync-and-reply.md) — 推断/冻结、改动同步、完成回覆、自检
