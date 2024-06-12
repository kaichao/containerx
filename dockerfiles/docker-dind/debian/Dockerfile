# 使用 Debian 作为基础镜像
FROM debian:latest

# 安装必要的包
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common ; \
# 添加 Docker 的官方 GPG 密钥
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; \
# 设置 Docker 仓库
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"; \
# 安装 Docker
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io ; \
	rm -rf /var/lib/apt/lists/*

# 复制 Docker-in-Docker 启动脚本
COPY dind.sh /usr/local/bin/dind.sh

# 运行 Docker-in-Docker 启动脚本
CMD ["sh", "/usr/local/bin/dind.sh"]
