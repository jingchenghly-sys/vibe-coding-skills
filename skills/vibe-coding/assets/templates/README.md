# templates

可选：生成项目时可复制的文件模板。

建议后续补（非必须）：

- 根 `README.md` 模板（含环境要求、compose 用法、MySQL / `DATABASE_URL`、栈与目录约定）
- `deploy/docker-compose.yml` 骨架（含 mysql 服务）
- `.env.example`（DSN / `DATABASE_URL` 示例）

当前以 `references/project-scaffold.md` 与 `references/environment-setup.md` 为准，Agent 可直接创建文件，不必强依赖本目录。
