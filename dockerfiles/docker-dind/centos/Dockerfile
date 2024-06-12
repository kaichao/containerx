# 使用 CentOS 作为基础镜像
FROM centos:7

# 安装必要的包
RUN yum install -y yum-utils
#  \
#     device-mapper-persistent-data \
#     lvm2

# 设置 Docker 仓库
RUN yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# 安装 Docker
RUN yum install -y docker-ce docker-ce-cli containerd.io

# 启动 Docker 服务
CMD ["dockerd"]
