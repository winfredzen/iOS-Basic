# 基础知识

## 内存模型

Objective-C是C的"超集"。C语言内存模型(memory modal)，参考[C语言内存模型（内存组织方式）](http://c.biancheng.net/cpp/html/2857.html)

| 内存分区 | 说明 | 
| ------------- |-------------|
| 程序代码区(code area) | 存放函数体的二进制代码 |
| 静态数据区(data area) | 也称全局数据区，包含的数据类型比较多，如全局变量、静态变量、一般常量、字符串常量。其中：1.全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域， 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。2.常量数据（一般常量、字符串常量）存放在另一个区域。**注意：静态数据区的内存在程序结束后由操作系统释放。** | 
| 堆区(heap area) | 一般由程序员分配和释放，若程序员不释放，程序运行结束时由操作系统回收。`malloc()`、`calloc()`、`free()` 等函数操作的就是这块内存，这也是本章要讲解的重点。 |
| 栈区(stack area) | 由系统自动分配释放，存放函数的参数值、局部变量的值等。其操作方式类似于数据结构中的栈。 **注意：这里所说的堆区与数据结构中的堆不是一个概念，堆区的分配方式倒是类似于链表。** |
| 命令行参数区 | 存放命令行参数和环境变量的值，如通过`main()`函数传递的值。 |

![C语言内存模型示意图](https://github.com/winfredzen/iOS-Basic/blob/master/Objective-C/images/2.png)

也可以参考[内存 5 大区](https://hacpai.com/article/1496287519844?m=0)


## 属性

属性用于封装对象中的数据。`@property`声明属性的语法，其意思是说：编译器会自动编写访问这些属性所需的方法，此过程叫做“自动合成”。这个过程是由编译器在编译期完成的，所以编辑器里看不到这些“自动合成”的源代码。除了生成方法代码之外，编译器还要自动向类中添加适当类型的实例变量，并且在属性名前加下划线，依次作为实例变量的名字。

属性中attribute默认值，参考[Default property attributes with ARC](https://useyourloaf.com/blog/default-property-attributes-with-arc/)

```
@property NSArray *name;
@property (strong, atomic, readwrite) NSArray *name;
```

`@synthesize`指令告诉编译器在编译期间产生`getter/setter`方法，也可用来指定实例变量的名字

`@dynamic`阻止编译器自动合成存取方法，它告诉编译器：不要自动创建实现属性所用的实例变量，也不要为其创建存取方法。而且，在编译访问属性的代码时，即使编译器发现没有定义存取方法，也不会报错，它相信这些方法能在运行期找到。


**atomic与nonatomic的区别？**

具备atomic特性的获取方法会通过锁定机制来确保其操作的原子性。也就是说，如果两个线程读写同一个属性，那么不论何时，总能看到有效的属性值。如果不加锁的话(使用nonatomic)，当其中一个线程正在改写某属性值时，另一个线程可能会把尚未修改好的属性读取出来，此时线程读到的属性值可能是不对的。


在iOS中一般都是使用nonatomic，原因是：在iOS中使用同步锁的开销较大，会带来性能问题。一般情况下，并不要求属性必须是原子性的，因为这样并不能保证线程安全，若要实现线程安全操作，还需采用更为深层的锁定机制才行

**内存管理**

为什么要使用内存管理attribute？

在使用setter方法设置一个新值时，是要retain这个值呢？还是只将其赋值给底层实例变量呢？编译器在合成存取方法时，要根据此attribute来决定所生成的代码

+ **assign**-只针对scalar Type，例如CGFloat或者NSInteger，进行简单的赋值操作
+ **strong**-表示一种拥有关系(owning relationship)，为这种属性设置新值时，设置方法会先保留新值，并释放旧值，然后再将新值设置上去
+ **weak**-表示一种非拥有关系(nonowning relationship)，为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。同assign类似，但是该属性所指的对象遭到摧毁时，属性值会清空(nil out)
+ **unsafe_unretained**-和assign相同，但它适用于对象类型(object type)，该attribute表达一种非拥有关系("不保留"，unretained)，当目标对象遭到摧毁时，属性值不会自动清空(unsafe)，与weak有区别
+ **copy**-与strong类似。设置方法并不保留新值，而是将其拷贝。当属性类型为`NSString *`时，经常使用此特质来保护其封装性。因为传递给设置方法的新值有肯可能指向一个`NSMutableString`类的实例


**属性声明的属性与所有权修饰符的对应关系**

| 属性声明的属性 | 所有权限修饰符 |
| -------- | --------- |
| assign | `__unsafe_unretained`修饰符 |
| copy | `__strong`修饰符 |
| retain | `__strong`修饰符 |
| strong | `__strong`修饰符 |
| unsafe_unretained | `__unsafe_unretained`修饰符 |
| weak | `__weak`修饰符 |


## 内存管理

内存管理的思考方式(内容来自《Objective-C高级编程》)：

+ 自己生成的对象，自己持有
+ 非自己生成的对象，自己也能持有
+ 不再需要自己持有的对象时释放
+ 非自己持有的对象无法释放

**对象操作与Objective-C方法的对应**

| 对象操作 | Objective-C方法 |
| -------- | --------- |
| 生成并持有对象 | alloc/new/copy/mutableCopy等方法 |
| 持有对象 | retain方法 |
| 释放对象 | release方法 |
| 废弃对象 | dealloc方法 |


+ 在Objective-C的对象中存有引用计数这一整数值
+ 调用alloc或是retain方法后，引用计数值加1
+ 调用release后，引用计数值减1
+ 引用计数值为0时，调用dealloc方法废弃对象

### ARC

#### 所有权限修饰符

Objective-C为了处理对象，可将变量类型定义为：

+ id类型-隐藏对象类型的类名部分，相当于C语言中的`void *`
+ 对象类型-例如`NSObject *`


**4种所有权限修饰符**

1.`__strong`修饰符

`__strong`修饰符是id类型和对象类型默认的所有权限修饰符

```
 id __strong obj = [[NSObject alloc] init];
```
等同于

```
 id obj = [[NSObject alloc] init];
```

`__strong`表示对象的**强引用**。持有强引用的变量在超出其作用域时被废弃，随着强引用的实效，引用的对象会被释放

2.`__weak`修饰符

`__weak`主要用来解决**循环引用**的问题。循环引用容易发生内存泄漏。所谓内存泄漏就是应当废弃的对象在超出其生存周期后继续存在

两个对象相互强引用或者对象持有自身时，会发生循环引用

`__weak`表示弱引用，弱引用不能持有对象实例

如下：

```
id __weak obj = [[NSObject alloc] init];
```
编译器会警告：

```
Assigning retained object to weak variable; object will be released after assignment
```

表示生成的对象会立即被释放。使用如下的方式后，就不会有警告了：

```
    id __strong obj = [[NSObject alloc] init];
    id __weak obj1 = obj;
```

`__weak`优点是，在持有某对象的弱引用时，若该对象被废弃，则此弱引用将自动失效并且被赋值为nil，如下：

```
    id __weak obj1 = nil;
    {
        id __strong obj0 = [[NSObject alloc] init];
        obj1 = obj0;
        NSLog(@"1: %@", obj1);
    }
    NSLog(@"2: %@", obj1);
```

控制台输出结果为：

```
1: <NSObject: 0x6040000129f0>
2: (null)
```


3.`__unsafe_unretained`修饰符

`__unsafe_unretained`修饰符是不安全的所有权修饰符。`__unsafe_unretained`修饰符的变量不属于编译器的内存管理对象。

```
id __unsafe_unretained obj = [[NSObject alloc] init];
```

同`__weak`一样，编译器也会警告：

```
Assigning retained object to unsafe_unretained variable; object will be released after assignment
```

因为自己生成并持有的对象不能继续为自己所有，所以生成的对象会立即被释放


`__unsafe_unretained`与`__weak`类似，但注意如下的差别：

```
    id __unsafe_unretained obj1 = nil;
    {
        id __strong obj0 = [[NSObject alloc] init];
        obj1 = obj0;
        NSLog(@"1: %@", obj1);
    }
    NSLog(@"2: %@", obj1);
```

在Xcode9中，输出`1: <NSObject: 0x604000008a90>`后，会crash

在使用`__unsafe_unretained`修饰符时，赋值给附有`__strong`修饰符的变量时有必要确保被赋值的对象确实存在

4.`__autoreleasing`修饰符

```
    @autoreleasepool {
        id __autoreleasing obj = [[NSObject alloc] init];
    }
```

对象赋值给附有`__autoreleasing`修饰符的变量等价于在ARC无效时调用对象的`autorelease`方法，即对象被注册到autoreleasepool中

**一些规则**

1.对象类型不能作为C语言结构体的成员

```
struct Data {
    NSMutableArray *array;
};
```

如上，编译器报错`ARC forbids Objective-C objects in struct`

要把对象变量加入到结构体成员中时，可强制转换为`void *`或是附加`__unsafe_unretained`修饰符

```
struct Data {
    NSMutableArray __unsafe_unretained *array;
};
```

2.显示转换id和void *

如下：

```
    id obj = [[NSObject alloc] init];
    
    void *p = obj;
```

编译器提示的错误为:

```
Implicit conversion of Objective-C pointer type 'id' to C pointer type 'void *' requires a bridged cast
```

id型或对象型变量赋值给void *或者逆向赋值时都需要进行特定的转换

```
    id obj = [[NSObject alloc] init];
    
    void *p = (__bridge void *)obj;
    
    id o = (__bridge id)p;
```

`__bridge_retained`转换可使要转换赋值的变量也持有赋值的对象

`__bridge_transfer`转换使被转换的变量所持有的对象在该变量被赋值给转换目标变量后随之释放








