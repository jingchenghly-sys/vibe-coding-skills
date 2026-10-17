# 运行环境检测与安装

生成/初始化业务项目**之前**，先按用户操作系统检测工具链。未指定 OS 时，用本机信息判断（`uname`、`$OSTYPE`、或询问用户）。

## 策略（强制）

| 情况 | 做法 |
| --- | --- |
| 已安装且命令可用（版本能跑通本 skill 默认栈） | **不要升级、不要换版本** |
| 缺失或命令不可用 | 安装**较新的稳定版**（官方/包管理器当前 stable；禁止 beta / nightly / tip / canary） |
| 用户明确要求某版本 | 按其要求 |

检测以「能跑通」为准：命令在 PATH 中且 `--version` / `version` 成功即可，不必追求最新号。

## 需要覆盖的工具

| 工具 | 用途 | 检测示例 |
| --- | --- | --- |
| **Go** | `server`（Gin + GORM） | `go version` |
| **Node.js** | `web` / `admin`（Vue3） | `node -v`（建议 ≥ 20 LTS 稳定线；已有可用 Node 则不动） |
| **包管理器** | 前端依赖 | 默认 **npm**（随 Node）；若用户已用 pnpm/yarn 且可用则沿用，**新环境默认 npm** |
| **Docker** | 镜像构建 | `docker version` |
| **Docker Compose** | `deploy` 编排 | `docker compose version`（优先 Compose V2 插件；旧 `docker-compose` 可用亦可） |

前端栈：Vue3 + Ant Design Vue。后端：Go + Gin + GORM。本文件只负责**本机工具链**，不改业务栈选型。

## 检测流程（Agent）

1. 识别 OS：`macOS` / `Linux` / `Windows`。
2. 逐项跑检测命令；记录「已有 / 缺失」。
3. **只安装缺失项**；已有则跳过。
4. 安装后复检；失败则给出官方文档链接与手工步骤，不要 silently 假成功。
5. 把结果简短写进生成项目根 `README.md`「开发环境」一节（或对话里交代），再进入脚手架生成。

## macOS（优先 Homebrew）

```bash
# 检测
go version; node -v; npm -v; docker version; docker compose version

# 缺失时（示例；按缺什么装什么）
# 无 brew 时先装：https://brew.sh
brew install go            # 稳定 formula，勿用 --HEAD
brew install node          # 当前稳定 Node；勿装夜间构建
# npm 随 node，一般无需另装
brew install --cask docker # Docker Desktop（含 compose 插件）
# 装完后启动 Docker Desktop，再复检 docker / docker compose
```

说明：若已有 Go/Node/Docker 且命令可用，**跳过对应 brew install**。

## Linux（按发行版）

先检测同上。安装优先发行版稳定源或官方稳定通道。

### Debian / Ubuntu

```bash
# Go：官方稳定 tarball 或发行版包（任选其一；已有 go 则跳过）
# 示例（版本号换成安装时官方当前 stable，勿用 tip）：
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

WSL2：若用户主要在 WSL 内开发，按 **Linux** 分支在 WSL 内安装；Docker Desktop 可开 WSL integration。不要在未确认的情况下同时乱装两套并改 PATH。

## 默认包管理约定

- **默认：npm**（随 Node 安装即可用）。
- 生成 `web`/`admin` 时：`npm create` / `npm install` / `npm run dev`。
- 若项目里已有 `pnpm-lock.yaml` 或用户声明用 pnpm，则用 pnpm；**不要**无故从 npm 换成 pnpm。

## 安装后最低验收

- [ ] `go version` 成功
- [ ] `node -v` 与 `npm -v` 成功
- [ ] `docker version` 成功（daemon 可连；若仅 CLI 无 daemon，在 README 注明需启动 Docker）
- [ ] `docker compose version` 成功
- [ ] 未改动用户已有可用工具的版本

然后再执行 `project-scaffold.md` 中的目录生成与栈初始化。
