# Containerx - 面向多平台嵌入式应用的容器化封装技术

- 嵌入式的主要操作系统
  - Linux
  - Vxworks
  - QNX
  - FreeBSD
  - ...


- 嵌入式主要芯片架构
  - x86/x86_64
  - arm/aarch64
  - riscv
  - m68k
  - ppc64
  - mips
  - ...

- 容器化技术嵌入式应用支持不完善
  - docker仅在Linux系统上，支持相同芯片架构下的不同操作系统
  - 嵌入式系统种类多，普遍都缺乏成熟的容器化技术


## 技术方案

- 在容器镜像内，集成开源的QEMU（Quick EMUlation）软件，对非宿主芯片架构做软硬件的系统级仿真，支持异构芯片架构上应用的运行，进而实现不同嵌入式平台上应用的统一封装。
- 基于RancherOS实现。

## QEMU(Quick EMUlation)
Qemu is a processor emulating virtualization software with many virtual devices support (such as HDD,RAM,sound,ethernet,USB,VGA , etc.)

KVM is a kernel module which allows passing through CPU cores via host-passthrough without virtualizing them. It also allows passing through PCI devices via vfio-pci kernel module.

All these passthrough functionality are possible via IOMMU (Input output memory mapping unit), which maps real DMA addresses to virtualized addresses so direct access becomes possible and it brings bare-metal (native) performance. IOMMU is a mechanism which is part software in kernel and part hardware in chipsets, featured as VT-D (vmx) AMD-VI (svm). SR-IOV is a chipset feature which allows splitting one PCI device to many virtual ones without performance drop via parallelized direct IO access.

- Libvirt is a library, allowing you to use python and other programming languages to configure virtual machines. 
- Virsh is a toolkit which works in terminal to monitor and configure virtual machine settings. 
- Virt-manager is VMware player like GUI as an alternative to virsh and it uses libvirt.

- Qemu-img is a cli tool which creates, converts, snapshots disk images. 
- Qemu-nbd is also a CLI tool which allows raw I/O access to virtual disk through network via nbd. 
- Virtio is the iommu access driver and method name to disks, NICs (ethernet) and video. 
- Virgl is OpenGL supporting virtio VGA. Redhat and Fedora has virtio driver ISO CD ROM images for windows and Linux in their websites.

- OVMF is open virtual machine firmware which provides UEFI boot image for qemu virtual machines. 
- Spice is a very fast VNC client for qemu virtual machines.

## 主要功能设计

集成qemu系统级仿真，以虚机形式支持嵌入式软件的容器化，构建docker基础镜像，通过环境变量设置，支持非原生的嵌入式操作系统、芯片架构。

- 在x86_64/arm平台上，支持以下系统级仿真：
  - qemu-system-aarch64（仅x86_64）
  - qemu-system-arm（仅x86_64）
  - qemu-system-mips
  - qemu-system-mips64
  - qemu-system-ppc64
  - qemu-system-riscv32
  - qemu-system-riscv64

- 在容器中启动vm，虚机镜像采用分层存储格式。第1层为操作系统，为只读层；第2层嵌入式应用代码及运行环境。存储格式采用qcow2格式。容器内还应包括uefi固件文件、OS内核文件（vmlinuz）、initrd(intial ram disk)、根文件系统镜像文件等。针对主要嵌入式操作系统，应该预构建出独立的操作系统基础镜像。

- 网络：容器、虚机都可用host网络。暂不考虑网络层安全设置。

- host系统采用64位Linux，芯片架构包括x86_64、aarch64等。若芯片体系同构，用kvm加速，否则用tcg加速。

- 容器、vm之间存储共享采用virtiofs。

- 软件应提供类似于docker build的命令，支持将嵌入式应用打包为容器镜像（含容器镜像中的QEMU镜像）。而软件运行直接用docker run即可。

## 相关软件
- [docker-qemu](https://github.com/tianon/docker-qemu) - Dockerization of supported QEMU releases
- [qemu-docker](https://github.com/qemus/qemu-docker) - QEMU in a Docker container.
- [qemu-arm](https://github.com/qemus/qemu-arm) - QEMU for ARM in a Docker container.
- [balena-io-library/base-images](https://github.com/balena-io-library/base-images/) - 物联网操作系统BalenaOS的容器镜像
- [RancherOS](https://github.com/rancher/os) - Tiny Linux distro that runs the entire OS as Docker containers
- [Linux Lab](https://github.com/tinyclub/linux-lab) - Docker/Qemu Based Linux Kernel Learning, Development and Testing Environment