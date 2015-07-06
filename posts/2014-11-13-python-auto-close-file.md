title: python 自动关闭文件的测试
description: 
category: python
tag: acm
-------------------------
在看别人的代码时候经常发现别人写入一个文件的时候的代码如下
```python
c = open('a.txt','w')
c.write('aaa')
c.close()

```
或者
```
with open('a.txt','w') as c:
	c.write('aaa')
```
而自己的写法则是 `open('a.txt','w').write('aaa')` [1]

初看等价于 `tmp = open('a.txt','w');tmp.write('aaa')` [2]

然后注意到上面 tmp没有关闭！！！

c语言里面大家学过， 文件一旦使用完毕，应用关闭文件函数把文件关闭，以避免文件的数据丢失等错误。

python是否也是这样？

我们来测试一下。

<script type="text/javascript" src="https://asciinema.org/a/13870.js" id="asciicast-13870" async></script>

命令解释：
- `lsof +D . ` 显示当前目录被打开的文件
- ip 是我的shell的一个别名，指向ipython notebook
- byobu是shell终端复用工具，没有它就没法用asciinema同时录制多个shell

从上面的演示可以看出 代码[2]文件没有被关闭，必须调用close，而代码[1]文件被关闭了。

也就是说代码[1]和代码[2]并不等价。

要解释其中的原因， 我们来了解下python的垃圾回收机制。

Python内存回收的基石是引用计数，“当一个对象的引用被创建或复制时，对象的引用技术加1；当一个对象的引用被销毁时，对象的引用技术减1”，如果对象的引用计数减少为0，将对象的所占用的内存释放。
当一个文件对象被销毁的时候会自动关闭对应的文件（类似c++的析构函数）

代码[2]运行完成之后tmp还是一个局部变量，所以不会被释放。而代码[1]运行完成之后则没有增加局部变量，
`open('a.txt','w')`产生的临时变量在调用 `.write('aaa')`方法之后就不再可能被调用，对象的引用为0，然后就被python回收。文件也就关闭了。

事实上，如果代码[2]在一个函数中，当退出这个函数的时候，tmp变量不复存在，文件也会被关闭。
如果在函数之外运行，那么脚本运行的时候也会关闭文件。

所以在python中，大部分情况都没有必要手动关闭文件，除非打开文件的代码在一个循环中。

值得注意的是，并非所有拥有垃圾回收的语言都会像python一样自动关闭文件。
如golang中就不会， golang拥有defer语言,所有需要关闭的资源都通过defer声明。
然后就有了一下这样坑爹的代码。
```golang
resp, err := http.Get("http://example.com/")
if err != nil {
	// handle error
}
defer resp.Body.Close()
body, err := ioutil.ReadAll(resp.Body)
// ...
```
resp是一个请求对象，而且resp不存在close方法。这让人误认为resp不需要关闭。但是resp.Body是一个缓冲区struct（io.ReadCloser），也必须手动关闭，即使你的代码都没使用到resp.Body。

这是标准库的例子，熟悉golang的人当然不会犯这种错误。但是假如这是一个网上下载的开源库，然后文档还不详细（这很常见），使用这个库的人不一定注意到resp.Body还需要close，然后就是内存泄漏。。。



