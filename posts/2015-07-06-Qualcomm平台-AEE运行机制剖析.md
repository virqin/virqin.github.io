##Qualcomm平台 AEE运行机制的深入剖析

标签: aee android   android aee
转自: http://blog.csdn.net/comicray/article/details/4403470

----

前言
  本文利图对Qualcomm平台的AEE（Application Execute Entironment）做一个深入的研
究与分析，便于大家了解整个Brew平台的App 调度机制和资源管理机制，从而方便大家以
后在Brew平台上面的的应用程序开发工作。

###一．  名词解释
*  Brew：无线二进制运行环境
*  Applet：AEE执行环境里面的一个调度，或者说执行单元
*  Task：操作系统层面的一个任务
*  Rex：操作系统
*  AEE：应用程序执行环境

###二．  关键技术分析
a)  AEE在操作系统层面，没有独立的Task，它只不过是依附于ui_task的一个函数调
用罢了；

b)  一个Applet是否活动，不是指它是否可以占有CPU，而是指它在AEE层面，是否
是 Active（可以拥有LCD和键盘）；

c)  AEE 也好，Applet 也罢，它们只不过是一套静态代码而已，因此，谁调用它，它
就将在谁的上下文（Task层面）运行，因此从这种角度来讲，Brew 平台的Applet
没有Active和DeActive而言，每一个Applet都可以得到执行权（只不过不一定是
在 AEE 的上下文运行）；

d)  Rex不是分时操作系统，所以，一个Task假如不主动释放CPU的话，其它任务将
无法得到执行权；

e)  AEE 内部有一些全局组件，这些组件可以通过 IShell 组件来隐式操作，目前最为
重要的，大家只需要知道AEE内部维护了一个消息队列就Ok了；

f)  消息和回调从本质上是一回事，发送一个消息给一个 Applet 和调用 Applet 里的一
个回调函数，两者在本质上是一回事；

###三．  AEE任务调度机制分析
在 ui_task的适当时候，它将调用AEE_Init()将 AEE运行环境初始化起来，到此为
UnRegistered止，整个AEE 运行环境就可以使用了，AEE的相关接口调用也就可以正常工作了。在
AEE 的所有接口里面，有一个最为重要的函数：AEE_Dispatch（），即 AEE 的任务调
度函数。调用此函数，将引起AEE内部进行任务调度。下面是AEE任务调度的一个简
单描述。

  每次需要进行AEE任务调度时，AEE只需要从它的消息队列的队头，取出最前面
的消息， 根据消息体里面指定的消息接收者，（ClassID）， 调用 IShell_SendEvent(pApp,w,d)
将消息发送给相应的Applet。而IShell_SendEvent的工作机理其实很简单，就是直接调
用相应Applet的HandleEvent()函数，从而在逻辑层面上使得一个Applet得到了“执行
权” 。但在操作系统层面，这只不过是一个函数调用而已。

  上述的调度机制就是 AEE 的核心算法，很简单，却不好理解。接下来，再讲一下
IShell_PostEvent()的作用。这个函数很简单，就是直接把消息放到 AEE 的消息队列的
末尾，然后，在下一次 AEE 的调度的时候，由 AEE 取出这个消息并调用接收 Applet
的事件处理函数。

  好了， 调度算法算是搞明白了， 现在有一个问题？什么时候才会触发AEE_Dispatch()
呢？假如这个调度函数得不到执行，就谈不上调度了。问题的关键在于ui_task()会在需
要时（由一个AEE_APP_SIG 信号量控制）调用AEE_Dispatch，而AEE_APP_SIG 的置
位，是由底层操作系统的一个定时器定时发送的，从这种角度来看，AEE 会定时进行
上层的任务调度。

###四．  实例分析
当前一个Applet正在前台“运行” ，即显示权和键盘控制权由当前Applet获得，现
在来了一个短消息，那么，WmsApp 能不能得到这个消息，并获得执行权？假如可以
获得，它应该如何操作？

按上面的说法，一个Applet只不过是一堆静态代码而已，对于每一个Applet而言，
只要它的某一个处理函数被调用了，就相当于它“活动”了。从这种角度出发，假如
wmsApp 在运行的时候先向底层服务组件注册了一个接收短消息的回调（回调：在
Applet实现，由底层调用），那么，当底层服务任务（这里是wms_task）发现有一个短
消息来了之后，它就会调用 WmsApp 的回调函数，这样的话，不管 AL 层当前活动的
Applet是谁，WmsApp都可以得到执行权（只不过，它是在ws_task的上下文执行的，
而不是在AEE的上下文） ，即都可以“接收”到短消息。

好了，第一个问题搞定了。任何Applet，不管它是否活动，都可以得到系统事件。
UnRegistered现在的关键是，假如它得到了系统事件并运行，那么 Applet 该如何动作？比如上述的
wmsapp，它得到一个短消息事件之后，是直接弹出短消息界面呢？还是怎么办？

请大家记住一点：只有当前活动的Applet可以拥有屏幕和键盘的控制权！！那假如
真是这样的话，Wmsapp虽然可以接收到短消息，但由于它不是当前活动的Applet，所
以它无法控制屏幕。为了获得LCD的控制权，它必须由“非激活”状态，变成“激活”
状态。因此，一般的非激活 Applet 在收到系统消息之后，假如它希望弹出一些提示界
面，则必须先将自己激活（做法很简单，就是直接调用 IShell_StartApplet），这样，它
才可以操作LCD 并显示相应的提示信息了。

###五．  AEE的键盘派发和LCD刷新机制
AEE的键盘派发机制很简单，每一次当AEE 需要派发键盘消息（键盘消息将由底
层 task 传送给AEE，至于如何传送的，大家暂且可以不用关心）时，AEE 的做法很简
单，就是从它的Applet栈中取出最上层的Applet（也就是活动Applet），并将键盘消息
发送给它。也就是说，AEE 将键盘消息每次只发送给当前活动的 Applet，其它 Applet
无法接收到键盘消息。

关于 LCD 刷新机制同样简单，每次 Applet 调用 IDisplay_Update 的时候，AEE 都
会做出判断，假如执行这个操作的 Applet 不是活动 Applet，那么，AEE 将不会允许它
去“真正”更新LCD，从而达到了只有当前活动Applet才能操作LCD的设计目标。

[结论]
    所有的Applet，不管活动与否，都可以收到系统消息并处理，但只有活动Applet
可以拥有键盘和LCD。

###六．  Applet的各种状态剖析
在逻辑概念上，一个Applet存在如下几种状态：

a)  Active（Run）；

b)  Suspend：挂起状态；

c)  Background：后台状态；

上述的所有状态，都只是逻辑概念上的，活动状态与其它两种状态的唯一区别就在
于可以获得键盘和 LCD 的控制，除此之外，只要一个Applet不是Close状态，那么，
他们都可以获得各种系统消息并得到处理权。

至于Suspend和Background的区别，其实也很简单。处于Suspend状态的Applet，
假如当前活动Applet关闭的话， 那么下一个Suspend的 Applet将自动成为Active状态。
UnRegistered即 Suspend状态的Applet仍在AEE的自动调度范围内。而Background的Applet，则不
会自动变成Active，除非我们人为激活它。说白了，在 AEE 内部，这两种类型的Applet
肯定是放在两个不同的队列里面。另外，由于 Background  Applet 具有不自动激活的
特性，所以，在很多时候，一些Service用这种状态的Applet来实现最好不过。

Applet的各种状态之间是如何进行状态切换的呢？ActiveàSuspend是由AEE自动
完成的， 即每次启动一个新的Applet， 那么当前Applet就会变成挂起状态并收到Suspend
消息。一旦当前活动 Applet 退出了，那么它的下一个 Applet 就会由 Suspend 状态变为
Active 状态，并收到 Resume 消息。ActiveàBackground 的状态切换有点特殊，要使一
个 Applet进入后台状态， 必须调用IShell_CloseApplet去关闭Applet， 这个时候， Applet
会收到On_Stop消息，假如它在这个消息里返回True，那么，这个Applet就真正Close
了。关键在于对On_Stop消息的处理，每一个希望进入Background状态的Applet必须
在这个消息里面做如下处理，简单的示例代码如下：

```
  case EVT_APP_STOP:
        {
            boolean *pb = (boolean *)dwParam;
            if(pb)
            {
                *pb = FALSE;    /* Set the app to background app */
                pMe->bSuspended = TRUE;
            }
            break;
        }
```

    这样之后，一个 Applet 就进入了后台状态，假如它想切换回 Active 状态，很简单，
直接调用IShell_StarApplet就ok。 请大家注意IShell_StartApplet （）， 此代码将视不同的Applet
发送不同的消息。对于Background  Applet，它将发送一个On_Start的消息给当前Applet，
对于挂起的Applet，它将发送一个Resume的消息给当前Applet。

###七．  后记
上述文档，是对当前 AEE 运行机理的一个简单分析，由于 AEE 的相关代码，
Qualcomm没有公开源码，所以无法得到一个更为准确的分析结果。不过，大家如能将
上述的AEE 运行机理好好体会，相信对于将来开发Brew应用一定会大有帮助。
最后谢谢大家耐心把本文看完，谢谢。
