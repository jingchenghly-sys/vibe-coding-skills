# 检查清单（生成项目后勾选）

## 环境（先于骨架）

- [ ] 已识别 OS（macOS / Linux / Windows）
- [ ] Go 可用（`go version`）；缺失才装稳定版，已有则保持
- [ ] Node + npm 可用；缺失才装稳定/LTS；默认包管理 npm
- [ ] Docker + `docker compose` 可用（daemon 可连或已说明需启动）
- [ ] 安装通道为稳定版（非 beta / nightly / tip / canary）

## 目录

- [ ] 根目录在 `~/workspace/projects/<英文名>/`（或用户指定路径）
- [ ] 存在：`server/`、`web/`、`admin/`、`product/`、`deploy/`
- [ ] 根 `README.md` 写清职责、如何运行、栈与目录约定摘要（含 MySQL）

## 栈

- [ ] `server`：Go + Gin + GORM → MySQL（可编译或有明确下一步；读 `DATABASE_URL` 或等价 DSN）
- [ ] `web`：Vue3 + Ant Design Vue
- [ ] `admin`：Vue3 + Ant Design Vue（可先占位工程）
- [ ] `deploy`：`docker-compose` 含 **MySQL** 稳定版服务，且 README 有用法

## 质量底线

- [ ] 密钥不进库（`.env` 示例可有，真密钥无）
- [ ] `product/` 至少有项目一句话目标
