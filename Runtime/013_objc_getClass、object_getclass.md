# objc_getClass、object_getclass

```objective-c
Class objc_getClass(const chat *aClassName)
```

传入字符串类名，返回对应的类对象

```objective-c
Class object_getClass(id obj)
```

传入的obj可能是instance对象，class对象、meta-class对象，返回值：

+ 如果是instance对象，返回class对象
+ 如果是class对象，返回meta-class对象
+ 如果是meta-class对象，返回NSObject（基类）的meta-class对象



具体可参考：

+ [OC对象的本质（下）](https://www.istones.top/2018/08/26/2.OC%E5%AF%B9%E8%B1%A1%E7%9A%84%E6%9C%AC%E8%B4%A8/)



**objc_getClass、object_getClass方法区别？**

```objective-c
Class objc_getClass(const char *aClassName)
{
    if (!aClassName) return Nil;
    // NO unconnected, YES class handler
    return look_up_class(aClassName, NO, YES);
}

Class object_getClass(id obj)
{
    // 如果传入instance对象，返回class对象
    // 如果传入class对象，返回meta-class对象
    // 如果传入meta-class对象，返回NSObject的meta-class对象
    if (obj) return obj->getIsa();
    else return Nil;
}
```

从源码进行分析，objc_getClass传入参数为字符串，根据字符串去Map中取出类对象并返回。 object_getClass传入参数为 id，并且返回值是通过 getIsa 获得，说明返回 isa 指向的类型（即：传入instance对象，返回类对象；传入class对象，返回meta-class对象；传入meta-class对象，返回NSObject的meta-class对象）。









