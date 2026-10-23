---
name: vibe-coding
description: >-
  Help users scaffold projects under ~/workspace/projects. Create only the ends the
  project needs now (server, web, admin, deploy); defaults are Vue3+Ant Design Vue,
  Go Gin+GORM, and shared infrastructure under /srv/docker/<component> (mysql, redis,
  elasticsearch, and later ones). Each service uses only its own database or namespace.
  On startup, start only the components this project needs. Always collect product-level material into
  product/. Each page being built has product/<page>/结构草稿.json; do not write
  PRD or HTML prototypes unless asked. After each code change, restart the affected
  services, verify the change in one browser tab for the whole task, and report the actual access URLs. Ensure the frontend-design skill from anthropics/skills is installed, and follow it for web/admin UI. Version the project with git: init, ignore
  secrets and build output, and commit after each landed change; do not push unless
  asked. When asked to install/update: upsert the skill,
  then ask whether to create a project now; run env setup and scaffolding only after
  the user explicitly agrees. Use when starting a vibe-coding project, generating a
  project skeleton, aligning repo structure, or changing an existing one — not merely
  because the skill was installed or updated.
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
- **产品信息**：`product/README.md` 记录用户、目标、场景、范围、主路径、本期要哪些端。要做的每一页写 `product/<页面名>/结构草稿.json`（见 `references/structure-draft.md`）。不写 PRD，不写 HTML 原型。缺口一次给出 2～3 个方案并标明建议项；选定或按建议采用后写入，然后继续
- **栈**（建到该端才用）：前端 Vue3 + Ant Design Vue，页面视觉按已安装的 `frontend-design`；后端 Go + Gin + GORM。MySQL、Redis、Elasticsearch 等基础设施都在 `/srv/docker/<组件>/` 全机共用；每个服务只用自己的库或命名空间。`deploy/` 只编排本服务
- **前端设计**：依赖 [frontend-design](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md)。安装本 skill 时，以及每次开工或改 `web/` / `admin/` 前，按 `references/frontend-design.md` 检查并安装。已有则不覆盖
- **版本管理**：项目根目录是 Git 仓库。新建则 `git init` 并提交；之后每次改完提交一次。不推远程，除非用户要求
- **本机工具**：Git 每次都要。其余只检测本期要建的端所需工具；已有可用则保持现状，缺失则装较新稳定版（见 `references/environment-setup.md`）——**仅在用户确认建项目/初始化环境后执行**

详情见 `references/project-scaffold.md`。

## When to Use

- 用户要求**安装或更新**本 skill（upsert → 询问是否建项目）
- 用户明确说「按 vibe coding 开新项目 / 生成骨架 / 初始化环境 / 对齐目录」
- 用户在询问后明确同意立即新建项目
- 用户在已生成的项目里要求调整、改功能、改页面或改接口

## How to Help

### A. 安装或更新 skill（upsert）

当用户要求从本仓库安装/更新时：

1. 定位目标 skills 目录（项目级或用户级：`.cursor/skills`、`.claude/skills`、`.agents/skills` 等）。
2. 对点名的每个 skill：目录不存在则拷贝；已存在则用仓库 `skills/<name>/` **整目录覆盖**为当前版本。
3. **检查 frontend-design** — 按 `references/frontend-design.md`，同一 skills 目录里没有就安装。不因此开工建项目。
4. 回报：装到哪、新建还是更新，以及 frontend-design 是已有还是刚装上。
5. **询问**：是否现在按 vibe-coding 新建项目（将做环境检测 + 生成骨架）。
6. 用户明确同意 → 继续 B；用户说先不 / 未同意 → **停住**。

### B. 创建或初始化项目

**前置：** 用户已明确同意新建/初始化项目（见「何时开工」），或主动发出开新项目指令。

1. **确认** — 英文项目名，以及 `product/` 里的必要产品信息。缺口收成一次方案选择（见 `references/project-scaffold.md`），选定或按建议采用后继续。栈默认如上，用户另说才改。同时按 `references/frontend-design.md` 检查并安装 frontend-design。
2. **环境检测与安装** — 按 `references/environment-setup.md`：识别 OS → **只检测本期要建的端所需工具** → 仅补缺失 → 复检通过。还不建端时跳过。本步在生成对应端之前完成。
3. **生成骨架** — 按 `references/project-scaffold.md`：产品材料写入 `product/`，要做的页面各写一份结构草稿，只建本期需要的端并做最小可运行初始化。
4. **写入约定** — 原则摘要写入生成项目**根 README**（已有端的栈、目录、运行方式）；细则读 `references/principles.md`。
5. **提示词** — 需要时把 `references/prompts.md` 的用法写进 README。
6. **验收** — 走 `references/checklist.md`，缺口列给用户或当场补。
7. **纳入 Git** — 按 `references/project-scaffold.md`：`git init`（已是仓库则跳过）、`.gitignore`、首次提交。
8. **跑起来并自测** — 已有可运行的端时，按下方 C 重启到本次改动，用浏览器走通，再告知访问地址。
9. **再开发** — 业务写在对应目录；改页面先改 `product/<页面名>/结构草稿.json`。做 `web/` 或 `admin/` 前先读已安装的 `frontend-design/SKILL.md` 并按其做视觉。`web` 与 `admin` 保持分工程；换栈需用户明确授权。每次改完仍走 C，并再提交一次。

### C. 改完即运行，并用浏览器自测

项目已经存在之后，每次写完代码或调整结束时：

1. 先按本项目的依赖，只启动 `/srv/docker/` 里要用的组件（有 `server` 默认是 MySQL；Redis、Elasticsearch 等本期用到才启动），并备好本服务自己的库或命名空间。已经在跑的进程重启到包含本次改动。不用的组件不启动，也不因为这个项目把共用组件停掉。
2. 从进程输出确认实际监听地址。`web`、`admin` 是页面地址；`server` 是 API 根或健康检查地址。
3. **用浏览器自测这次改动。** 一次任务、一段对话只用一个浏览器标签。第一次自测在这个标签打开地址；之后每次调整都在同一标签里跳转或刷新，不新开标签。有页面时按本次改的路径点击、输入、提交，确认结果与 `结构草稿.json` 一致。改了多页或共用数据时，仍在这个标签里逐页看。只有接口、没有页面时，在同一标签打开该接口地址，核对返回。自测失败就修，修好再在这个标签里测。
4. 起不来或自测没过，先说明卡在哪，不把地址当作已经完成。通过后，在回复里给出地址，并写明浏览器里走了哪条路径、结果是什么。
5. 这次只改了 `product/`、还没有可运行的端时，说明暂无可访问地址，不空起服务，也不假装做过浏览器自测。
6. 自测通过（或确认这次没有可运行的端）后再提交一次。提交说明写清为什么改。不推远程，除非用户要求。不改 git config，不改历史。密钥不入库。因缺少用户身份提交失败时告诉用户。

## Core Principles

- upsert 后先问再开工
- 环境先于要建的端，端先于业务（在已确认开工之后）
- 用不到的端不建
- 必要产品信息进 `product/`；页面结构草稿只放 `product/<页面名>/结构草稿.json`
- 缺口一次给方案，然后继续
- 栈保持默认，除非用户改
- `web` 与 `admin` 分离
- 页面视觉遵循已安装的 frontend-design
- 小步可演示
- 改完即重启服务，用浏览器走通这次改动，再给出实际访问地址
- 用 Git 做版本管理；每次改完提交，不主动推远程

见 `references/principles.md`。

## Questions to Help Users

upsert 后只问是否现在建项目。确认开工后，必要产品信息的缺口合成**一次**选择，给出 2～3 个方案并标明建议项；用户选定或未选时按建议写入 `product/`，然后继续。本机系统自己探测。

- 「要现在按 vibe-coding 新建项目吗？」
- 缺口示例：「本期可以按这三种走：A 只做网页；B 网页 + 接口；C 网页 + 接口 + 后台。建议 B，因为……你选哪个？」

## Common Mistakes to Flag

- upsert 完成后未询问就自动建项目或装工具
- 用户说先不 / 未明确同意却继续开工
- 跳过环境检测就生成本期需要的端，导致无法编译、跑前端或连上要用的基础设施
- 对已可用工具强行升级或换成 beta/nightly
- 用不到的 `server` / `web` / `admin` / `deploy` 先建空目录
- 必要产品信息没写入 `product/` 就写代码
- 页面结构写在对话、`web/` 或 `admin/` 里，没有 `product/<页面名>/结构草稿.json`
- 没让写就生成 PRD 或 HTML 原型
- 同一件事反复追问，或不给方案只抛问题
- 本期需要的端还没建就写业务
- 把 `web` 和 `admin` 揉成一个前端
- 做页面时没有安装或没有阅读 frontend-design，只按组件库默认样式堆界面
- 未授权换栈（例如改成 React）
- 建了端却只写代码，README 里没有本地启动说明（要写本项目用到的组件、位置，以及自己的库或命名空间）
- 在业务项目的 compose 里再起一套基础设施
- 启动时把本项目用不到的 Redis、Elasticsearch 或其他组件也拉起来
- 改完只写启动步骤，没有把项目跑起来
- 服务起来了，但没有用浏览器走这次改动的路径
- 只打开首页或只看截图，没有点击、输入、提交
- 同一次任务里每次调整都新开一个浏览器标签
- 访问地址是猜的端口，或服务没起来、自测没过却把地址当作完成
- 新项目没有 Git 仓库，或改完不提交
- 把 `.env`、密钥提交进库，或未要求就推远程、改 git config、改历史

## Deep Dive

- `references/environment-setup.md` — OS 分支检测与安装
- `references/project-scaffold.md` — 生成项目的目录与初始化
- `references/shared-infra.md` — 共用基础设施的目录，以及启动时只拉本项目要用的组件
- `references/structure-draft.md` — 页面结构草稿放在哪、写什么
- `references/frontend-design.md` — 何时检查并安装 frontend-design，以及页面视觉怎么用它
- `references/principles.md` — 原则
- `references/prompts.md` — 常用提示
- `references/checklist.md` — 验收清单
