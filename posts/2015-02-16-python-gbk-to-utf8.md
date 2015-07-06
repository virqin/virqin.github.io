title: python批量转换GBK编码文件到UTF8
description:
category: python
tag: python
-------------------------
网上经常下载到使用GBK编码的代码，如果使用sublime之类的编辑器经常会乱码，win下notepad++对GBK支持很优秀，但是不跨平台。所有一般会事先转化为UTF-8编码再打开。

目前shell下可以使用的编码转换工具包括enca，convmv，iconv。其中enca，convmv大部分发行版必须自己安装

- enca用法：`find -type f | xargs enca -L zh_CN -x UTF-8` 把当前目录所有文本文件转化到UTF-8编码
- convmv用法： `convmv -f GBK -t UTF-8 --notest utf8 filename`  
- iconv用法： `iconv -f GBK -t UTF-8 file1 -o file2`

enca可以智能跳过不需要转换的文件，iconv在源文件已经是UTF-8编码的时候还会继续转换，然后会出现乱码而且无法还原，所以在没有备份文件的情况下慎用iconv命令。
python有一个模块chardet可以检测一段未知文本的编码，用这个模块可以很轻易的山寨出enca的编码检测功能。于是写了一个小脚本。
测试了下速度比enca慢了很多，主要时间花在chardet检测编码上，尽管已经为大文件优化了。
不过python的好处是可以跨平台，如果在windows下的话用enca这样的工具会很麻烦(cygwin?)。

代码地址：(http://git.oschina.net/wkc/autogbktoutf8)

```python
#!/usr/bin/env python
#coding=utf8
from __future__ import print_function
from __future__ import unicode_literals
import os
import os.path
import codecs
import chardet
from chardet.universaldetector import UniversalDetector

import argparse
parser = argparse.ArgumentParser(description='')
parser.add_argument('path',nargs=1)
parser.add_argument('-v',choices=('none','all'),default="none")
args = parser.parse_args()

path = args.path[0]
file_list = []
for root, dirs, files in os.walk(path):
    for name in files:
        path = os.path.join(root, name)
        file_list.append(path)

allow_file_type = ['.'+i for i in 'cpp|c|py|java|txt|cc|go|h'.split('|')]
all_file_type = list(set([os.path.splitext(i)[1] for i in file_list]))
print("all file type:",all_file_type)
print("allow file type:",allow_file_type)
print("ignore file type:",list(set(all_file_type)-set(allow_file_type)))

detector = UniversalDetector()

def check(name):
    if os.path.splitext(name)[1] not in allow_file_type:
        if args.v=='all':print("ignore",name)
        return
    detector.reset()
    for line in open(name,'rb'):
        detector.feed(line)
        if detector.done:break
    detector.close()
    if args.v=='all':print(name,detector.result)
    if detector.result['encoding'] in ['Big5','GB2312','GB18030','EUC-TW', 'HZ-GB-2312', 'ISO-2022-CN']:
        print("start ",name,end='   ')
        gbk_to_utf8(name)
        print("success")

def gbk_to_utf8(name):
    data = codecs.open(name,'r','gbk').read()
    codecs.open(name,'w','utf8').write(data)

for i in file_list:
    try:
        check(i)
    except Exception as e:
        print(e)
```
