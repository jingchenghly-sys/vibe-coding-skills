# Contributing

本仓 skill 各自独立目录：

| 目录 | 用途 |
| --- | --- |
| `skills/vibe-coding/` | 业务项目骨架与本机环境 |

改约定就改对应目录下的 `SKILL.md` 与 `references/`（若有）。

Frontmatter 必填：`name`（与目录同名）、`description`（做什么 + 何时用）。格式见 [Agent Skills](https://agentskills.io/specification)。

本仓库只放 skill 定义。业务项目里始终有 `product/`；`server` / `web` / `admin` / `deploy` 按需生成到用户项目目录。
