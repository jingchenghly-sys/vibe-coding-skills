# 生成项目骨架（skill 产出物）

本 skill **创建/对齐新项目**时，按下面落地。根路径默认：

`~/workspace/projects/<project-name>/`

`<project-name>` 用英文 kebab-case（或用户指定的英文名）。

**前置**：用户已确认创建/初始化项目。先判断本期要哪些端，再按 `environment-setup.md` 只检测这些端要用的工具。

## 技术栈（环境初始化默认值）

| 层 | 选型 |
| --- | --- |
| 前端 `web` / `admin` | Vue 3 + Ant Design Vue（包管理默认 **npm**） |
| 后端 `server` | Go + Gin + GORM + **MySQL** |
| 部署 `deploy` | Docker + Docker Compose（含 **MySQL** 稳定版服务） |

用户明确改栈之前，**创建到该端时**按上表初始化。没建的端不装对应工具，也不留空目录。

## 目录结构

固定有根 `README.md` 和 `product/`。端只在项目需要时创建：

```text
~/workspace/projects/<project-name>/
├── .git/             # 始终有：Git 仓库
├── .gitignore
├── product/          # 始终有：产品层材料收在这里
├── README.md         # 如何安装 / 跑起来；含已有端的栈与目录约定
├── server/           # 按需：后端 Go（Gin + GORM → MySQL）
├── web/              # 按需：网页 + H5（Vue3 + Ant Design Vue）
├── admin/            # 按需：管理后台（Vue3 + Ant Design Vue）
└── deploy/           # 按需：Dockerfile、docker-compose（含 mysql）等
```

### 何时建端

| 端 | 本期需要时才建 |
| --- | --- |
| `server/` | 要 API、领域逻辑或数据库 |
| `web/` | 要用户侧网页或 H5 |
| `admin/` | 要管理后台 |
| `deploy/` | 要容器或本机编排（通常跟着要跑的 `server`，或用户明确要部署） |

判断来自用户点名，或本期目标明显依赖该端。看不出来先问要哪几端，不要猜成全套，也不要先建空壳占位。以后需要某一端，再补建并按上表初始化。

`web` 与 `admin` 若都要，保持两个前端工程，除非用户明确要求合并。

### 产品信息收进 `product/`

`product/README.md` 记下本期必要信息。已知的直接写；对话和笔记里后出现的也补进去。这六项齐了就按它开工，缺项不再逐条追问：

| 项 | 写什么 |
| --- | --- |
| 用户 | 谁在用 |
| 目标 | 一句话解决什么 |
| 场景 | 在什么情况下用 |
| 范围 | 本期做 / 不做 |
| 主路径 | 走通演示的几步 |
| 端 | 本期要哪些端 |

名词、页面说明、原型、已定决策：出现了就按主题另存文件。没有就留空，不为凑齐再问。接口、库表、目录职责、怎么跑留在对应端和根 `README.md`。已有内容合并，不覆盖用户改过的段落。

必要项有缺口时，收成**一次**选择：给出 2～3 个可执行方案，标明建议采用哪一个以及差别。用户选定后写入 `product/` 再继续。同一件事不追问第二轮；用户没选，就按建议方案写下，并注明「按建议采用，可改」，然后开工。

### 各目录职责

| 目录 | 职责 | 创建该目录时至少做什么 |
| --- | --- | --- |
| `product/` | 必要产品信息 | `README.md` 写齐用户、目标、场景、范围、主路径、端；其余按主题追加 |
| `server/` | API / 领域逻辑 | Go module、Gin 入口、GORM 连 MySQL（读 `DATABASE_URL` 或等价 DSN）、基础目录（如 `cmd/` / `internal/`，按常见 Go 习惯，保持简洁） |
| `web/` | C 端网页 + H5 | Vue3 + Ant Design Vue 工程骨架，能用 npm `dev` 起来 |
| `admin/` | 管理后台 | 独立 Vue3 + Ant Design Vue 工程骨架（与 `web` 分离） |
| `deploy/` | 容器与编排 | `docker-compose.yml`：有 `server` 时含 **mysql**（官方稳定镜像，如 `mysql:8`）及对应服务的 Dockerfile；README 写清 compose 与 env |

## 数据库约定（有 `server` 时默认 MySQL）

没有 `server`、用户也没要数据库时，不配 MySQL，也不为数据库单独建 `deploy`。用户要部署已有的端时，仍可建 `deploy`。

- **引擎**：MySQL（稳定版镜像；用户另说再换）。
- **编排**：`deploy/docker-compose.yml`（或项目约定路径）提供 `mysql` 服务，挂持久卷，暴露常见端口（如 `3306`）。
- **连接**：`server` 通过环境变量连接，优先 `DATABASE_URL`；也可用拆开的 `DB_HOST` / `DB_PORT` / `DB_USER` / `DB_PASSWORD` / `DB_NAME` 拼 DSN。提供 `.env.example`（真密钥不进库）。
- **GORM**：用 MySQL 驱动初始化；健康检查或启动时能连上 compose 里的 MySQL（文档写清启动顺序：先 `docker compose up` 起库，再跑 server，或 compose 内依赖 `depends_on` + 就绪等待）。

示例（说明用，具体值写进生成项目的 `.env.example` / README）：

```bash
# 常见写法之一
DATABASE_URL=mysql://user:password@127.0.0.1:3306/app?charset=utf8mb4&parseTime=True&loc=Local
```

## Agent 落地规则

1. 根目录名英文；若用户给了中文名，先确认英文目录名再创建。
2. **先把必要产品信息写入 `product/`，再只建本期需要的端。** 缺口最多一次方案选择。用不到的端不建、不占位。
3. 已有仓库则**合并对齐**，保留用户已有内容；约定写入 README。不删除用户已有、本期用不到的端。
4. 建了 `server` 或 `deploy` 时，先把本地怎么跑（及 compose / MySQL）写清楚，再堆业务功能。
5. `web` 与 `admin` 都存在时保持两个前端工程，除非用户明确要求合并。
6. 骨架落成且已有可运行的端后，当场跑起来，并把实际访问地址告诉用户。之后每次调整修改同样如此（见 `SKILL.md` 的「改完即运行」）。
7. **用 Git 做版本管理。** 还不是仓库就 `git init`，写好 `.gitignore`，骨架落地后做首次提交。之后每次调整修改落地并跑完（或确认这次没有可运行的端）后提交一次。已是仓库则沿用，不重新初始化，不改历史。不推远程，除非用户要求。不改 git config；因缺少用户身份提交失败时告诉用户，不代为设置。

`.gitignore` 至少忽略：`.env`（保留 `.env.example`）、密钥、`node_modules/`、`dist/`、构建产物、本机系统文件。真密钥不入库。

## 仍可微调

- 必要产品信息或本期要哪些端看不清时，并进同一次方案选择，不另开追问。
- 用户若指定其他数据库，再改 `deploy` 与 GORM 驱动，并更新 README。
