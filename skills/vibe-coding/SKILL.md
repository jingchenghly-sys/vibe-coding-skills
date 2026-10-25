---
name: vibe-coding
description: >-
  Scaffold and evolve projects under ~/workspace/projects. Create only the ends
  needed now (server, web, admin, deploy): admin is Vue 3 + Ant Design Vue, web
  is Vue 3, server is Go Gin+GORM. Shared
  infrastructure is /srv/docker/<component>; each service uses only its own
  database or namespace, and startup starts only what this project needs. Put
  product material in product/, and each page in product/<page>/结构草稿.json;
  do not write PRD or HTML prototypes unless asked. After each change, restart,
  verify in one browser tab, and report the real URL. Install frontend-design
  from anthropics/skills if missing, and follow it for web/admin UI. Commit with
  git locally; do not push unless asked. When installing or updating: upsert the
  skill, then ask before any env setup or scaffolding. Use when starting a
  vibe-coding project, generating a skeleton, aligning a repo, or changing a
  generated project — not merely because this skill was installed.
---

# Vibe Coding

用本 skill 生成并推进 `~/workspace/projects/` 下的业务项目。本仓库只定义 skill。

## 开工

安装或更新本 skill 不等于创建项目，也不等于初始化环境。

1. **Upsert** — 目标 skills 目录没有则拷贝，已有则用仓库当前版本覆盖。
2. **询问** — 是否现在新建项目。
3. **确认后** — 用户明确同意，或主动说「开新项目 / 生成骨架 / 初始化环境」，再做环境与脚手架。说先不、或没同意，就停住。只问约定时说明能力即可。

## 约定

格式和例外在对应 reference，用到再读。

- **位置**：`~/workspace/projects/<英文名>/`。中文名先确认英文目录名。
- **目录**：始终有 `product/` 和根 README。`server/`、`web/`、`admin/`、`deploy/` 只在本期需要时建，不建空目录。看不出要哪几端时先问，不猜成全套。
- **产品**：`product/README.md` 记用户、目标、场景、范围、主路径、本期的端。每一页一份 `product/<页面名>/结构草稿.json`，改页面先改这份草稿。不写 PRD 和 HTML 原型，除非用户明确要。缺口收成一次 2～3 个方案并标明建议；没选就按建议写入，注明「按建议采用，可改」，然后继续。同一件事不问第二轮。
- **栈**：`admin` 为 Vue 3 + Ant Design Vue；`web` 为 Vue 3。两端都是独立工程，除非用户明确要求合并。视觉按 frontend-design，页面上有什么只来自结构草稿。后端 Go + Gin + GORM。把 `web` 换成非 Vue、换掉 `admin` 的组件库或后端栈，要用户明确授权。
- **基础设施**：全机共用 `/srv/docker/<组件>/`。有 `server` 才起 MySQL；Redis、Elasticsearch 等本期用到才起。每个服务只用自己的库或命名空间。停项目不停共用组件。`deploy/` 只含本服务。
- **frontend-design**：装本 skill 时，以及做 `web/` / `admin/` 前，按 `references/frontend-design.md` 检查。没有就装，已有不覆盖。写页面前读已安装的那份 `SKILL.md`。装失败只停前端。
- **工具**：Git 每次都要。Go、Node、Docker 只在本期要建的端需要时检测；已有可用则保持，缺失装稳定版。只在确认开工后做。
- **Git**：项目根是仓库。`.gitignore` 忽略 `.env`（保留 `.env.example`）、密钥、`node_modules/`、`dist/` 和构建产物。每次改完并自测通过后再提交；没有新改动不提交。不推远程，除非用户要求。不改 git config，不改历史。缺少用户身份就告诉用户，不代为设置。

## A. 安装或更新

1. 定位 skills 目录（`.cursor/skills`、`.claude/skills`、`.agents/skills`，或用户级对应目录）。
2. 点名的 skill：没有则拷贝，已有则用 `skills/<name>/` 整目录覆盖。
3. 按 `references/frontend-design.md` 检查 frontend-design。不因此开工。
4. 回报装到哪、新建还是更新、frontend-design 是已有还是刚装上。
5. 问是否现在新建项目。同意则进入 B，否则停住。

## B. 创建或对齐项目

前置：用户已同意，或主动要求开工。

1. 确认英文项目名，并把六项产品信息写入 `product/`。缺口按 `references/project-scaffold.md` 收成一次选择。同时检查 frontend-design。
2. 按 `references/environment-setup.md` 只补本期要建的端所缺的工具。
3. 按 `references/project-scaffold.md` 写结构草稿，只建本期需要的端，做到能在本地跑。先打通最短路径，再铺功能。已有仓库则合并，不删用户已有的端，不覆盖用户改过的产品段落。
4. 根 README 只写已经存在的端：环境、怎么起、目录职责、用到的 `/srv/docker` 组件和自己的库或命名空间。
5. 还不是 Git 仓库就 `git init` 并写好 `.gitignore`。
6. 进入 C。还没有可运行的端时，只做 C 的最后两步。

## C. 改完即运行

项目存在之后，每次写完代码：

1. 按 `references/shared-infra.md` 只启动这次要用的组件，并准备本服务自己的库或命名空间。已在跑的进程重启到包含本次改动。
2. 改了页面就先改结构草稿。做 `web/` 或 `admin/` 前读已安装的 frontend-design。
3. 从进程输出取监听地址。`web`、`admin` 是页面地址，`server` 是 API 根或健康检查。
4. 一次任务、一段对话只用一个浏览器标签。第一次在这个标签打开；之后在同一标签跳转或刷新。有页面就按这次改的路径点击、输入、提交，对照结构草稿；共用数据的相关页也在这个标签里看。只有接口就打开该接口地址核对返回。失败先修，再在这个标签重测。
5. 没通过就说明卡在哪，不把地址当成完成。通过后回复地址、走过的路径和结果。这次只改了 `product/`、还没有可运行的端：说明没有地址，不空起服务。
6. 按上面的 Git 约定提交。

## 何时读 reference

- 建目录、写 `product/`：`references/project-scaffold.md`
- 写某一页：`references/structure-draft.md`
- 接数据库、缓存或搜索：`references/shared-infra.md`
- 检测或安装本机工具：`references/environment-setup.md`
- 装或使用 frontend-design：`references/frontend-design.md`
