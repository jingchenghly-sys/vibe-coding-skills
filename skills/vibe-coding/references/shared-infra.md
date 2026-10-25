# 共用基础设施

MySQL、Redis、Elasticsearch，以及以后新增的基础设施，都全机共用一份，放在 `/srv/docker/<组件>/`。不放进某个业务项目的 compose。

每个组件目录相同：

```text
/srv/docker/
└── <组件>/                 # mysql、redis、elasticsearch，以及以后的组件
    ├── compose.yaml
    ├── .env
    ├── conf/
    ├── data/
    ├── log/
    └── secrets/
```

| 路径 | 放什么 |
| --- | --- |
| `compose.yaml` | 这一份组件的编排。镜像用该组件的官方稳定版 |
| `.env` | 非密钥：端口等。不写密码，不写各服务的账号 |
| `conf/` | 服务端配置 |
| `data/` | 数据卷。已有数据不覆盖、不删除 |
| `log/` | 日志 |
| `secrets/` | 密码文件，单行一个。不进业务项目仓库 |

业务项目只连接自己要用的组件，并只占用自己的那一份资源：MySQL 是一个库，Redis 的 key 都在本服务前缀下，Elasticsearch 是自己的索引前缀。

## 每个服务单独一个账号

用户名和库名相同，用服务名，连字符改成下划线。权限只给这个库（或 Redis、Elasticsearch 上自己的命名空间），不给管理权限。

准备本服务的资源时，读该组件的管理密码。MySQL 就是读 `/srv/docker/mysql/secrets/mysql_root_password.txt`。文件在本机这个路径，所以启动准备读得到。用它建库、建账号、授权。管理密码不写进项目仓库，也不放进业务进程的环境变量。

业务进程只读自己的密码：`/srv/docker/<组件>/secrets/<服务名>.txt`。端口读组件 `.env`。这个文件还没有时生成一次并建账号；已经有就沿用，不重新生成。拼好的连接串写入本项目未提交的 `.env`。`.env.example` 只留变量名，并注明密码文件路径。

## MySQL

默认有 `server` 就要 MySQL。目录名是 `mysql`。镜像 `mysql:8`。`conf/my.cnf` 使用 `utf8mb4`。实例只用 root 启动，密码来自 `secrets/mysql_root_password.txt`。不设置 `MYSQL_DATABASE`，也不设一个共用业务用户。

`demo-app` 的库名和用户名都是 `demo_app`。密码文件是 `/srv/docker/mysql/secrets/demo_app.txt`。准备时用 root 密码执行：没有库就建库，没有用户就建用户，并 `GRANT` 该用户只访问 `demo_app`。端口读 `/srv/docker/mysql/.env`，没有则 `3306`。

```bash
# 项目 .env.example：不写真实密码。
# 用户名 = 库名 = demo_app
# 密码来自 /srv/docker/mysql/secrets/demo_app.txt
DATABASE_URL=mysql://demo_app:password@127.0.0.1:3306/demo_app?charset=utf8mb4&parseTime=True&loc=Local
```

## Redis

每个服务用一个短前缀，这个服务的 key 全部写成 `前缀:...`。例如服务 `xxx` 的 key 是 `xxx:session:1`。

前缀用服务短名，全小写，里面不含冒号。第一次用 Redis 时选定，写入 `/srv/docker/redis/prefixes/<服务名>`，内容只有这个短名。别的服务已经占用的前缀不能再用。写定之后不改。

业务代码和脚本只读写自己前缀下的 key。不清空整个实例，不删其他前缀。

```bash
# 项目 .env.example
REDIS_KEY_PREFIX=xxx
```

## 按需启动

项目跑起来之前，先列出它实际依赖的组件。默认：有 `server` 才依赖 MySQL。Redis、Elasticsearch 和其他组件，只有本期用到才算依赖。

对列出的每一个组件：

1. 还没有 `/srv/docker/<组件>/compose.yaml` 时，按上面的目录建一次。
2. 已经有就复用。不另起一套，不改已有 `data/`、`secrets/`、`conf/`。
3. 只在该组件目录执行 `docker compose up -d`。
4. 再准备本服务自己的资源。MySQL 则读取 root 密码，建库、建本服务账号，并只授予该库。

然后启动本项目的端。停掉本项目时，不把共用组件停掉，其他服务可能还在用。

业务项目的 `deploy/` 只编排这个服务自己的进程，里面不写任何基础设施。

对齐旧项目时：去掉该项目 compose 里的基础设施服务，改为连接 `/srv/docker/<组件>/`。项目里已有的数据卷不自动删。

用户明确要换数据库，或直连自己已有的实例时：沿用那一份，不另起、不覆盖已有数据。连接与驱动按用户指定的来，写进项目 `.env` 和 README。管理密码仍然不进业务进程。
