# 安装最小空间占用的centos7虚拟机

要安装一个最小空间占用的CentOS 7虚拟机，可以按照以下步骤进行。这些步骤将指导您创建一个基础的CentOS 7虚拟机镜像，安装最少的软件包，并使用压缩的qcow2镜像格式来节省空间。

## 步骤 1: 准备必要的工具和文件
### 下载CentOS 7 Minimal ISO：
从CentOS官方网站下载最小化安装的ISO文件（例如 CentOS-7-x86_64-Minimal-2009.iso）。


### 安装QEMU和其他依赖工具：
确保您已经安装了QEMU和其他必要的工具，例如 qemu-img。

```sh
brew install qemu
```

## 步骤 2: 创建虚拟机磁盘镜像
### 创建一个qcow2格式的虚拟磁盘：
创建一个10GB的虚拟磁盘镜像文件，您可以根据需要调整大小。

```bash
qemu-img create -f qcow2 centos7-minimal.qcow2 10G
```

## 步骤 3: 安装CentOS 7 Minimal
### 使用QEMU启动虚拟机并安装操作系统：
使用下载的Minimal ISO文件启动虚拟机并进行操作系统安装。

```bash
qemu-system-x86_64 \
    -m 1024 \
    -cdrom CentOS-7-x86_64-Minimal-2009.iso \
    -drive file=centos7-minimal.qcow2,format=qcow2 \
    -boot d \
    -net nic \
    -net user
```

### 安装过程：

启动虚拟机后，您将进入CentOS安装界面。
选择安装语言，配置键盘和网络设置。
在安装类型中选择 "Minimal Install" 以安装最小化系统。
配置安装目标，选择创建的虚拟磁盘。
设置root密码并创建一个用户帐户。
完成安装后，重启系统。

## 步骤 4: 最小化系统空间占用

### 登录系统：
重启后，使用root帐户登录系统。
```bash
qemu-system-x86_64 \
    -m 1024 \
    -drive file=centos7-minimal.qcow2,format=qcow2 \
    -net nic \
    -net user
```


### 删除不必要的软件包和文件：

#### 删除未使用的软件包：

```bash
yum remove -y \*documentation\*
```

#### 清理缓存文件：

```bash
yum clean all
```

#### 删除不必要的日志文件：

```bash
rm -rf /var/log/*
```
压缩文件系统：
确保文件系统使用尽可能少的空间。

```bash
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
```
## 步骤 5: 优化qcow2镜像
### 使用qemu-img压缩镜像：
使用 qemu-img 工具将虚拟机磁盘镜像压缩。

```bash
qemu-img convert -O qcow2 centos7-minimal.qcow2 centos7-minimal-compressed.qcow2
```

### 替换原始镜像：
删除原始镜像并使用压缩后的镜像。

```bash
mv centos7-minimal-compressed.qcow2 centos7-minimal.qcow2
```

## 总结
通过上述步骤，您可以创建一个最小空间占用的CentOS 7虚拟机。关键步骤包括使用Minimal ISO进行安装、删除不必要的软件包和文件，以及使用qcow2格式和qemu-img工具进行磁盘压缩。这将确保您的虚拟机占用尽可能少的磁盘空间。