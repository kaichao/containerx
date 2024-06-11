# qemu目录映射

为了将主机目录映射到虚拟机内部，可以使用QEMU的 virtio-9p 文件系统共享功能。
在现代QEMU虚拟化环境中，virtiofs 是一个比 9p 更高效的共享文件系统选项。virtiofs 提供更好的性能和更低的延迟，尤其适用于虚拟机和主机之间的文件共享。

## 1. 准备主机上的共享目录：
在主机上创建一个要共享的目录，例如 /host_shared.

```sh
mkdir -p /host_shared
```

## 2. 启动虚拟机并挂载共享目录

使用QEMU启动虚拟机并配置 virtio-9p 文件系统共享。假设我们共享 /host_shared 目录到虚拟机内部的 /guest_shared 目录。

```sh
qemu-system-x86_64 -m 2048 -hda centos.qcow2 -fsdev local,id=myid,path=/host_shared,security_model=none -device virtio-9p-pci,fsdev=myid,mount_tag=hostshare -nographic -serial mon:stdio

qemu-system-x86_64 \
    -m 2048 \
    -hda centos7.img \
    -fsdev local,id=myid,path=/host_shared,security_model=none \
    -device virtio-9p-pci,fsdev=myid,mount_tag=hostshare \
    -append "root=/dev/sda1 console=ttyS0" \
    -nographic

qemu-system-x86_64 \
    -m 2048 \
    -hda centos7.img \
    -append "root=/dev/sda1 console=ttyS0" \
    -nographic

```

## 3. 在虚拟机内部挂载共享目录

在虚拟机内部执行以下命令以挂载共享目录。假设你已经登录到虚拟机的单用户模式。

```sh
mkdir -p /guest_shared
mount -t 9p -o trans=virtio hostshare /guest_shared

```

这里，hostshare 是在启动QEMU时指定的 mount_tag，/guest_shared 是虚拟机内部的挂载点。

## 4. 自动化整个过程

如果希望在启动虚拟机时自动运行命令 ls -l / 并退出，可以使用以下脚本。假设虚拟机已经配置为单用户模式登录。

```sh
#!/bin/bash

# 启动虚拟机并共享目录
qemu-system-x86_64 -m 2048 -hda centos.qcow2 -fsdev local,id=myid,path=/host_shared,security_model=none -device virtio-9p-pci,fsdev=myid,mount_tag=hostshare -nographic -serial mon:stdio <<EOF
mkdir -p /guest_shared
mount -t 9p -o trans=virtio hostshare /guest_shared
ls -l /
exit
EOF

```

这个脚本将启动虚拟机，挂载主机上的共享目录 /host_shared 到虚拟机内部的 /guest_shared，然后运行 ls -l / 并退出。

通过这些步骤，你可以将主机上的目录映射到虚拟机内部，并在虚拟机内部访问和使用该目录的内容。


## 配置和使用 virtiofs

### 安装 virtiofsd

首先，需要确保 virtiofsd（virtiofs的守护进程）已安装。通常它包含在 qemu 包中，但在一些发行版中，您可能需要单独安装。
```sh
yum install qemu-virtiofsd
```

### 准备主机共享目录：
在主机上创建一个要共享的目录，例如 /host_shared。

```bash
mkdir -p /host_shared
```

### 启动 virtiofsd：
启动 virtiofsd 守护进程。

```bash
sudo virtiofsd --socket-path=/tmp/vhostqemu -o source=/host_shared
```
### 启动QEMU虚拟机：
使用 virtiofs 选项启动虚拟机，并将主机目录映射到虚拟机。

```bash
qemu-system-x86_64 \
    -m 2048 \
    -hda centos7.img \
    -chardev socket,id=char0,path=/tmp/vhostqemu \
    -device vhost-user-fs-pci,chardev=char0,tag=myfs \
    -append "root=/dev/sda1 console=ttyS0" \
    -nographic
```
### 在虚拟机中挂载共享目录：

```bash
mkdir -p /mnt/host_shared
mount -t virtiofs myfs /mnt/host_shared
ls -l /
```
