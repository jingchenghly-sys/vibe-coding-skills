# examples

## vibe-coding

1. 安装 `skills/vibe-coding`（见根 README）。
2. 说：「按 vibe-coding 在 ~/workspace/projects/demo-app 生成项目骨架」。
3. 预期：

```text
~/workspace/projects/demo-app/
  server/  web/  admin/  product/  deploy/  README.md
```

栈为 Vue3+Ant Design Vue、Go Gin+GORM、Docker Compose；前端默认 npm。

## product-forge

1. 安装 `skills/product-forge`（可与 vibe-coding 同装）。
2. 说：「按 product-forge，做个人名片里的个人主页」。
3. 无代码时预期：`{项目}/概述.md` + `{模块}/结构草稿.json` + `PRD.md` + `原型.html`。
4. 已在 vibe-coding 工程内时：工件落在 `product/`，有代码则同步改 `web`/`admin`/`server`。
