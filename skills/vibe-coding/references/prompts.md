# 提示词入口

根 README 有一条可复制提示词：**upsert skill → 询问是否建项目 → 用户确认后再开工**。日常继续用下面指令；装 skill 本身不会自动开工。

## 开新项目

```text
按 vibe-coding skill，在 ~/workspace/projects/<英文名> 开工。
先把产品材料收进 product/。要做的每一页写 product/<页面名>/结构草稿.json，不写 PRD 和 HTML 原型。本期只建这些端：<例如 web，或 server+web+deploy>。
只检测这些端要用的工具（缺什么装稳定版，已有保持）。
建到的前端用 Vue3+Ant Design Vue（npm），页面视觉按已安装的 frontend-design（没有就从 anthropics/skills 装上再读）。建了 server 再用 Go Gin+GORM。
基础设施都用 /srv/docker/<组件> 这一份（mysql、redis、elasticsearch 以及以后的）。启动时只拉本项目要用的。
有 server 时在共用 MySQL 上为本服务建自己的库，用 DATABASE_URL 或 DSN 连接。项目 compose 里不要再起基础设施。
用不到的端不要建。用 Git 做版本管理：初始化仓库、写 .gitignore、首次提交。目标：<一句话>
完成后重启服务，用浏览器走通，告诉我实际访问地址和自测结果，并提交这次改动。不要推远程。
```

## 对齐已有仓库

```text
按 vibe-coding 检查当前项目：产品层内容补进 product/；缺的是本期需要的端才补，用不到的端不要新建。基础设施改为共用 /srv/docker/<组件>，启动时只拉本项目要用的。保持当前栈。
```

## 改完跑起来

```text
这次改动做完后重启服务，用浏览器走通这次改的路径，再告诉我实际访问地址和自测结果，然后提交。不要推远程。
```

## 做最小可演示竖切

```text
在现有骨架上做最小竖切：server 一个 API + web 一页能调通。验收：<...>
```

## 准备本地跑起来

```text
只启动本项目要用的 /srv/docker/<组件>，备好自己的库或命名空间，并补齐 README 与 .env.example。不要在项目 compose 里再起一套基础设施。
```

## 只补环境

```text
按 vibe-coding 的 environment-setup，检测本机 Go/Node/Docker；缺的装稳定版，已有保持。
```
