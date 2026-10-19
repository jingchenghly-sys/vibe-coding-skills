---
name: vibe-coding
description: >-
  Help users scaffold projects under ~/workspace/projects. Create only the ends the
  project needs now (server, web, admin, deploy); defaults are Vue3+Ant Design Vue,
  Go Gin+GORM+MySQL, and Docker Compose. Always collect product-level material into
  product/. When asked to install/update: upsert the skill, then ask whether to create
  a project now; run env setup and scaffolding only after the user explicitly agrees.
  Use when starting a vibe-coding project, generating a project skeleton, or aligning
  repo structure — not merely because the skill was installed or updated.
---

# Vibe Coding

用本 skill **生成并推进**统一项目骨架（不是改 skill 仓库本身）。

## 何时开工（先读）

**安装或更新（upsert）本 skill ≠ 创建项目，也 ≠ 初始化运行环境。**

标准流程：

1. **Upsert** — 目标 skills 目录中不存在则拷贝安装，已存在则用仓库当前版本覆盖。
2. **询问** — upsert 完成后问用户：是否现在按本 skill 新建项目（环境检测 + 骨架）。
3. **确认后开工** — 用户明确同意后再做环境与脚手架；用户说先不、或未明确同意 → 停住。

日常会话里用户主动说「开新项目 / 生成骨架 / 初始化环境」也视为已确认，可直接进入下方 B。只是问约定或闲聊时：说明能力即可。

## 生成项目默认约定

- **根路径**：`~/workspace/projects/<project-name>/`（英文名）
- **目录**：始终有 `product/` 与根 README。`server/` · `web/` · `admin/` · `deploy/` 只在本期需要时创建
- **产品信息**：`product/README.md` 记录用户、目标、场景、范围、主路径、本期要哪些端。缺口一次给出 2～3 个方案并标明建议项；选定或按建议采用后写入，然后继续
- **栈**（建到该端才用）：前端 Vue3 + Ant Design Vue；后端 Go + Gin + GORM + **MySQL**；部署 Docker + Docker Compose（含 MySQL 服务）
- **本机工具**：只检测本期要建的端所需工具；已有可用则保持现状，缺失则装较新稳定版（见 `references/environment-setup.md`）——**仅在用户确认建项目/初始化环境后执行**

详情见 `references/project-scaffold.md`。

## When to Use

- 用户要求**安装或更新**本 skill（upsert → 询问是否建项目）
- 用户明确说「按 vibe coding 开新项目 / 生成骨架 / 初始化环境 / 对齐目录」
- 用户在询问后明确同意立即新建项目

## How to Help

### A. 安装或更新 skill（upsert）

当用户要求从本仓库安装/更新时：

1. 定位目标 skills 目录（项目级或用户级：`.cursor/skills`、`.claude/skills`、`.agents/skills` 等）。
2. 对点名的每个 skill：目录不存在则拷贝；已存在则用仓库 `skills/<name>/` **整目录覆盖**为当前版本。
3. 回报：装到哪、新建还是更新。
4. **询问**：是否现在按 vibe-coding 新建项目（将做环境检测 + 生成骨架）。
5. 用户明确同意 → 继续 B；用户说先不 / 未同意 → **停住**。

### B. 创建或初始化项目

**前置：** 用户已明确同意新建/初始化项目（见「何时开工」），或主动发出开新项目指令。

1. **确认** — 英文项目名，以及 `product/` 里的必要产品信息。缺口收成一次方案选择（见 `references/project-scaffold.md`），选定或按建议采用后继续。栈默认如上，用户另说才改。
2. **环境检测与安装** — 按 `references/environment-setup.md`：识别 OS → **只检测本期要建的端所需工具** → 仅补缺失 → 复检通过。还不建端时跳过。本步在生成对应端之前完成。
3. **生成骨架** — 按 `references/project-scaffold.md`：产品材料写入 `product/`，只建本期需要的端并做最小可运行初始化。
4. **写入约定** — 原则摘要写入生成项目**根 README**（已有端的栈、目录、运行方式）；细则读 `references/principles.md`。
5. **提示词** — 需要时把 `references/prompts.md` 的用法写进 README。
6. **验收** — 走 `references/checklist.md`，缺口列给用户或当场补。
7. **再开发** — 业务写在对应目录；`web` 与 `admin` 保持分工程；换栈需用户明确授权。

## Core Principles

- upsert 后先问再开工
- 环境先于要建的端，端先于业务（在已确认开工之后）
- 用不到的端不建
- 必要产品信息进 `product/`；缺口一次给方案，然后继续
- 栈保持默认，除非用户改
- `web` 与 `admin` 分离
- 小步可演示

见 `references/principles.md`。

## Questions to Help Users

upsert 后只问是否现在建项目。确认开工后，必要产品信息的缺口合成**一次**选择，给出 2～3 个方案并标明建议项；用户选定或未选时按建议写入 `product/`，然后继续。本机系统自己探测。

- 「要现在按 vibe-coding 新建项目吗？」
- 缺口示例：「本期可以按这三种走：A 只做网页；B 网页 + 接口；C 网页 + 接口 + 后台。建议 B，因为……你选哪个？」

## Common Mistakes to Flag

- upsert 完成后未询问就自动建项目或装工具
- 用户说先不 / 未明确同意却继续开工
- 跳过环境检测就生成本期需要的端，导致无法编译、跑前端或起 compose
- 对已可用工具强行升级或换成 beta/nightly
- 用不到的 `server` / `web` / `admin` / `deploy` 先建空目录
- 必要产品信息没写入 `product/` 就写代码
- 同一件事反复追问，或不给方案只抛问题
- 名词、原型等非必要项没齐就停住不开工
- 本期需要的端还没建就写业务
- 把 `web` 和 `admin` 揉成一个前端
- 未授权换栈（例如改成 React）
- 建了端却只写代码，README 里没有本地启动说明（有 `deploy` 时还要有 compose 说明）

## Deep Dive

- `references/environment-setup.md` — OS 分支检测与安装
- `references/project-scaffold.md` — 生成项目的目录与初始化
- `references/principles.md` — 原则
- `references/prompts.md` — 常用提示
- `references/checklist.md` — 验收清单
