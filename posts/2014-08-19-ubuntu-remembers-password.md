title: 如何修改sudo命令输入密码的时间
description: 
category: linux
tag: ubuntu shell
-------------------
默认sudo记住密码的时间是15分钟,如果你想要修改它的话

`sudo visudo`
这会打开一个编辑器打开编辑 /etc/sudoers

把 `defaults env_reset` 这一行修改为
`Defaults env_reset , timestamp_timeout=xx`

x 就是代表时间，如果是0就会每次询问密码,否则密码会保存x分钟,

另外也可以设置为 -1 ，这样当你在注销或退出 terminal 之前，都会记住密码。当这样做的时候，有时为了安全考虑，你也可以运行以下命令来强制退出sudo

sudo -K
英文原文:

By default sudo remembers your password for 15 minutes. If you want to change that you can do so by

sudo visudo
This opens an editor and points it to the sudoers file -- Ubuntu defaults to nano, other systems use Vi. You're now a super user editing one of the most important files on your system. No stress!

(Vi specific instructions noted with (vi!). Ignore these if you're using nano)

Use the arrow keys to move to the end of the Defaults line. 
(vi!) press the A (capital "a") key to move at the end of the current line and enter editing mode (append after the last character on the line).

Now type
,timestamp_timeout=X
where X is the timeout expiration in minutes. If you specify 0 you will always be asked the password. If you specify a negative value, the timeout will never expire. E.g. Defaults env_reset,timestamp_timeout=5

(vi!) hit Escape to return to command mode. Now, if you're happy with your editing, type in :w <ENTER> to write the file and :q <ENTER> to exit vi. If you made a mistake, perhaps the easiest way is to redo from start, to exit without saving (hit Escape to enter the command mode) and then type :q! <ENTER>.

hit CTRL + X, then Y, then <ENTER> to save your file and exit nano.

You might want to read the sudoers and vi manual pages for additional information.

man sudoers

man vi