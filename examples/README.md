# examples

## vibe-coding

1. 用根 README 的提示词：upsert skill → Agent 询问是否新建项目。
2. 你明确同意后：环境检测 + 在 `~/workspace/projects/demo-app` 生成骨架。若说先不，则停住。
3. 已装好、之后再开工：直接说「按 vibe-coding 在 ~/workspace/projects/demo-app 生成项目骨架」。
4. 确认开工后的预期：

```text
~/workspace/projects/demo-app/
  server/  web/  admin/  product/  deploy/  README.md
```

栈为 Vue3+Ant Design Vue、Go Gin+GORM+MySQL、Docker Compose（含 MySQL）；前端默认 npm。

## product-forge

1. 可与 vibe-coding 一并 upsert。装好不会自动写草稿。
2. 明确说：「按 product-forge，做个人名片里的个人主页」。
3. 无代码时预期：`{项目}/概述.md` + `{模块}/结构草稿.json` + `PRD.md` + `原型.html`。
4. 已在 vibe-coding 工程内时：工件落在 `product/`，有代码则同步改 `web`/`admin`/`server`。
