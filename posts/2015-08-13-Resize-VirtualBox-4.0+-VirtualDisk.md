title: 给VirtualBox 4.0+的虚拟盘(VDI)文件扩容
description:
category: VirtualBox
tag: 虚拟机;扩容
-------------------------

## 给VirtualBox 4.0+的虚拟盘(VDI)文件扩容

VirtualBox 4.0 版增加了一个非常酷的新功能：您可以在几秒钟内完成对虚拟硬盘容量的修改。
而在此之前，您需要安装Gparted，并且操作也很繁琐。

在VirtualBox 4.0中修改虚拟盘镜像文件(.VDI)，首先找到您要修改的 .vdi 文件所在的文件夹。通常应该是

`~/.VirtualBox/HardDisks`

或者是

`~/VirtualBox VMs`

然后打开一个终端，把文件所在目录切换为当前目录

`~$ cd ~/.VirtualBox/HardDisks/`

并且运行下面这行命令：

`VBoxManage modifyhd YOUR_HARD_DISK.vdi --resize SIZE_IN_MB`

其中参数 YOUR_HARD_DISK.vdi 是您要修改的 VirtualBox 虚拟硬盘镜像文件。而参数 SIZE_IN_MB 是指修改后的硬盘容量，单位是兆字节。
比如下面这行命令将会把名为"ubuntu.vdi"的 VirtualBox 硬盘容量修改为40000兆。

`VBoxManage modifyhd ubuntu.vdi --resize 40000`

几秒后VirtualBox硬盘的容量修改完毕

## 扩展分区

启动虚拟机，通过df -h查看发现，根目录大小还是原样，下面我们通过gparted来扩展分区

查看当前系统分区情况

`sudo fdisk -l `

首先创建新的分区:

`sudo fdisk /dev/sda`

然后n, p, ...等各种回车后创建了分区4

将分区格式化为ext4格式:

`sudo mkfs.ext4 /dev/sda4`

现在准备工作完成, 目前虚拟机的空间分布为:

***	| [ / ]	16G | [ SWAP ] 2G	|	[ FREE ]	22G|	***

因为只是用的根分区的简单分区方式, 所以下面直接使用gparted重新调整一下大小:

>禁用[SWAP], 删除, 此时后面会合并为[FREE]24G

>调整[/]大小为32G, 然后创建[SWAP]为8G

调整后空间分布如下:

***	| [ / ]	32G | [ SWAP ] 8G	|***
