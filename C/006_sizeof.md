# sizeof

`sizeof`操作符以字节形式给出了其操作数的存储大小

1.操作数是数据类型

```c
#include <stdio.h>

int main(int argc, char const *argv[])
{
	printf("sizeof(char): %lu\n", sizeof(char));
	printf("sizeof(int): %lu\n",sizeof(int));
	printf("sizeof(long): %lu\n", sizeof(long));
    printf("sizeof(float): %lu\n",sizeof(float));
    printf("sizeof(double): %lu\n", sizeof(double));
    
	return 0;
}
```

其结果为(64位系统下)：

```c
sizeof(char): 1
sizeof(int): 4
sizeof(long): 8
sizeof(float): 4
sizeof(double): 8
```

2.操作数是表达式

```c
#include <stdio.h>

int main(int argc, char const *argv[])
{
	int a = 0;
    double d = 10.21;
    printf("%lu\n", sizeof(a+d));
    return 0;
}
```

输出为`8`

对于指针，参考[Is the sizeof(some pointer) always equal to four?](https://stackoverflow.com/questions/399003/is-the-sizeofsome-pointer-always-equal-to-four):

>pointers will be size 2 on a 16-bit system (if you can find one), 4 on a 32-bit system, and 8 on a 64-bit system
>16位系统size为2，32位系统为4，64系统为8

如下，在64位系统下，输出为`sizeof(p):8`：
```c
#include<stdio.h>
int main()
{ 
	char str[]="ABC";
    char *p=str;

    printf("sizeof(p): %lu\n",sizeof(p));
    return 0;
} 
```


对于结构体，编译器在考虑对齐问题时，在结构中插入空位以控制各成员对象的地址对齐，详细的例子介绍可参考[C中sizeof用法](http://www.cnblogs.com/ttltry-air/archive/2012/08/30/2663366.html)

如下的例子：

```c
#include <stdio.h>

struct 
{
	char b;
	double x;
} astruct;

int main(int argc, char const *argv[])
{
    printf("%lu\n", sizeof(astruct));
    return 0;
}
```

输出结果为：`16`

## sizeof的使用

参考：

+ [sizeof operator in C](https://www.geeksforgeeks.org/sizeof-operator-c/)
+ [sizeof Operator (C)](https://msdn.microsoft.com/en-us/library/0w557fh7.aspx)

1.计算数组中元素的数量

```c
#include<stdio.h>
int main()
{
   int arr[] = {1, 2, 3, 4, 7, 98, 0, 12, 35, 99, 14};
   printf("Number of elements :%d", sizeof(arr)/sizeof(arr[0]));
   return 0;
} 
```

输出为：

```c
Number of elements :11
```

其它形式：

```c
static char *strings[] ={  
          "this is string one",  
          "this is string two",  
          "this is string three",  
         };  
const int string_no = ( sizeof strings ) / ( sizeof strings[0] );   
```


2.动态分配内存块

例如，如果我们要分配足够容纳10个整数的内存，并且我们不知道该特定机器中的`sizeof(int)`, 就可使使用`sizeof`来分配

```c
int *ptr = malloc(10*sizeof(int));
```

3.不要对数组参数使用`sizeof`

参考[Do not use sizeof for array parameters](https://www.geeksforgeeks.org/using-sizof-operator-with-array-paratmeters/)

如下的程序：

```c
#include<stdio.h>
void fun(int arr[])  
{
  int i;   
 
  /* sizeof should not be used here to get number 
    of elements in array*/
  int arr_size = sizeof(arr)/sizeof(arr[0]); /* incorrect use of siseof*/
  for (i = 0; i < arr_size; i++) 
  {  
    arr[i] = i;  /*executed only once */
  }
}
 
int main()
{
  int i;  
  int arr[4] = {0, 0 ,0, 0};
  fun(arr);
   
  /* use of sizeof is fine here*/
  for(i = 0; i < sizeof(arr)/sizeof(arr[0]); i++)
    printf(" %d " ,arr[i]);
 
  getchar();  
  return 0;
}   
```

`fun()`函数有一个`arr[]`参数，并试图计算`arr[]`中元素的个数，使用`sizeof`

但在C中，数组参数会被当做pointers指针来对待，所以表达式`sizeof(arr)/sizeof(arr[0])`，会变成`sizeof(int *)/sizeof(int)`，导致计算结果不正确

其实编译的时候也会提示警告：

```c
string.c:8:24: warning: sizeof on array function parameter will return size of
      'int *' instead of 'int []' [-Wsizeof-array-argument]
  int arr_size = sizeof(arr)/sizeof(arr[0]); /* incorrect use of siseof*/
```

正确的做法是在函数中传递数组大小，如下：

```c
#include<stdio.h>
void fun(int arr[], size_t arr_size)  
{
  int i;   
  for (i = 0; i < arr_size; i++) 
  {  
    arr[i] = i;  
  }
}
 
int main()
{
  int i;  
  int arr[4] = {0, 0 ,0, 0};
  fun(arr, 4);
   
  for(i = 0; i < sizeof(arr)/sizeof(arr[0]); i++)
    printf(" %d ", arr[i]);
 
  getchar();  
  return 0;
}  
```