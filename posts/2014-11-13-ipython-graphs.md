title: ipython notebook 绘制流程图
description: 
category: python
tag: ipython python
-------------------
####之前在阅读《Redis 设计与实现》发现这本书中的图片是用代码生成的。
以下是作者原文
见<http://blog.huangz.me/diary/2013/tools-for-writing-redisbook.html/>

---------------
<div class="section" id="graphviz">
<h2>图片生成：Graphviz<a class="headerlink" href="#graphviz" title="Permalink to this headline">¶</a></h2>
<p>《设计与实现》的图片都是由 <a class="reference external" href="http://graphviz.org/">Graphviz</a> 生成的。</p>
<img alt="../../_images/graphviz-logo.png" src="http://blog.huangz.me/_images/graphviz-logo.png">
<p>Graphviz 是一个开源的图片可视化工具，
它和其他图片工具的最大区别是，
Graphviz 的图片是用文本来表示的 ——
也即是说，
使用者先用 dot 语言将图片以文本的方式“写”出来，
然后再用 Graphviz 将 dot 文件转换成图片：</p>
<img alt="../../_images/graphviz-show.png" src="http://blog.huangz.me/_images/graphviz-show.png">
<p>作为例子，
上面的这个示意图就是用以下源码写出来的：</p>
<div class="highlight-python"><div class="highlight"><pre>digraph show {

    // node

    source [label = "source.dot", shape = plaintext];

    graphviz [label = "Graphviz", shape = box];

    image [label = "image.png/jpg/pdf/...", shape = plaintext];

    // edge

    source -&gt; graphviz [label = "传入"];

    graphviz -&gt; image [label = "生成"];
}
</pre></div>
</div>
<p>Graphviz 生成的图片不是“画”出来的，
而是像编程一样写出来的，
这种做法有两个明显的好处：</p>
<ol class="arabic simple">
<li>因为“画图”是由 Graphviz 负责的，所以你只需要负责定义“这个图片应该是什么样子”，至于“怎么画这个图”，就交给 Graphviz 来思考就可以了。</li>
<li>因为图片的源码是文本，所以源码中的内容可以重用，并且这些源码文件可以用 git 来管理。</li>
</ol>
<p>多得这两个好处，
在编写《设计与实现》时，
图片的绘制和管理方面的任务都可以轻松地完成。</p>
<p>不过，
从另一方面来说，
Graphviz 提供了大量的功能和参数，
要真正使用好也是要费一些功夫的。
目前《设计与实现》的图片还是非常简单的，
也不够美观，
很多复杂的图片也只能用 ASCII 文字来表示，
希望在将来的新版本中，
能用 Graphviz 创建出更多更好看的图片。</p>
</div>

-------------------------------------
作者的图片是在markfile中调用Graphviz生成的。
作为pythoner，自然想到在ipython notebook中实现。
一番搜索，果然发现几个ipython notebook extension[<a href="http://nbviewer.ipython.org/gist/
deeplook/4770302" target="_blank">源地址</a>]，如下
这些工具都支持导出图片为pdf，jpg，svg。这些都是ipython notebook支持显示的格式。所以实现这样的扩展也很容易，有兴趣可以看 install_ext 后面的源代码




<iframe src="/posts/ipython-graphs.html" width="100%" height="2000" id="frameid">
    
</iframe>
