# docker-qemu相关测试

## 一、macos本地实验（CentOS7）

- 在 macos上安装 QEMU 及相关工具：
```sh
brew install qemu
```

```sh
# 下载CentOS镜像
wget https://mirrors.ustc.edu.cn/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso

# 创建一个空的虚拟磁盘文件，大小为10GB
qemu-img create -f qcow2 hda.qcow2 10G

# 在QEMU上安装CentOS
qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -cdrom ${PWD}/CentOS-7-x86_64-Minimal-2009.iso -boot d -m 2048

# GUI验证运行
qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -m 2048

# 命令行运行
qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

# 启动容器
docker run -it --rm \
	--name qemu-container \
	-v ${PWD}:/tmp \
	-e QEMU_HDA=/tmp/hda.qcow2 \
	-e QEMU_HDA_SIZE=10G \
	-e QEMU_CPU=4 \
	-e QEMU_RAM=2048 \
	-w /tmp \
	tianon/qemu bash

# 在容器中运行
qemu-system-x86_64 \
	-hda ${PWD}/hda.qcow2 \
	-m 2048 \
	-kernel ${PWD}/vmlinuz \
	-initrd ${PWD}/initramfs.img \
	-append "console=ttyS0" -nographic 

```


## 二、ubuntu arm64
- [Boot ARM64 virtual machines on QEMU](https://ubuntu.com/server/docs/boot-arm64-virtual-machines-on-qemu)

```sh
# create a VM-specific flash volume for storing NVRAM variables, which are necessary when booting EFI firmware
truncate -s 64m varstore.img

# copy the ARM UEFI firmware into a bigger file
truncate -s 64m efi.img
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=efi.img conv=notrunc

# Fetch the Ubuntu cloud image
wget https://cloud-images.ubuntu.com/noble/20240608/noble-server-cloudimg-arm64.img

# 可选择在启动后的docker-qemu容器，再在容器中运行以下命令，结果相同

# Run an emulated ARM64 VM on x86
qemu-system-aarch64 \
 -m 2048\
 -cpu max \
 -M virt \
 -nographic \
 -drive if=pflash,format=raw,file=efi.img,readonly=on \
 -drive if=pflash,format=raw,file=varstore.img \
 -drive if=none,file=noble-server-cloudimg-arm64.img,id=hd0 \
 -device virtio-blk-device,drive=hd0

#  -netdev type=tap,id=net0 \
#  -device virtio-net-device,netdev=net0 \
```
- 核查系统信息
```sh
uname -a
```

```
Linux ubuntu 6.8.0-35-generic #35-Ubuntu SMP PREEMPT_DYNAMIC Tue May 21 07:52:29 UTC 2024 aarch64 aarch64 aarch64 GNU/Linux
```


## 三、alpine系列实验

### 3.1 x86_64

```sh
# 下载文件
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86_64/alpine-standard-3.20.0-x86_64.iso -O alpine.iso 
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86_64/netboot-3.20.0/vmlinuz-virt -O vmlinuz
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86_64/netboot-3.20.0/initramfs-virt -O initramfs.img

# 初次安装
qemu-img create -f qcow2 hda.qcow2 10G
qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -cdrom ${PWD}/alpine.iso -boot d -m 2048

# 命令行运行
qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

# 在容器中运行
docker run -it --rm \
	--name qemu-container \
	-v ${PWD}:/tmp \
	-e QEMU_HDA=/tmp/hda.qcow2 \
	-e QEMU_HDA_SIZE=10G \
	-e QEMU_CPU=4 \
	-e QEMU_RAM=2048 \
	-w /tmp \
	tianon/qemu bash

qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

```

### 3.2 x86

```sh
# 下载文件
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86/alpine-standard-3.20.0-x86.iso -O alpine.iso 
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86/netboot-3.20.0/vmlinuz-lts -O vmlinuz
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/x86/netboot-3.20.0/initramfs-lts -O initramfs.img

# 初次安装
qemu-img create -f qcow2 hda.qcow2 10G
qemu-system-i386 -hda ${PWD}/hda.qcow2 -cdrom ${PWD}/alpine.iso -boot d -m 2048

# 命令行运行
qemu-system-i386 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

# 在容器中运行
docker run -it --rm \
	--name qemu-container \
	-v ${PWD}:/tmp \
	-e QEMU_HDA=/tmp/hda.qcow2 \
	-e QEMU_HDA_SIZE=10G \
	-e QEMU_CPU=4 \
	-e QEMU_RAM=2048 \
	-w /tmp \
	tianon/qemu bash

qemu-system-i386 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 
```

- 显示测试信息
```sh
uname -a
```
```
Linux (none) 6.6.31-0-lts #1-Alpine SMP PREEMPT_DYNAMIC Fri, 17 May 2024 11:04:37 +0000 i686 Linux
```

### 3.3 aarch64 (未通过测试)

```sh
# 下载文件
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/aarch64/alpine-virt-3.20.0-aarch64.iso -O alpine.iso 
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/aarch64/netboot-3.20.0/vmlinuz-virt -O vmlinuz
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/aarch64/netboot-3.20.0/initramfs-virt -O initramfs.img

# 初次安装
qemu-img create -f qcow2 hda.qcow2 10G
qemu-system-aarch64 \
	-M virt \
	-nographic \
 	-drive if=pflash,format=raw,file=efi.img,readonly=on \
 	-drive if=pflash,format=raw,file=varstore.img \
	-hda ${PWD}/hda.qcow2 \
	-cdrom ${PWD}/alpine.iso -boot d -m 2048

qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
	-hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 


qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 1024 \
    -nographic \
    -smp 2 \
    -kernel ${PWD}/alpine.iso \
    -drive if=none,file=${PWD}/hda.qcow2,id=hd0 \
    -device virtio-blk-device,drive=hd0

qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a53 \
    -m 1024 \
    -nographic \
    -smp 2 \
    -kernel ${PWD}/alpine.iso \
    -drive if=none,file=${PWD}/hda.qcow2,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -device virtio-net-device,netdev=net0


# 命令行运行
qemu-system-aarch64 -machine virt-9.0 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

# 在容器中运行
docker run -it --rm \
	--name qemu-container \
	-v ${PWD}:/tmp \
	-e QEMU_HDA=/tmp/hda.qcow2 \
	-e QEMU_HDA_SIZE=10G \
	-e QEMU_CPU=4 \
	-e QEMU_RAM=2048 \
	-w /tmp \
	tianon/qemu bash

qemu-system-x86_64 -hda ${PWD}/hda.qcow2 -m 2048 -kernel ${PWD}/vmlinuz -initrd ${PWD}/initramfs.img -append "console=ttyS0" -nographic 

```


### 3.4 arm (未通过测试)

```sh
# 下载文件
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/armhf/alpine-minirootfs-3.20.0-armhf.tar.gz
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/armhf/netboot-3.20.0/vmlinuz-rpi -O vmlinuz
wget https://mirror.lzu.edu.cn/alpine/v3.20/releases/armhf/netboot-3.20.0/initramfs-rpi -O initramfs.img

```

- 显示测试信息
```sh
uname -a
```
```
Linux (none) 6.6.31-0-lts #1-Alpine SMP PREEMPT_DYNAMIC Fri, 17 May 2024 11:04:37 +0000 i686 Linux
```

