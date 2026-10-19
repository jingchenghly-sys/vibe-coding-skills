# 检查清单（生成项目后勾选）

## 环境（先于要建的端）

- [ ] 已识别 OS（macOS / Linux / Windows）
- [ ] Git 可用（`git --version`）；缺失才装稳定版
- [ ] 只检测本期要建的端：有 `server` 才要求 Go；有 `web` 或 `admin` 才要求 Node + npm；有 `deploy` 才要求 Docker + `docker compose`
- [ ] 缺失才装稳定版，已有则保持；通道为稳定版（非 beta / nightly / tip / canary）
- [ ] 本期不建端时，未安装 Go / Node / Docker

## 目录

- [ ] 根目录在 `~/workspace/projects/<英文名>/`（或用户指定路径）
- [ ] 存在 `product/`；`server/`、`web/`、`admin/`、`deploy/` 仅本期需要的才存在
- [ ] 没有为空占位而建的端
- [ ] 根 `README.md` 写清已有目录的职责与如何运行

## 栈（只核已创建的端）

- [ ] `server`：Go + Gin + GORM → MySQL（可编译或有明确下一步；读 `DATABASE_URL` 或等价 DSN）
- [ ] `web`：Vue3 + Ant Design Vue
- [ ] `admin`：Vue3 + Ant Design Vue，且与 `web` 分工程
- [ ] `deploy`：有 `server` 时 `docker-compose` 含 **MySQL** 稳定版服务，且 README 有用法

## 运行

- [ ] 已有可运行的端时，进程已启动（含本次改动）
- [ ] 已把实际访问地址告诉用户：`web` / `admin` 为页面地址，`server` 为 API 根或健康检查
- [ ] 地址来自进程监听，不是猜的端口
- [ ] 只有 `product/`、没有端时，已说明暂无可访问地址

## Git

- [ ] 项目根目录是 Git 仓库；新建时已 `git init`，已有仓库未重新初始化
- [ ] `.gitignore` 忽略 `.env`、密钥、`node_modules/`、`dist/` 与构建产物，并保留 `.env.example`
- [ ] 骨架或本次修改已提交；未要求时没有推远程
- [ ] 未改 git config，未改历史

## 质量底线

- [ ] 密钥不进库（`.env` 示例可有，真密钥无）
- [ ] `product/README.md` 有用户、目标、场景、范围、主路径、本期的端
- [ ] 未定项已按选定方案或「按建议采用，可改」写入，没有留着待追问的清单
