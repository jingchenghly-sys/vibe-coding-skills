# vibe-coding-skills

一个可安装的 Agent Skill 仓库：安装后，让 AI **生成**统一的业务项目骨架并按约定推进。

布局参考：[refoundai/lenny-skills](https://github.com/refoundai/lenny-skills)（`skills/<name>/SKILL.md` + `references/`）。本仓库本身不绑定某一家 IDE；只要能读 `SKILL.md` 即可。

## 两层别搞混

| | 是什么 | 长什么样 |
| --- | --- | --- |
| **本仓库** | skill 定义（给 AI 装的） | `skills/vibe-coding/SKILL.md` … |
| **生成出的业务项目** | skill 的产出物 | `~/workspace/projects/<name>/{server,web,admin,product,deploy}` |

生成项目默认栈：**Vue3 + Ant Design Vue**（`web`/`admin`，默认 npm）、**Go + Gin + GORM**（`server`）、**Docker Compose**（`deploy`）。开项目前按 OS 检测并补齐本机工具（已有不动、缺失装稳定版）。详见 `skills/vibe-coding/references/project-scaffold.md`、`environment-setup.md`。

## 这是什么

| 路径 | 作用 |
| --- | --- |
| `skills/vibe-coding/` | 唯一 skill：生成并推进上述业务项目骨架 |
| `skills/vibe-coding/references/` | 脚手架 / 原则 / 提示词 / 清单 |
| `skills/vibe-coding/assets/templates/` | 可选文件模板（扩展位） |
| `skills/vibe-coding/scripts/` | 可选脚本（扩展位） |
| `examples/` | 用法说明 |

## 如何让 AI 从 GitHub 安装

把仓库地址发给 AI，例如：

```text
请从这个 GitHub 仓库安装 vibe-coding skill：
https://github.com/jingchenghly-sys/vibe-coding-skills

按 Agent Skills 约定，把 skills/vibe-coding/ 拷到本机或本项目的 skills 目录，
然后按该 skill 推进新项目。
```

### 手动安装（推荐写法）

克隆后，把 skill 文件夹拷进当前项目的 skills 根目录（不同工具目录名略有差异，选一个即可）：

```bash
git clone https://github.com/jingchenghly-sys/vibe-coding-skills.git
# 任选其一（按你用的 Agent）：
cp -R vibe-coding-skills/skills/vibe-coding .claude/skills/
# 或
cp -R vibe-coding-skills/skills/vibe-coding .agents/skills/
# 或
cp -R vibe-coding-skills/skills/vibe-coding .cursor/skills/
```

用户级（全局）同理，拷到 `~/.claude/skills/`、`~/.agents/skills/` 或 `~/.cursor/skills/`。

也可用 GitHub CLI（若已安装且支持 skill 子命令）：

```bash
gh skill install jingchenghly-sys/vibe-coding-skills vibe-coding
```

仓库约定符合 [Agent Skills 规范](https://agentskills.io/specification) 的 `skills/*/SKILL.md` 发现方式。

## 安装后预期行为

1. Agent 发现 `vibe-coding` skill。
2. 你说「按 vibe-coding 开新项目」→ 先检测/补齐本机 Go、Node+npm、Docker+Compose → 在 `~/workspace/projects/<英文名>/` 生成 `server`/`web`/`admin`/`product`/`deploy` 骨架并按默认栈初始化。
3. 之后功能开发落在对应目录；换栈需你明确说。

## 仓库结构

```text
vibe-coding-skills/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── .gitignore
├── examples/
│   └── README.md
└── skills/
    └── vibe-coding/
        ├── SKILL.md
        ├── references/
        │   ├── environment-setup.md
        │   ├── project-scaffold.md
        │   ├── principles.md
        │   ├── prompts.md
        │   └── checklist.md
        ├── assets/
        │   └── templates/
        │       └── README.md
        └── scripts/
            └── README.md
```

新增 skill：在 `skills/` 下再建一个 kebab-case 目录，放入带 frontmatter 的 `SKILL.md`（见 `CONTRIBUTING.md`）。

## 本地自检

- [ ] `skills/vibe-coding` 的 `name` 与目录名一致
- [x] README 仓库地址：`https://github.com/jingchenghly-sys/vibe-coding-skills`
- [ ] 对 Agent 试一句「生成项目骨架」，确认产出目录与栈正确

## 许可

MIT（见 `LICENSE`）。Copyright © 2026 jingchenghly-sys。
