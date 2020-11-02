# extern "C"

参考：

+ [C++项目中的extern "C" {}](https://www.cnblogs.com/skynet/archive/2010/07/10/1774964.html)
+ [What is the effect of extern “C” in C++?](https://stackoverflow.com/questions/1041866/what-is-the-effect-of-extern-c-in-c)



在用C++的项目源码中，经常会不可避免的会看到下面的代码：

```c++
#ifdef __cplusplus
extern "C" {
#endif
 
/*...*/
 
#ifdef __cplusplus
}
#endif
```



>  回到extern关键字，extern是C/C++语言中表明**函数**和**全局变量**作用范围（可见性）的关键字，该关键字告诉编译器，其声明的函数和变量可以在本模块或其它模块中使用。通常，在模块的头文件中对本模块提供给其它模块引用的函数和全局变量以关键字extern声明。例如，如果模块B欲引用该模块A中定义的全局变量和函数时只需包含模块A的头文件即可。这样，模块B中调用模块A中的函数时，在编译阶段，模块B虽然找不到该函数，但是并不会报错；它会在连接阶段中从模块A编译生成的目标代码中找到此函数。

> 与extern对应的关键字是 static，被它修饰的全局变量和函数只能在本模块中使用。因此，一个函数或变量只可能被本模块使用时，其不可能被extern “C”修饰。



> 通过上面两节的分析，我们知道extern "C"的真实目的是实现**类C和C++的混合编程**。在C++源文件中的语句前面加上extern "C"，表明它按照类C的编译和连接规约来编译和连接，而不是C++的编译的连接规约。这样在类C的代码中就可以调用C++的函数or变量等。（注：我在这里所说的类C，代表的是跟C语言的编译和连接方式一致的所有语言）

