# examples

## vibe-coding

1. 用根 README 的提示词：upsert skill → Agent 询问是否新建项目。
2. 你明确同意后：环境检测 + 在 `~/workspace/projects/demo-app` 生成骨架。若说先不，则停住。
3. 已装好、之后再开工：直接说「按 vibe-coding 在 ~/workspace/projects/demo-app 生成项目骨架」。
4. 确认开工后的预期：

```text
~/workspace/projects/demo-app/
  product/  README.md
  # 本期需要的端才出现。例如只要网页和接口：
  server/  web/  deploy/
```

建到的端才用对应栈：Vue3+Ant Design Vue、Go Gin+GORM+MySQL、Docker Compose（含 MySQL）；前端默认 npm。用不到的端不建。
