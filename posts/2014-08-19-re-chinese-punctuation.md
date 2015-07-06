title: python转换英文标点
description: 
category: python
tag: python
------
因为平时写代码居多，所以将输入法设置为中文输入时使用标点，但是写点正式的中文的时候，不得不写完之后一个个查找替换标点，于是写了一个脚本来处理。
首先必须先区分代码中的标点和中文的标点，所以简单的匹配所有中文之后的标点。
然后是匹配中文， 网上找了一大堆正则如 /[u4e00-u9fa5]/ 都有问题， 后来想到直接匹配非ascii字符， 即 /[^\x00-\xff]/. 果然可以匹配中文。 
然后是单双引号的问题，由于英文标点不区分左右，所以不能直接替换，暂时忽略。
然后是代码：

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

    assert convent(u'dsf.. 首先。') =='dsf.. 首先。'


    if __name__ =='__main__':
        try:
            content = open(sys.argv[1]).read()
        except Exception as e:
            print('open file failed\n'+str(e))
            exit(1)
        print(convent(content))

