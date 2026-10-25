# vibe-coding-skills

可安装的 Agent Skill 仓库：用户确认后生成统一工程骨架。

## Skills

| Skill | 路径 | 做什么 |
| --- | --- | --- |
| **vibe-coding** | `skills/vibe-coding/` | 用户确认后，在 `~/workspace/projects/<name>/` 按本期需要生成并推进项目。约定见 `skills/vibe-coding/SKILL.md` |

用法：先 upsert skill → 询问是否新建项目 → 用户明确同意后再做环境检测与骨架。**安装或更新 ≠ 自动开工**。

## 两层别搞混

| | 是什么 | 长什么样 |
| --- | --- | --- |
| **本仓库** | skill 定义（给 AI 装的） | `skills/vibe-coding/` |
| **生成出的业务项目** | skill 的产出物 | `~/workspace/projects/<name>/`：必有 `product/` 与 README；端按需出现 |

## 给 Agent 的提示词（复制即用）

流程固定三步：**upsert skill → 询问是否新建项目 → 用户明确同意后再做环境检测与骨架**。安装逻辑为 upsert（不存在则安装，已存在则覆盖更新）。仓库：

`https://github.com/jingchenghly-sys/vibe-coding-skills`

```text
请从 https://github.com/jingchenghly-sys/vibe-coding-skills 安装或更新以下 skill（upsert）：
- vibe-coding

规则：
1. 找到本机或本项目的 skills 目录（如 .cursor/skills、.claude/skills、.agents/skills，或用户级 ~/.cursor/skills 等）。
2. 对每个列出的 skill：目标目录不存在则拷贝安装；已存在则用仓库里 skills/<name>/ 的当前内容覆盖更新（含 references/）。
3. 同一 skills 目录检查 frontend-design：没有 frontend-design/SKILL.md 则从 https://github.com/anthropics/skills 的 skills/frontend-design/ 安装；已有则不覆盖。
4. upsert 完成后：简短回报装到了哪个目录、新建还是更新了哪些 skill，以及 frontend-design 是已有还是刚装上；然后询问我是否现在按 vibe-coding 新建项目（先把产品材料收进 product/，再按本期需要建端并检测对应工具）。
5. 等我明确同意后再开工；我说先不、或未明确同意时停住。做 web/admin 前先读已安装的 frontend-design/SKILL.md。
```

### 手动安装（可选）

```bash
git clone https://github.com/jingchenghly-sys/vibe-coding-skills.git
SKILLS_ROOT=.claude/skills   # 或 .agents/skills 或 .cursor/skills
rm -rf "$SKILLS_ROOT/vibe-coding"
cp -R vibe-coding-skills/skills/vibe-coding "$SKILLS_ROOT/"
# frontend-design：没有才装，已有不覆盖
if [ ! -f "$SKILLS_ROOT/frontend-design/SKILL.md" ]; then
  git clone --depth 1 https://github.com/anthropics/skills.git /tmp/anthropics-skills
  cp -R /tmp/anthropics-skills/skills/frontend-design "$SKILLS_ROOT/"
fi
```

用户级同理，拷到 `~/.claude/skills/`、`~/.agents/skills/` 或 `~/.cursor/skills/`。

也可用 GitHub CLI（若已安装且支持 skill 子命令）：

```bash
gh skill install jingchenghly-sys/vibe-coding-skills vibe-coding
```

仓库约定符合 [Agent Skills 规范](https://agentskills.io/specification) 的 `skills/*/SKILL.md` 发现方式。

## 安装后预期行为

1. Agent 完成 upsert，回报路径与新建/更新结果。
2. Agent **询问**是否立即按 vibe-coding 新建项目。
3. 用户明确同意 → 环境检测（缺啥补啥）+ 生成骨架；用户说先不 / 未同意 → 停住。

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
        └── references/
            ├── environment-setup.md
            ├── project-scaffold.md
            ├── shared-infra.md
            ├── structure-draft.md
            └── frontend-design.md
```

新增 skill：在 `skills/` 下再建 kebab-case 目录，放入带 frontmatter 的 `SKILL.md`（见 `CONTRIBUTING.md`）。

## 本地自检

- [ ] 各 skill 的 `name` 与目录名一致
- [x] README 仓库地址：`https://github.com/jingchenghly-sys/vibe-coding-skills`
- [ ] 单一提示词：upsert → 询问 → 确认后开工

## 许可

MIT（见 `LICENSE`）。Copyright © 2026 jingchenghly-sys。
