title: 修改QXDM(3.12.714)去掉IE版本检测
description:
category: QXDM
tag: QXDM
-------------------------

#修改QXDM (ver3.12.714/914) 安装文件使其能在Win7/Win10 (64位)下安装运行

Win10下安装QXDM一直卡在检测IE的版本步骤不能安装。

遂修改之，过程很复杂，结果很简单，只要修改2个字节安装并正常运行。

#方法

修改QXDMInstaller.msi 安装文件, 偏移 `0xd2cf` 开始的两个字节 `0x32` `0xc0` 为 `0xb0` `0x01` 既可以了


#原帖地址

`http://forum.51nb.com/thread-1478699-1-1.html`

膜拜大神

