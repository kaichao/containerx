#!/bin/sh
# 启动 Docker 守护进程
dockerd &
# 保持容器运行
tail -f /dev/null
