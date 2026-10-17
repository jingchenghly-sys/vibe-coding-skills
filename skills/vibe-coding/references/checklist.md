# 检查清单（生成项目后勾选）

## 目录

- [ ] 根目录在 `~/workspace/projects/<英文名>/`（或用户指定路径）
- [ ] 存在：`.cursor/`、`server/`、`web/`、`admin/`、`product/`、`deploy/`
- [ ] 根 `README.md` 写清职责与如何运行

## 栈

- [ ] `server`：Go + Gin + GORM（可编译或有明确下一步）
- [ ] `web`：Vue3 + Ant Design Vue
- [ ] `admin`：Vue3 + Ant Design Vue（可先占位工程）
- [ ] `deploy`：Docker / docker-compose 文件存在且在 README 有用法

## AI 配套

- [ ] `.cursor/` 内有简短项目约定（栈、目录、勿改栈等），便于后续会话复用

## 质量底线

- [ ] 密钥不进库（`.env` 示例可有，真密钥无）
- [ ] `product/` 至少有项目一句话目标
