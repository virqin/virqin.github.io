title: 让Applet随BREW启动而启动
description:
category: Brew
tag: Brew
-------------------------

1、用MIF Editor编辑Applet的MIF文件。在Applets页面的“Notification, Flags, Settings...”页面中，添加一个Notification：
```
Type：System
Notify：AEECLSID_SHELL
Mask：NMASK_SHELL_INIT
```
2、在Applet的HandleEvent(amms* pMe, AEEEvent eCode, uint16 wParam, uint32 dwParam)函数中添加处理NOTIFY的代码：
```c
case EVT_NOTIFY:
   {
    AEENotify *pNotify = (AEENotify*)dwParam;
    if(pNotify != NULL)
    {
     if(pNotify->cls == AEECLSID_SHELL
      && pNotify->dwMask == NMASK_SHELL_INIT)
     {
       ISHELL_StartApplet(pMe->a.m_pIShell, YOUR_APP_CLSD);
     }
```
     
