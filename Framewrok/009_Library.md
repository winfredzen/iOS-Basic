# Library

内容参考自：

+ [iOS Deep Understanding of Libraries and Frameworks](https://www.youtube.com/watch?v=lGG0UPdvc54&t=695s)

**什么是Library？**

![035](./images/035.png)



**Library的类型**

![036](./images/036.png)





**创建C Library**

![037](./images/037.png)



**创建C++ Library**

![038](./images/038.png)



**创建Objective-C 库**

![039](./images/039.png)



## 创建静态库

1.File-> New -> Project -> Static Library

![040](./images/040.png)





2.选择Mach-o Type为Static Library

![041](./images/041.png)



3.Skip install -> NO

为啥这样做？想要的distribute in release mode，使用archive。如果设置为yes的话，在archive时Library不会被copy

![042](./images/042.png)



4.将`BUILD_LIBRARY_FOR_DISTRIBUTION`设置为yes。（针对Swift开发的库）

其作用：

> 确保您的库是为分发而构建的。 对于 Swift，这可以支持库的演变和模块接口文件的生成。





5`.Product->Archive`

选择Distribute Content

![043](./images/043.png)

![044](./images/044.png)







