# Category

Category分类的主要作用是为已存在的类添加方法，使用分类的好处：

+ 将类代码分成多个易于管理的小块。这样做减少了单个文件的体积，把不同的功能组织到不同的category里

Category有局限性，不能动态添加成员变量，只能动态添加方法。详细介绍参考[iOS 关于Category](https://www.jianshu.com/p/535d1574cb86)

尽管从技术上说，分类中可以声明属性，但尽量避免这样做。这样做不会生成`setter/getter`方法, 也不会生成实现以及私有的成员变量（编译时会报警告）

如下，在分类中声明一个属性

```
@interface NSObject (MyAddition)

@property(nonatomic, copy) NSString *name;

@end
```

在编译时，会提示警告：

```
Property 'name' requires method 'name' to be defined - use @dynamic or provide a method implementation in this category

Property 'name' requires method 'setName:' to be defined - use @dynamic or provide a method implementation in this category
```

意思是：分类无法合成与`name`属性相关的实例变量，所以开发者需要在分类中为该属性实现存取方法。可以把存取方法声明为`@dynamic`，即运行期提供。

关联对象可以解决在分类中不能合成实例变量的问题：

```
static const char *key = "name";

- (NSString *)name
{
    return objc_getAssociatedObject(self, key);
}

- (void)setName:(NSString *)name
{

    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

```

**category特点**

参考[【iOS】Category VS Extension 原理详解](http://www.cocoachina.com/ios/20170502/19163.html)

>+ category只能给某个已有的类扩充方法，不能扩充成员变量。
+ category中也可以添加属性，只不过@property只会生成setter和getter的声明，不会生成setter和getter的实现以及成员变量。
+ 如果category中的方法和类中原有方法同名，运行时会优先调用category中的方法。也就是，category中的方法会覆盖掉类中原有的方法。所以开发中尽量保证不要让分类中的方法和原有类中的方法名相同。避免出现这种情况的解决方案是给分类的方法名统一添加前缀。比如category_。
+ 如果多个category中存在同名的方法，运行时到底调用哪个方法由编译器决定，最后一个参与编译的方法会被调用

**category原理**

参考博文：

+ [深入理解Objective-C：Category](https://tech.meituan.com/DiveIntoCategory.html)
+ [Objective-C Category 的实现原理](http://blog.leichunfeng.com/blog/2015/05/18/objective-c-category-implementation-principle/)





## 扩展

Extension是Category的一个特例。扩展与分类相比只少了分类的名称，所以称之为“匿名分类”。

Extension可以添加实例变量、方法和属性，使用它的好处(参考Effective Objective-C 2.0)：

+ 向类中添加实例变量
+ 如果某个属性在主interface中声明为readonly，而类的内部又要用设置方法修改此属性，那么就在扩展中，将其扩展为readwrite
+ 把私有方法的原型声明在扩展里面
+ 若想使类所遵循的协议不为人知，则可在扩展中声明


**category和extension的区别**

参考[【iOS】Category VS Extension 原理详解](http://www.cocoachina.com/ios/20170502/19163.html)


>+ extension在编译期决议，它就是类的一部分，但是category则完全不一样，它是在运行期决议的。extension在编译期和头文件里的`@interface`以及实现文件里的`@implement`一起形成一个完整的类，它、extension伴随类的产生而产生，亦随之一起消亡。
+ extension一般用来隐藏类的私有信息，你必须有一个类的源码才能为一个类添加extension，所以你无法为系统的类比如`NSString`添加extension，除非创建子类再添加extension。而category不需要有类的源码，我们可以给系统提供的类添加category。
+ extension可以添加实例变量，而category不可以。
+ extension和category都可以添加属性，但是category的属性不能生成成员变量和`getter`、`setter`方法的实现。




