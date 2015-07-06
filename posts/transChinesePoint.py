#encoding=utf8
#转换中文标点
#use : python convertChinesePunctuation.py in.txt > out.txt
# wangkechun hi@hi-hi.cn
from __future__ import unicode_literals
from functools import *
import re,sys

def convent(content):
    c_p=u',,.;(({}:?+-)(*&%#@!'
    z_p=u'，，。；【】｛｝：？＋—）（×＆％＃＠！'
    def subfunc(x):
        return z_p[c_p.find(str(x.group()))]
    r = r'(?<=[^\x00-\xff])'+'[\\'+reduce(lambda a,b:a+'\\'+ b ,list(c_p))+']'
    return re.sub(r, subfunc, content)

assert convent(u'dsf.. 首先.') =='dsf.. 首先。'


if __name__ =='__main__':
    try:
        content = open(sys.argv[1]).read()
    except Exception as e:
        print('open file failed\n'+str(e))
        exit(1)
    print(convent(content))
