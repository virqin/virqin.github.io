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
`~/VirtualBox VMs`。
然后打开一个终端，把文件所在目录切换为当前目录
`~$ cd ~/.VirtualBox/HardDisks/`
并且运行下面这行命令：
`VBoxManage modifyhd YOUR_HARD_DISK.vdi --resize SIZE_IN_MB`
其中参数 YOUR_HARD_DISK.vdi 是您要修改的 VirtualBox 虚拟硬盘镜像文件。而参数 SIZE_IN_MB 是指修改后的硬盘容量，单位是兆字节。 
比如下面这行命令将会把名为"natty.vdi"的 VirtualBox 硬盘容量修改为12000兆。
`VBoxManage modifyhd natty.vdi --resize 12000`
就这么简单！几秒钟后VirtualBox硬盘的容量就修改完毕了！