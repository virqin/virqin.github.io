title: 使用python搭建微信公众平台遇到的问题
description:
category: python
tag: 微信公众平台;python
-------------------------

## SAE python 输出log 的方法

可直接在脚本里添加print 或用 logging 模块。如：

```
import logging

print 'hello'
logging.error('hello logging error')
```

日志内容在 运维»日志中心» HTTP 中查看，日志类型分为“访问”和“错误”两种，
其中在错误日志中能够看到自定义输出信息

