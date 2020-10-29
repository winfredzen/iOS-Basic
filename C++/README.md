# C++

参考：

+ [C++的初步知识，C++基础知识](http://c.biancheng.net/cpp/biancheng/cpp/rumen_1/)
+ [C++标准库和std命名空间](http://c.biancheng.net/cpp/biancheng/view/2972.html)



## 命令空间

避免出现变量或函数命名冲突，语法格式：

```c++
namespace name{
    //variables, functions, classes
}
```

+ `namespace ` - 为关键字
+ `name`  - 命名空间的名字

如：

```c++
namespace Li{  //小李的变量定义
    FILE fp = NULL;
}
namespace Han{  //小韩的变量定义
    FILE fp = NULL
}
```

使用变量、函数时要指明它们所在的命名空间

```c++
Li :: fp = fopen("one.txt", "r");  //使用小李定义的变量 fp
Han :: fp = fopen("two.txt", "rb+");  //使用小韩定义的变量 fp
```

`::`被称为**域解析操作符**，在C++中用来指明要使用的命名空间



还可以使用`using`来指明使用的命名空间

```c++
using Li :: fp;
fp = fopen("one.txt", "r");  //使用小李定义的变量 fp
Han :: fp = fopen("two.txt", "rb+");  //使用小韩定义的变量 fp
```

+ `using Li :: fp;` - `using` 声明以后的程序中如果出现了未指明命名空间的 `fp`，就使用 `Li::fp`；但是若要使用小韩定义的 `fp`，仍然需要 `Han::fp` 



`using` 声明不仅可以针对命名空间中的一个变量，也可以用于声明整个命名空间

```c++
using namespace Li;
fp = fopen("one.txt", "r");  //使用小李定义的变量 fp
Han :: fp = fopen("two.txt", "rb+");  //使用小韩定义的变量 fp
```



一个命名空间完整示例代码：

```c++
#include <stdio.h>
//将类定义在命名空间中
namespace Diy{
    class Student{
    public:
        char *name;
        int age;
        float score;
  
    public:
        void say(){
            printf("%s的年龄是 %d，成绩是 %f\n", name, age, score);
        }
    };
}
int main(){
    Diy::Student stu1;
    stu1.name = "小明";
    stu1.age = 15;
    stu1.score = 92.5f;
    stu1.say();
    return 0;
}
```































