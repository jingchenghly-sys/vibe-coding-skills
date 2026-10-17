# vibe-coding-skills

可安装的 Agent Skill 仓库：工程骨架 + 产品草稿/PRD（可分开装，也可一起用）。

布局参考：[refoundai/lenny-skills](https://github.com/refoundai/lenny-skills)（`skills/<name>/SKILL.md` + `references/`）。本仓库不绑定某一家 IDE；只要能读 `SKILL.md` 即可。

## Skills

| Skill | 路径 | 做什么 |
| --- | --- | --- |
| **vibe-coding** | `skills/vibe-coding/` | 检测/补齐本机工具，在 `~/workspace/projects/<name>/` 生成 `server` / `web` / `admin` / `product` / `deploy` 骨架（Vue3+Ant Design Vue、Go Gin+GORM、Docker Compose） |
| **product-forge** | `skills/product-forge/` | 想法 → 概述 + 模块 `结构草稿.json` + `PRD.md`；无代码时加 HTML 原型，有代码时同步改项目。结构草稿是协商入口 |

配合用法：先用 vibe-coding 起工程，再用 product-forge 在 `product/` 下落产品工件并驱动 `web`/`admin`/`server` 实现。两个 skill 均可单独安装。

## 两层别搞混

| | 是什么 | 长什么样 |
| --- | --- | --- |
| **本仓库** | skill 定义（给 AI 装的） | `skills/vibe-coding/`、`skills/product-forge/` |
| **生成出的业务项目** | skill 的产出物 | `~/workspace/projects/<name>/{server,web,admin,product,deploy}` |

## 如何安装

把仓库地址发给 AI，例如：

```text
请从这个 GitHub 仓库安装 skills：
https://github.com/jingchenghly-sys/vibe-coding-skills

按需拷贝 skills/vibe-coding/ 和/或 skills/product-forge/
到本机或本项目的 skills 目录。
```

### 手动安装

```bash
git clone https://github.com/jingchenghly-sys/vibe-coding-skills.git
# 任选 skills 根目录（按你用的 Agent）：
SKILLS_ROOT=.claude/skills   # 或 .agents/skills 或 .cursor/skills

cp -R vibe-coding-skills/skills/vibe-coding "$SKILLS_ROOT/"
cp -R vibe-coding-skills/skills/product-forge "$SKILLS_ROOT/"
```

用户级同理，拷到 `~/.claude/skills/`、`~/.agents/skills/` 或 `~/.cursor/skills/`。

也可用 GitHub CLI（若已安装且支持 skill 子命令）：

```bash
gh skill install jingchenghly-sys/vibe-coding-skills vibe-coding
gh skill install jingchenghly-sys/vibe-coding-skills product-forge
```

仓库约定符合 [Agent Skills 规范](https://agentskills.io/specification) 的 `skills/*/SKILL.md` 发现方式。

## 安装后预期行为

**vibe-coding**

1. Agent 发现该 skill。
2. 「按 vibe-coding 开新项目」→ 先检测/补齐 Go、Node+npm、Docker+Compose → 生成五目录骨架并按默认栈初始化。
3. 功能开发落在对应目录；换栈需明确说。

**product-forge**

1. Agent 发现该 skill。
2. 「按 product-forge 做这一页」→ 写出/更新模块结构草稿与 PRD；无代码出原型，有代码改项目。
3. 用户改 `结构草稿.json` 后说「按草稿同步」→ 重读磁盘并同步下游。

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
    ├── vibe-coding/
    │   ├── SKILL.md
    │   ├── references/
    │   │   ├── environment-setup.md
    │   │   ├── project-scaffold.md
    │   │   ├── principles.md
    │   │   ├── prompts.md
    │   │   └── checklist.md
    │   ├── assets/templates/README.md
    │   └── scripts/README.md
    └── product-forge/
        ├── SKILL.md
        └── references/
            ├── structure-draft.md
            ├── mechanical-mapping.md
            └── sync-and-reply.md
```

新增 skill：在 `skills/` 下再建 kebab-case 目录，放入带 frontmatter 的 `SKILL.md`（见 `CONTRIBUTING.md`）。

## 本地自检

- [ ] 各 skill 的 `name` 与目录名一致
- [x] README 仓库地址：`https://github.com/jingchenghly-sys/vibe-coding-skills`
- [ ] 可单独安装 `vibe-coding` 或 `product-forge`

## 许可

MIT（见 `LICENSE`）。Copyright © 2026 jingchenghly-sys。
