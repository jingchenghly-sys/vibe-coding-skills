# scripts（扩展位）

可选可执行脚本。当前无脚本。

约定（对齐 [Agent Skills](https://agentskills.io/specification)）：

- 脚本自包含或写清依赖
- 在 `SKILL.md` 里用相对路径引用，例如 `scripts/init-scaffold.sh`
- 密钥用环境变量或本地未提交配置注入，脚本内不含密钥

TODO：是否需要一键生成目录的脚本？
