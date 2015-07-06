title: ssh shell 笔记
description: 
category: linux
tag: linux ubuntu shell ssh
-------------------


一个正常的ssh连接命令是类似于 `ssh user@11.11.11.11`

如果远程用户名和本地用户名相同的话，可以省去 user@

如果修改了ssh端口的话，ssh后面跟-p myport ， 注意scp命令用的是-P

正常连接是需要输入密码的，把ssh替换为ssh-copy-id 连接一次之后以后就不需要输入密码了，事先可能需要ssh-keygen

这时 ssh命令已经简化为 `ssh 11.11.11.11`,然后下一步，为IP加上别名。

 `$ sudo vim /etc/hosts`

然后加上 `11.11.11.11 s11`类似的一行， 保存即可，然后就可以 `ssh s11` 连接了。

事实上此时在浏览器中输入`s11`就可以打开对于服务器上的网站，（第一次可能必须输入`http://s11`，否则浏览器可能会误识别为关键字从而调用搜索引擎搜索。)

然后下一步，提高连接速度。

修改 ssh配置文件  /etc/ssh/ssh_config 或者 ~/.ssh/config

    Host *
        ControlMaster auto
        ControlPath ~/.ssh/master-%r@%h:%p

然后只要连接过一次ssh，以后再次连接就很快了。

也可以把   `ssh -M -N -f myserver` 加入开机启动，这样第一次连接也会很快了。

下一步，优化ssh体验。

首先把bash扔掉，换成oh-my-zsh
官方主页 https://github.com/robbyrussell/oh-my-zsh

    sudo apt-get install zsh
    curl -L http://install.ohmyz.sh | sh
    sudo chsh /bin/zsh

然后vim ~/.zshrc ，在plugins=()这一行加上常用的插件，用空格分割。

简单介绍下几个插件：

- autojump： 可以j 文件夹名 模糊跳转到最常用的文件夹。
- extract： 一句 x filename 就可以解压任何压缩文件，无需记忆各种解压程序的命令。
- sudo： 按两下 esc 就可以在当前命令前面加上 sudo
- tmux，screen,git,svn,docker,python，fabric 为对应的软件的自动补全插件，如果自己有常用命令不能补全的也可以照着写个补全插件。

更多插件见 https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview

zsh的几个技巧：

- 大部分情况都可以省略cd命令， 可以直接输入文件夹名称,`..`, `~`。
- 进入一个很深的目录的时候可以只打每个目录名的一部分。
- zsh可以放心的定义超短别名而不必担心冲突，如 autojump的j，例如我把ipython notebook映射为i。

然后是终端管理工具，tmux，screen自己选择。还有一个byobu，是tmux的封装，把一些常用的操作的快捷键都改为f1-f12而不需要按两次组合键，并且可以提供cpu等信息显示，不过可能会和某些软件的快捷键会冲突，如htop。

byobu最常用的三个快捷键 

- F2                 打开一个新的窗口
- F3                进入前一个窗口
- F4                 进入后一个窗口

这三个工具都可以纯键盘实现复制粘贴，也可以切分窗口（类似vim），具体参照文档。
然后提一下gnome的默认终端。（系统 ubuntu desktop 14.04）
ctrl+shift+t 可以新建标签。 alt+数字 可以切换到第N个标签。ctrl+shift+w关闭标签。
设置里面可以调整窗口为半透明，方便一般看代码一边敲命令。

---------------2014-11-05更新
