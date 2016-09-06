title: 第一次使用邮件列表
description:
category: life
tag: life
-------------------------

前些日子在分析[sre2](https://code.google.com/p/sre2/)的源代码时，试图用go tools里面的[callgraph](https://github.com/golang/tools/tree/master/cmd/callgraph)生成函数调用图。发现生成的.dot文件被读入graphviz的时候报`Warning: <stdin>: syntax error in line 2 near '('`，看了下生成的.dot文件是下面这样格式的，明显后面多了一个引号。


```

➜  ~  callgraph -format graphviz golang.org/x/tools/cmd/callgraph | head
digraph callgraph {
  "(*golang.org/x/tools/go/types.Scope).Insert" -> "(*golang.org/x/tools/go/types.object).setParent""
  "(*golang.org/x/tools/go/types.Scope).Insert" -> "(*golang.org/x/tools/go/types.object).Name""
  "(*golang.org/x/tools/go/types.Scope).Insert" -> "(*golang.org/x/tools/go/types.object).Parent""
  "golang.org/x/tools/go/types.def" -> "(*golang.org/x/tools/go/types.Scope).Insert""
  "golang.org/x/tools/go/types.def" -> "(*golang.org/x/tools/go/types.object).Name""
  "golang.org/x/tools/go/types.def" -> "(*golang.org/x/tools/go/types.object).Type""
  "strings.Index" -> "strings.IndexByte""
  "strings.Index" -> "strings.hashStr""
  "golang.org/x/tools/go/types.def" -> "strings.Index""
  ➜  ~  callgraph -format graphviz golang.org/x/tools/cmd/callgraph | dot
  Warning: <stdin>: syntax error in line 2 near '('
```


反复阅读命令的--help没发现自己的命令有错，遂git clone下源代码查找，确定是代码的问题。

想要提个issues,仔细阅读了[Contributing to Go](https://github.com/golang/go/blob/master/CONTRIBUTING.md)之后发现最好是去golang-nuts mailing list提。
仔细看了下《提问的智慧》之后小心翼翼的在golang-nuts提了一个问题。

次日收到某google大牛的回复`Thanks for the bug report; fix pending.`，不久之后代码就被修正了[diff](https://github.com/golang/tools/commit/159ae4d1631985184b8557168a1a5a6172c62a27#diff-c8117c3f96025909bfc777c22fff6a92)
虽然不是第一次给开源项目提issues，但给像golang这样的项目还是第一次，邮件列表的使用也是第一次，还是很激动的。

在阅读sre2的代码时候也发现一处逻辑错误(虽然没太看懂...)，不过google code我找了半天也没找到怎么提issus，眼看这项目似乎已经失去了维护，还是不了了之了。。
