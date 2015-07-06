title: coffeescript 的一个坑, a +"b" compiles to a(+"b") 
description: 
category: javascript
tag: coffeescript javascript
hide:false
-------------------------

在 coffeescrip 中a +"b"会被编译成 a(+"b") 

详情见 <https://github.com/jashkenas/coffeescript/issues/1036/>

这种处理方式的理由， javascript 中 `+"b"` => `NaN` , `"1000"` => `1000`

在coffeescrip中为了和javascript保持相同的行为，所以 `a +"b"`中 ， `+"b"`作为一个整体来处理

`a +"b"` 就变成了 `a（+"b")`

如果写成 `a + "b"`的话就不存在上述问题，所以在coffeescrip中建议在任何二元运算符两边都加上空格(其它语言也应该这样)

另一种处理办法 `"#{a}b"`

