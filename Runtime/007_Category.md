# Category

参考：

+ [深入理解Objective-C：Category](https://tech.meituan.com/2015/03/03/diveintocategory.html)

+ [iOS底层原理总结 - Category的本质](https://www.jianshu.com/p/fa66c8be42a2)

**1.Category如何被加载？**

> 分类的实现原理是将category中的方法，属性，协议数据放在category_t结构体中，然后将结构体内的方法列表拷贝到类对象的方法列表中。
>
> Category可以添加属性，但是并不会自动生成成员变量及set/get方法。因为category_t结构体中并不存在成员变量。通过之前对对象的分析我们知道成员变量是存放在实例对象中的，并且编译的那一刻就已经决定好了。而分类是在运行时才去加载的。那么我们就无法再程序运行时将分类的成员变量中添加到实例对象的结构体中。因此分类中不可以添加成员变量。



**2.如何给Category添加属性？**

参考：

+ [给分类（Category）添加属性](https://www.jianshu.com/p/3cbab68fb856)



**3.Category的load方法的加载顺序？**

a.在类的+load方法调用的时候，我们可以调用category中声明的方法么？

> 可以调用，因为附加category到类的工作会先于+load方法的执行

b.这么些个+load方法，调用顺序是咋样的呢？

例子的演示可参考：

+ [iOS - 分类中同名方法的调用顺序](https://blog.csdn.net/appleLg/article/details/79931742)

> + load方法的调用是在main() 函数之前,并且不需要主动调用,就是说程序启动会把所有的文件加载
>
> + 主类和分类的都会加载调用+load方法
> + 主类与分类的加载顺序是:主类优先于分类加载,无关编译顺序
> + 分类间的加载顺序取决于编译的顺序:编译在前则先加载,编译在后则后加载
> + 规则是父类优先于子类, 子类优先于分类(父类>子类>分类)



c.主类和分类的同名方法如何调用？

> category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
>
> category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会罢休^_^，殊不知后面可能还有一样名字的方法。





## 其它

1.在学习第三方源代码时，见到有如下的用法

```objective-c
- (NSIndexPath *)zf_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}
```

参考：

+ [ObjC中_cmd的用法](https://www.jianshu.com/p/fdb1bc445266)

> _cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例。
>
> 由于`objc_getAssociatedObject` 和 `objc_setAssociatedObject` 第二个参数需要传入一个属性的键名，是 `const void *` 类型的























