# 检查清单（生成项目后勾选）

## 环境（先于要建的端）

- [ ] 已识别 OS（macOS / Linux / Windows）
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

## 质量底线

- [ ] 密钥不进库（`.env` 示例可有，真密钥无）
- [ ] `product/README.md` 有用户、目标、场景、范围、主路径、本期的端
- [ ] 未定项已按选定方案或「按建议采用，可改」写入，没有留着待追问的清单
