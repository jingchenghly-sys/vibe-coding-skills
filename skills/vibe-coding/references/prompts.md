# 提示词入口

安装本 skill 后，可直接对 Agent 说：

## 开新项目

```text
按 vibe-coding skill，在 ~/workspace/projects/<英文名> 生成项目骨架，
然后初始化 Vue3+Ant Design Vue（web/admin）和 Go Gin+GORM（server），
deploy 用 docker compose。目标：<一句话>
```

## 对齐已有仓库

```text
按 vibe-coding 的目录约定检查当前项目，缺什么补什么，不要改栈。
```

## 做最小可演示竖切

```text
在现有骨架上做最小竖切：server 一个 API + web 一页能调通。验收：<...>
```

## 准备本地跑起来

```text
补齐 deploy/docker-compose 与 README，让我能一条命令（或两步）起服务。
```
