# 生成项目骨架（skill 产出物）

本 skill **创建/对齐新项目**时，按下面落地。根路径默认：

`~/workspace/projects/<project-name>/`

`<project-name>` 用英文 kebab-case（或用户指定的英文名）。

**前置**：用户已确认创建/初始化项目；且已按 `environment-setup.md` 完成环境检测与缺失安装（Go、Node+npm、Docker+Compose）。

## 技术栈（环境初始化默认值）

| 层 | 选型 |
| --- | --- |
| 前端 `web` / `admin` | Vue 3 + Ant Design Vue（包管理默认 **npm**） |
| 后端 `server` | Go + Gin + GORM |
| 部署 `deploy` | Docker + Docker Compose |

用户明确改栈之前，按上表初始化。

## 目录结构（必须）

```text
~/workspace/projects/<project-name>/
├── server/           # 后端：Go（Gin + GORM）
├── web/              # 前端：网页 + H5（Vue3 + Ant Design Vue）
├── admin/            # 管理后台（Vue3 + Ant Design Vue）
├── product/          # 产品文档、原型等
├── deploy/           # 部署：Dockerfile、docker-compose 等
└── README.md         # 如何安装 / 跑起来 / 部署；含栈与目录约定摘要
```

项目约定写在根 `README.md`（及必要时 `product/`）。

### 各目录职责

| 目录 | 职责 | 初始化时至少做什么 |
| --- | --- | --- |
| `server/` | API / 领域逻辑 | Go module、Gin 入口、GORM 占位、基础目录（如 `cmd/` / `internal/`，按常见 Go 习惯，保持简洁） |
| `web/` | C 端网页 + H5 | Vue3 + Ant Design Vue 工程骨架，能用 npm `dev` 起来 |
| `admin/` | 管理后台 | 独立 Vue3 + Ant Design Vue 工程骨架（与 `web` 分离） |
| `product/` | 需求、原型、说明 | `README.md` + 可选 `docs/` / 原型占位 |
| `deploy/` | 容器与编排 | 各服务 Dockerfile 思路 + 根级或本目录 `docker-compose.yml`，能把 server/web/admin（按需）编起来 |

## Agent 落地规则

1. 根目录名英文；若用户给了中文名，先确认英文目录名再创建。
2. **五块目录都建齐**（可先放 README 占位，目录本身要齐）。
3. 已有仓库则**合并对齐**，保留用户已有内容；约定写入 README。
4. 先把 `docker compose`（或文档中的等价命令）与本地 dev 路径写清楚，再堆业务功能。
5. `web` 与 `admin` 保持两个前端工程，除非用户明确要求合并。

## 仍可微调（问一句即可）

- 数据库具体引擎（Postgres / MySQL 等）——未指定时在 `deploy` 里用常见默认并写进 README。
- 第一期是否必须同时起 `admin`（可先占位工程，功能后补）。
