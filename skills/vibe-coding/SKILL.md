---
name: vibe-coding
description: Help users scaffold new projects under ~/workspace/projects with Vue3+Ant Design Vue (web/admin), Go Gin+GORM (server), and Docker Compose (deploy). Detect/install OS toolchains first. Use when starting a vibe-coding project, generating project skeleton, or aligning repo structure.
---

# Vibe Coding

用本 skill **生成并推进**统一项目骨架（不是改 skill 仓库本身）。

## 生成项目默认约定

- **根路径**：`~/workspace/projects/<project-name>/`（英文名）
- **目录**：`server/` · `web/` · `admin/` · `product/` · `deploy/`
- **栈**：前端 Vue3 + Ant Design Vue；后端 Go + Gin + GORM；部署 Docker + Docker Compose
- **本机工具**：按 OS 检测；已有可用则保持现状，缺失则装较新稳定版（见 `references/environment-setup.md`）

详情见 `references/project-scaffold.md`。

## When to Use

- 「按 vibe coding 开新项目 / 生成骨架」
- 「对齐目录约定 / 初始化环境」
- 用户安装本 skill 后开始做新项目

## How to Help

1. **确认** — 英文项目名、一句话目标；栈默认如上，用户另说才改。
2. **环境检测与安装** — 按 `references/environment-setup.md`：识别 OS → 检测 Go / Node+npm / Docker+Compose → **仅补缺失** → 复检通过。本步在生成骨架之前完成。
3. **生成骨架** — 按 `references/project-scaffold.md` 建齐目录并做最小可运行初始化。
4. **写入约定** — 原则摘要写入生成项目**根 README**（栈、目录、运行方式）；细则读 `references/principles.md`。
5. **提示词** — 需要时把 `references/prompts.md` 的用法写进 README。
6. **验收** — 走 `references/checklist.md`，缺口列给用户或当场补。
7. **再开发** — 业务写在对应目录；`web` 与 `admin` 保持分工程；换栈需用户明确授权。
8. **产品页** — 需要结构草稿 / PRD /（无代码时）HTML 原型时，使用同仓的 `product-forge` skill；工件默认落在 `product/`。

## Core Principles

- 环境先于骨架，骨架先于业务
- 栈保持默认，除非用户改
- `web` 与 `admin` 分离
- 小步可演示

见 `references/principles.md`。

## Questions to Help Users

- 「项目英文目录名用什么？」
- 「一句话目标？第一期最小演示是什么？」
- 「数据库用 Postgres 还是 MySQL？（未指定则我选常见默认并写进 deploy）」
- 「本机是 macOS / Linux / Windows？（不明时我先探测）」

## Common Mistakes to Flag

- 跳过环境检测就生成项目，导致无法编译/跑前端/起 compose
- 对已可用工具强行升级或换成 beta/nightly
- 缺目录就写业务
- 把 `web` 和 `admin` 揉成一个前端
- 未授权换栈（例如改成 React）
- 只写代码、README 里没有 compose / 本地启动说明

## Deep Dive

- `references/environment-setup.md` — OS 分支检测与安装
- `references/project-scaffold.md` — 生成项目的目录与初始化
- `references/principles.md` — 原则
- `references/prompts.md` — 常用提示
- `references/checklist.md` — 验收清单
