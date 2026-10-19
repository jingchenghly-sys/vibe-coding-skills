# 运行环境检测与安装

**触发：** 用户已确认新建项目（或主动要求生成骨架 / 初始化本机环境）时再执行本文件。仅 upsert skill 或用户尚未同意建项目时，不跑本文件。

生成要建的端**之前**，先按用户操作系统检测工具链。未指定 OS 时，用本机信息判断（`uname`、`$OSTYPE`、或询问用户）。

**只检测本期要创建的端。** 有 `server` 才看 Go；有 `web` 或 `admin` 才看 Node 与 npm；有 `deploy` 才看 Docker 与 Compose。本期只收产品材料、还不建端时，不安装这些工具。

## 策略

| 情况 | 做法 |
| --- | --- |
| 已安装且命令可用（版本能跑通本 skill 默认栈） | 保持现状 |
| 缺失或命令不可用 | 安装**较新的稳定版**（官方/包管理器当前 stable） |
| 用户明确要求某版本 | 按其要求 |

检测以「能跑通」为准：命令在 PATH 中且 `--version` / `version` 成功即可。安装通道用稳定版（stable / LTS），不用 beta、nightly、tip、canary。

## 需要覆盖的工具

| 工具 | 何时需要 | 检测示例 |
| --- | --- | --- |
| **Go** | 要建 `server` | `go version` |
| **Node.js** | 要建 `web` 或 `admin` | `node -v`（建议 ≥ 20 LTS 稳定线；已有可用 Node 则保持） |
| **包管理器** | 同上，前端依赖 | 默认 **npm**（随 Node）；若用户已用 pnpm/yarn 且可用则沿用，**新环境默认 npm** |
| **Docker** | 要建 `deploy` | `docker version` |
| **Docker Compose** | 要建 `deploy` | `docker compose version`（优先 Compose V2 插件；旧 `docker-compose` 可用亦可） |

前端栈：Vue3 + Ant Design Vue。后端：Go + Gin + GORM + **MySQL**。本文件只负责**本机工具链**。

**数据库：** 有 `server` 时，默认由项目 `deploy/docker-compose` 起 MySQL 稳定版服务，一般**不必**本机单独装 MySQL；有 Docker 即可。没有 `server` 则不为此装 Docker、也不配 MySQL。若用户本机已有可用 MySQL 并希望直连，保持其版本，在 README / `.env` 里改连接串即可。

## 检测流程（Agent）

1. 识别 OS：`macOS` / `Linux` / `Windows`。
2. 只对上表里本期需要的工具跑检测；记录「已有 / 缺失 / 本期不需要」。
3. **只安装缺失项**；已有则跳过。
4. 安装后复检；失败则给出官方文档链接与手工步骤，并如实说明状态。
5. 把结果简短写进生成项目根 `README.md`「开发环境」一节（或对话里交代），再进入脚手架生成。

## macOS（优先 Homebrew）

```bash
# 检测
go version; node -v; npm -v; docker version; docker compose version

# 缺失时（示例；按缺什么装什么）
# 无 brew 时先装：https://brew.sh
brew install go            # 稳定 formula
brew install node          # 当前稳定 Node
# npm 随 node，一般无需另装
brew install --cask docker # Docker Desktop（含 compose 插件）
# 装完后启动 Docker Desktop，再复检 docker / docker compose
```

说明：若已有 Go/Node/Docker 且命令可用，跳过对应 brew install。

## Linux（按发行版）

先检测同上。安装优先发行版稳定源或官方稳定通道。

### Debian / Ubuntu

```bash
# Go：官方稳定 tarball 或发行版包（任选其一；已有 go 则跳过）
# 示例（版本号换成安装时官方当前 stable）：
# curl -fsSL https://go.dev/dl/go<STABLE>.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
# export PATH=/usr/local/go/bin:$PATH

# Node：NodeSource 或 nvm 的 LTS 稳定线；或发行版 `nodejs`/`npm` 若足够新
# Docker + Compose：按 docs.docker.com 的 Linux 安装（stable 通道），启用 compose 插件
```

### Fedora / RHEL 系

```bash
# 用 dnf 安装发行版稳定 go / nodejs / npm（若可用）
# Docker：按 Docker 官方 Fedora/CentOS 文档装 engine + compose plugin（stable）
```

### Arch

```bash
# pacman -S go nodejs npm docker docker-compose   # 仅缺什么装什么
```

Linux 上若无图形 Docker Desktop，用 Docker Engine + `docker compose` 插件即可。安装后确保用户在 `docker` 组或文档说明需 `sudo`。

## Windows

检测（PowerShell 或 Git Bash）：

```powershell
go version; node -v; npm -v; docker version; docker compose version
```

安装优先级（缺什么装什么；已有跳过）：

1. **winget**（推荐，若可用）
2. **Chocolatey** / **Scoop**
3. 官方安装器（go.dev、nodejs.org LTS、Docker Desktop for Windows）

```powershell
# 示例（包名以 winget search 当时结果为准；选官方 publisher 的稳定包）
winget install OpenJS.NodeJS.LTS
winget install GoLang.Go
winget install Docker.DockerDesktop
# npm 随 Node LTS
```

WSL2：若用户主要在 WSL 内开发，按 **Linux** 分支在 WSL 内安装；Docker Desktop 可开 WSL integration。先确认开发落在哪一侧，再改 PATH。

## 默认包管理约定

- **默认：npm**（随 Node 安装即可用）。
- 生成 `web`/`admin` 时：`npm create` / `npm install` / `npm run dev`。
- 若项目里已有 `pnpm-lock.yaml` 或用户声明用 pnpm，则沿用 pnpm。

## 安装后最低验收

只勾本期要建的端：

- [ ] 要建 `server`：`go version` 成功
- [ ] 要建 `web` 或 `admin`：`node -v` 与 `npm -v` 成功
- [ ] 要建 `deploy`：`docker version` 成功（daemon 可连；若仅 CLI 无 daemon，在 README 注明需启动 Docker）；`docker compose version` 成功
- [ ] 用户已有可用工具仍保持原版本
- [ ] 未为本期不建的端安装工具

然后再执行 `project-scaffold.md`。有 `server` 时默认 MySQL 由 compose 提供。
