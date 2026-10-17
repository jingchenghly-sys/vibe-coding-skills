# 工作原则

生成并推进项目时遵守：

## 1. 环境先于骨架，骨架先于业务

先按 `environment-setup.md` 保证 Go / Node+npm / Docker+Compose 可用，再落齐 `server` / `web` / `admin` / `product` / `deploy`，再写功能。

## 2. 栈保持默认

默认 Vue3 + Ant Design Vue、Go（Gin + GORM）、Docker Compose。换栈需用户明确授权。

## 3. 前后台分离

`web`（用户侧网页+H5）与 `admin`（管理后台）分目录、分工程。

## 4. 产品可追溯

需求与原型放 `product/`，不只活在对话里。项目约定写在根 README。

## 5. 一键能讲清怎么跑

README 写清：本机环境要求、本地怎么起、compose 怎么起、各目录职责一句话。

## 6. 小步可演示

优先打通「backend 健康检查 + 一端页面能请求到」的竖切，再铺功能。

## 7. 工具版本克制

已安装且可用 → 保持现状；缺失 → 装较新稳定版。
