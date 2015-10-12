title: 使用python将字符串转为摩斯码
description:
category: python
tag: Morse code;python
-------------------------

#python转换字符串为摩尔斯电码的方法

```
chars = ",.0123456789?abcdefghijklmnopqrstuvwxyz"
codes = """--..-- .-.-.- ----- .---- ..--- ...-- ....- ..... -.... --... ---..
      ----. ..--.. .- -... -.-. -... . ..-. --. .... .. .--- -.- .-.. --
      -. --- .--. --.- .-. ... - ..- ...- .-- -..- -.-- --.."""
keys = dict(zip(chars, codes.split()))
def char2morse(char):
  return keys.get(char.lower(), char)
print ' '.join(char2morse(c) for c in 'SOS')
```

Result:
`... --- ...`