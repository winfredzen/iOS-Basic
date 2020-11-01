# extern的用法

参考：

+ [《C语言-C++学习指南》18.1-多文件项目,extern的用法](https://www.bilibili.com/video/BV1Fs411k7v7?from=search&seid=13205554016949889533)



为了允许把程序拆分成多个逻辑部分来编写，C++语言支持分离式编译（separate compilation）机制，该机制允许将程序分隔为若干个文件，每个文件可被独立编译

为支持分离式编译，C++语言将声明与定义区分开来

+ 声明（declaration）- 使名字为程序所知，一个文件如果想使用别处定义的名字则必须包含对那个名字的声明
  + 变量声明规定了变量的类型和名字
+ 定义（definition）- 负责创建与名字关联的实体
  + 定义还申请存储空间，也可能会为变量赋值一个初始值

如果想要声明一个变量而非定义它，就在变量名前添加关键字`extern`，而不是显式地初始化变量

```c++
extern int i;//声明i而非定义i
int j;//声明并定义i
```

`extern`语句如果包含初始值就不再是声明，而变成定义了：

```c++
extern double pi = 3.14; //定义
```



在函数体内部，如果试图初始化一个有`extern`关键字标记的变量，将引发错误

![001](https://github.com/winfredzen/iOS-Basic/blob/master/C%2B%2B/images/001.png)



**变量能且只能被定义一次，但是可以被多次声明**



## 使用extern

extern可以声明外部函数，也可以声明外部全局变量

作用：告诉编译器，在某个cpp文件中，存在这么一个函数/全局变量（so，也可以在本cpp内定义）

> 符号（symbol）：函数名和全局变量名，称为符号

### 声明外部函数

在`A.cpp`中使用`B.cpp`中的函数，需要`extern`声明

`other.cpp`

```c++
#include <stdio.h>

double get_area(double r) {
    return 3.14 * r * r;
}
```

`main.cpp`

```c++
#include <iostream>

extern double get_area(double r);

int main(int argc, const char * argv[]) {
    // insert code here...
    double area = get_area(2);
    std::cout << area << std::endl;
    return 0;
}
```

控制台输出结果为：`12.56`

带参数的函数：

```c++
extern int sum(int a, int b);
```

声明函数的时候`extern`可以省略



### 声明外部全局变量

在`A.cpp`中使用`B.cpp`中的全局变量，需要`extern`声明

`other.cpp`

```c++
#include <stdio.h>

int a = 10;
int b = 20;
float numbers[5] = {1.0, 2.0};

double get_area(double r) {
    return 3.14 * r * r;
}
```

`main.cpp`

```c++
#include <iostream>

extern int a;
extern int b;
extern float numbers[5];

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "a = " << a << std::endl;
    std::cout << "b = " << b << std::endl;
    std::cout << "numbers = " << numbers << std::endl;
    return 0;
}
```



## 重定义

多个cpp中，不能定义相同的名字的符号

+ 不能定义相同名称的全局变量
+ 不能定义相同的函数（参数名和参数列表均相同）

![002](https://github.com/winfredzen/iOS-Basic/blob/master/C%2B%2B/images/002.png)

![003](https://github.com/winfredzen/iOS-Basic/blob/master/C%2B%2B/images/003.png)

![004](https://github.com/winfredzen/iOS-Basic/blob/master/C%2B%2B/images/004.png)



## 无定义

extern声明了一个函数，并调用了它，但是在链接的过程中，没有在任何一个cpp中发现它的定义

![005](https://github.com/winfredzen/iOS-Basic/blob/master/C%2B%2B/images/005.png)

















