# vibe-coding-skills

可安装的 Agent Skill 仓库：工程骨架 + 产品草稿/PRD（可分开装，也可一起用）。

布局参考：[refoundai/lenny-skills](https://github.com/refoundai/lenny-skills)（`skills/<name>/SKILL.md` + `references/`）。本仓库不绑定某一家 IDE；只要能读 `SKILL.md` 即可。

## Skills

| Skill | 路径 | 做什么 |
| --- | --- | --- |
| **vibe-coding** | `skills/vibe-coding/` | 用户确认建项目后：检测/补齐本机工具，在 `~/workspace/projects/<name>/` 生成 `server` / `web` / `admin` / `product` / `deploy` 骨架（Vue3+Ant Design Vue、Go Gin+GORM、Docker Compose） |
| **product-forge** | `skills/product-forge/` | 用户明确要求做某一页时：想法 → 概述 + 模块 `结构草稿.json` + `PRD.md`；无代码时加 HTML 原型，有代码时同步改项目。结构草稿是协商入口 |

配合用法：先 upsert skill →（若用户同意）用 vibe-coding 起工程 → 再用 product-forge 在 `product/` 下落产品工件。两个 skill 均可单独安装；**安装或更新 ≠ 自动开工**。

## 两层别搞混

| | 是什么 | 长什么样 |
| --- | --- | --- |
| **本仓库** | skill 定义（给 AI 装的） | `skills/vibe-coding/`、`skills/product-forge/` |
| **生成出的业务项目** | skill 的产出物 | `~/workspace/projects/<name>/{server,web,admin,product,deploy}` |

## 给 Agent 的提示词（复制即用）

流程固定三步：**upsert skill → 询问是否新建项目 → 用户明确同意后再做环境检测与骨架**。安装逻辑为 upsert（不存在则安装，已存在则覆盖更新）。仓库：

`https://github.com/jingchenghly-sys/vibe-coding-skills`

按需增删列表中的 skill 名（`vibe-coding` / `product-forge`）。

```text
请从 https://github.com/jingchenghly-sys/vibe-coding-skills 安装或更新以下 skill（upsert）：
- vibe-coding
- product-forge

规则：
1. 找到本机或本项目的 skills 目录（如 .cursor/skills、.claude/skills、.agents/skills，或用户级 ~/.cursor/skills 等）。
2. 对每个列出的 skill：目标目录不存在则拷贝安装；已存在则用仓库里 skills/<name>/ 的当前内容覆盖更新（含 references/）。
3. upsert 完成后：简短回报装到了哪个目录、新建还是更新了哪些 skill；然后询问我是否现在按 vibe-coding 新建项目（会做环境检测 + 生成 server/web/admin/product/deploy 骨架）。
4. 等我明确同意后再开工；我说先不、或未明确同意时停住。不要自动写 product-forge 草稿，除非我接着要求做某一页。
```

### 手动安装（可选）

```bash
git clone https://github.com/jingchenghly-sys/vibe-coding-skills.git
SKILLS_ROOT=.claude/skills   # 或 .agents/skills 或 .cursor/skills
rm -rf "$SKILLS_ROOT/vibe-coding" "$SKILLS_ROOT/product-forge"
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

1. Agent 完成 upsert，回报路径与新建/更新结果。
2. Agent **询问**是否立即按 vibe-coding 新建项目。
3. 用户明确同意 → 环境检测（缺啥补啥）+ 生成骨架；用户说先不 / 未同意 → 停住。
4. product-forge：装好后等用户明确要求做某一页，才写草稿 / PRD / 原型。

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
- [ ] 单一提示词：upsert → 询问 → 确认后开工
- [ ] 可单独安装 `vibe-coding` 或 `product-forge`

## 许可

MIT（见 `LICENSE`）。Copyright © 2026 jingchenghly-sys。
