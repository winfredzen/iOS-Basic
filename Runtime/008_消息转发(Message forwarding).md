# 消息转发(Message forwarding)

**1.为什么Objective-C的消息转发要设计三个阶段？**

参考：

+ [为什么Objective-C的消息转发要设计三个阶段？](https://juejin.im/post/5d1d69e8e51d45109b01b1f3)

![023](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/023.png)

+ 第一阶段：动态方法解析（Dynamic Method Resolution）

+ 第二阶段：替换消息接收者（快速转发)

+ 第三阶段：完全消息转发机制

> 第一阶段意义在于动态添加方法实现，第二阶段直接把消息转发给其他对象，第三阶段是对第二阶段的扩充，可以实现多次转发，转发给多个对象等。这也许就是设计这三个阶段的意义。
>
> 另外，一个对象通过消息转发来响应一条消息，“看起来像”继承了在其他类定义的方法实现，这就变相实现了多继承。
>
> 当然，也许多继承本身就不应该存在。你应该遵循“单一职责”、“高内聚，低耦合”等面向对象设计原则，合理设计类的功能。



**2.原理与应用**

+ [iOS开发·runtime原理与实践: 消息转发篇(Message Forwarding) (消息机制，方法未实现+API不兼容奔溃，模拟多继承)](https://juejin.im/post/5ae96e8c6fb9a07ac85a3860)
+ [Objective-C 消息发送与转发机制原理](http://yulingtianxia.com/blog/2016/06/15/Objective-C-Message-Sending-and-Forwarding/)

+ [神经病院 Objective-C Runtime 住院第二天——消息发送与转发](https://halfrost.com/objc_runtime_objc_msgsend/)