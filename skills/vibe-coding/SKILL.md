---
name: vibe-coding
description: Help users scaffold new projects under ~/workspace/projects with Vue3+Ant Design Vue (web/admin), Go Gin+GORM (server), and Docker Compose (deploy). Use when starting a vibe-coding project, generating project skeleton, or aligning repo structure.
---

# Vibe Coding

用本 skill **生成并推进**统一项目骨架（不是改 skill 仓库本身）。

## 生成项目默认约定

- **根路径**：`~/workspace/projects/<project-name>/`（英文名）
- **目录**：`.cursor/` · `server/` · `web/` · `admin/` · `product/` · `deploy/`
- **栈**：前端 Vue3 + Ant Design Vue；后端 Go + Gin + GORM；部署 Docker + Docker Compose

详情见 `references/project-scaffold.md`。

## When to Use

- 「按 vibe coding 开新项目 / 生成骨架」
- 「对齐目录约定 / 初始化环境」
- 用户安装本 skill 后开始做新项目

## How to Help

1. **确认** — 英文项目名、一句话目标；栈默认如上，用户另说才改。
2. **生成骨架** — 按 `references/project-scaffold.md` 建齐目录并做最小可运行初始化。
3. **写入约定** — 原则摘要放进生成项目的 `.cursor/`（及根 README）；细则读 `references/principles.md`。
4. **提示词** — 需要时把 `references/prompts.md` 的用法写进 README 或 `.cursor`。
5. **验收** — 走 `references/checklist.md`，缺口列给用户或当场补。
6. **再开发** — 业务写在对应目录；不合并 `web`/`admin`；不擅自换栈。

## Core Principles

- 骨架先于业务
- 栈不漂移
- `web` 与 `admin` 分离
- 小步可演示

见 `references/principles.md`。

## Questions to Help Users

- 「项目英文目录名用什么？」
- 「一句话目标？第一期最小演示是什么？」
- 「数据库用 Postgres 还是 MySQL？（未指定则我选常见默认并写进 deploy）」

## Common Mistakes to Flag

- 缺目录就写业务
- 把 `web` 和 `admin` 揉成一个前端
- 未授权换栈（例如改成 React / 换 Web 框架）
- 只写代码不写怎么用 compose 跑起来

## Deep Dive

- `references/project-scaffold.md` — 生成项目的目录与初始化
- `references/principles.md` — 原则
- `references/prompts.md` — 常用提示
- `references/checklist.md` — 验收清单
