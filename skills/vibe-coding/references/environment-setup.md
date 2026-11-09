# 运行环境检测与安装

用户已确认新建项目，或主动要求初始化本机环境时，才运行脚本。只 upsert skill、用户还没同意时不运行。

执行脚本，不阅读脚本源码。脚本在本 skill 目录里，用它的绝对路径调用，不拷进业务项目。

macOS、Linux、Git Bash：

```bash
bash "<skills 目录>/vibe-coding/scripts/setup-env.sh" [--server] [--web] [--admin] [--docker]
```

Windows PowerShell：

```powershell
& "<skills 目录>\vibe-coding\scripts\setup-env.ps1" [-Server] [-Web] [-Admin] [-Docker]
```

参数只加本期要建的端：`--server` 检查 Go；`--web` 或 `--admin` 检查 Node 与 npm；要用共用基础设施或要建 `deploy` 时加 `--docker`。Git 每次都查。

白机：缺少的工具解压到用户目录 `~/.local`，不安装 Homebrew、apt 或 winget。Go、Node、Docker 客户端用官方压缩包。Git 在 macOS 和 Linux 上从官方源码编译进 `~/.local`，本机没有 C 编译器或 make 时输出要执行的命令。Docker 守护进程不随压缩包启动；Linux 上 `sudo manual` 给出 `dockerd` 命令，macOS 上打开已经安装的 Docker。装好后重新运行脚本。

已装一部分：能运行的命令保持原版本，只装缺少的。nvm、Volta、asdf、fnm 和已安装的 Docker Desktop 会先被找到，不另装一份。用户指定了某个版本时，不要用脚本装那一项。

脚本不安装 MySQL、Redis、Elasticsearch。连接见 `shared-infra.md`。

退出码 0 后，把脚本输出写进项目根 README 的「开发环境」。出现 `daemon-down` 时写明需要启动 Docker。有 `path add` 时把那行 `export PATH` 写进同一节。退出码非 0 时按脚本输出说明失败原因，不另编安装命令。

新的 `web` / `admin` 用 npm。项目里已有 `pnpm-lock.yaml` 或 `yarn.lock` 则沿用该包管理器。

然后执行 `project-scaffold.md`。有 `server` 时使用共用 MySQL，并为该服务创建自己的库。
