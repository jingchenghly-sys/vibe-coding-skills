# frontend-design 依赖

做 `web/`、`admin/` 或任何页面视觉之前，本机必须已安装 [frontend-design](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md)。安装本 skill 时检查一次；之后每次按本 skill 开工或改前端时再检查。没有就装，不询问。已有 `SKILL.md` 则沿用，不覆盖。

来源固定为 `https://github.com/anthropics/skills` 的 `skills/frontend-design/`，用仓库默认分支。

## 装到哪里

与本次安装 vibe-coding 的 skills 目录相同。运行中找不到时，用已经装有 vibe-coding 的那一处（项目级 `.cursor/skills`、`.claude/skills`、`.agents/skills`，或用户级 `~/.cursor/skills`、`~/.agents/skills`、`~/.claude/skills`）。

## 怎么装

目标目录里没有 `frontend-design/SKILL.md` 时：

```bash
git clone --depth 1 https://github.com/anthropics/skills.git /tmp/anthropics-skills
rm -rf "$SKILLS_ROOT/frontend-design"
cp -R /tmp/anthropics-skills/skills/frontend-design "$SKILLS_ROOT/"
```

装完确认 `$SKILLS_ROOT/frontend-design/SKILL.md` 存在。失败则停住前端工作并说明原因。

## 怎么用

写或改页面之前，阅读已安装的 `frontend-design/SKILL.md`，按它做视觉：配色、字体、版式、动效、文案。不凭记忆替代这份文件。

页面上有什么只来自 `product/<页面名>/结构草稿.json`。frontend-design 决定这些块怎么呈现。
