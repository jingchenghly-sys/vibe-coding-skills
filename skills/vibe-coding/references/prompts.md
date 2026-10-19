# 提示词入口

根 README 有一条可复制提示词：**upsert skill → 询问是否建项目 → 用户确认后再开工**。日常继续用下面指令；装 skill 本身不会自动开工。

## 开新项目

```text
按 vibe-coding skill，在 ~/workspace/projects/<英文名> 开工。
先把产品材料收进 product/。本期只建这些端：<例如 web，或 server+web+deploy>。
只检测这些端要用的工具（缺什么装稳定版，已有保持）。
建到的前端用 Vue3+Ant Design Vue（npm）；建了 server 再用 Go Gin+GORM+MySQL，
deploy 用 docker compose（含 MySQL），server 用 DATABASE_URL 或 DSN 连接。
用不到的端不要建。目标：<一句话>
```

## 对齐已有仓库

```text
按 vibe-coding 检查当前项目：产品层内容补进 product/；缺的是本期需要的端才补，用不到的端不要新建。保持当前栈。
```

## 做最小可演示竖切

```text
在现有骨架上做最小竖切：server 一个 API + web 一页能调通。验收：<...>
```

## 准备本地跑起来

```text
补齐 deploy/docker-compose（含 MySQL）与 README、.env.example，让我能一条命令（或两步）起库和服务。
```

## 只补环境

```text
按 vibe-coding 的 environment-setup，检测本机 Go/Node/Docker；缺的装稳定版，已有保持。
```
