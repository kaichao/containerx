# docker上非主流系统平台镜像

## docker hub上镜像的主要硬件架构
- os/arch:      prefix
- linux/386:
- windows/amd64:    winamd64
- linux/amd64:
- linux/arm/v7: arm32v7 arm32v6 arm32v5
- linux/arm64/v8: arm64v8
- linux/riscv64: riscv64
- linux/mips64le:   mips64le
- linux/ppc64le:
- linux/s390x:


## 如何在x86架构的Linux上，运行arm64的docker镜像？

- [multiarch/qemu-user-static](https://github.com/multiarch/qemu-user-static)

### 设置 QEMU 用户模式二进制文件
```sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

### 支持以下CPU架构
```
alpha
arm
armeb
sparc
sparc32plus
sparc64
ppc
ppc64
ppc64le
m68k
mips
mipsel
mipsn32
mipsn32el
mips64
mips64el
sh4
sh4eb
s390x
aarch64
aarch64_be
hppa
riscv32
riscv64
xtensa
xtensaeb
microblaze
microblazeel
or1k
hexagon
```

### 运行 ARM64 Docker 镜像
```sh
docker run --rm --platform linux/arm64/v8 arm64v8/ubuntu uname -m
```

### Docker支持的平台

```sh
docker buildx inspect default --bootstrap
```

Platforms: linux/amd64, linux/amd64/v2, linux/amd64/v3, linux/386, linux/arm64, linux/riscv64, linux/ppc64, linux/ppc64le, linux/s390x, linux/mips64le, linux/mips64, linux/arm/v7, linux/arm/v6


- 启动虚机，运行后退出
运行一个命令而不需要手动交互，你可以通过在启动命令中添加-kernel选项来运行内核映像文件，并通过-initrd选项来指定initramfs文件。
```sh
qemu-system-x86_64 -kernel /path/to/kernel -initrd /path/to/initramfs -append "console=ttyS0" -nographic
```
这将直接启动内核并运行initramfs，当命令执行完成后，虚拟机将自动退出。

