# class_copyIvarList与class_copyPropertyList的区别

内容来自：

+ [class_copyIvarList与class_copyPropertyList的区别](https://www.jianshu.com/p/a5001d873b3a)



.h文件

![016](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/016.webp)

.m文件

![017](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/017.webp)



代码

![018](https://github.com/winfredzen/iOS-Basic/blob/master/Runtime/images/018.webp)

总结:

1.`class_copyIvarList`:能够获取.h和.m中的所有属性以及大括号中声明的变量，获取的属性名称有下划线(大括号中的除外)。

2.`class_copyPropertyList`:只能获取由property声明的属性，包括.m中的，获取的属性名称不带下划线。

3.OC中没有真正的私有属性。

