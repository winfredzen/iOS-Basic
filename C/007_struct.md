# struct

主要内容来自《C Primer Plus》

**结构声明**

```c
#define MAXTITL 41 /*书名的最大长度+1*/
#define MAXAUTL 31 /*作者名的最大长度+1*/

struct book /*结构模板：标记为book*/
{
	char title[MAXTITL];
	char author[MAXAUTL];
	float value;
};
```

关键字`struct`，表示其是一个结构体，后面是一个可选的标记（单词book），表示引用该结构体的快速标记
可以这样声明使用

```c
struct book library;
```

`struct book`所起的作用就像`int`或`float`在较简单的声明中的作用一样

上面的声明可以简化，在定义之后跟变量名：

```c
struct book 
{
	char title[MAXTITL];
	char author[MAXAUTL];
	float value;
} library; /*在定义之后跟变量名*/
```

即声明结构的过程和定义结构变量的过程可以使用合并成一步

甚至还可以不使用标记，如下：

```c
struct /*无标记*/ 
{
	char title[MAXTITL];
	char author[MAXAUTL];
	float value;
} library; 
```

如果想多次使用一个结构模板，就需要使用带有标记的形式或者使用`typedef`

如下对结构体使用`typedef`：

```c
typedef struct complex {
	float real;
	float imag;
} COMPLEX;
```
就可以使用`COMPLEX`代替`struct complex`

如下的例子使用`typedef`定义的类型名：

```c
typedef struct {
	double x;
	double y;
} rect;

	rect r1 = {3.0, 6.0};
	rect r2;
	r2 = r1;

```

**结构体初始化**

与初始化数组类似，如下：

```c
	struct book library = {
		"xxxxxx",
		"xxxxxx xxxxxx",
		1.95
	};
```

**访问结构体成员**

使用点语法

```c
	struct book library = {
		"xxxxxx",
		"xxxxxx xxxxxx",
		1.95
	};
	printf("%s by %s: $%.2f\n", library.title, library.author, library.value);

	printf("Please enter the book title.\n");
	gets(library.title);
	printf("Now enter the author.\n");
	gets(library.author);
	printf("Now enter the value.\n");
	scanf("%f", &library.value);
	printf("%s by %s: $%.2f\n", library.title, library.author, library.value);
	printf("Done.\n");
```

## 结构体数组

声明结构体数组与声明其它任何类型的数组一样：

```c
struct book library[MAXBKS];
```

如下的例子：

```c
#include <stdio.h>

#define MAXTITL 40 
#define MAXAUTL 30
#define MAXBKS  100 /*最多书籍的册数*/

struct book 
{
	char title[MAXTITL];
	char author[MAXAUTL];
	float value;
};


int main(int argc, char const *argv[])
{
	struct book library[MAXBKS]; /*结构数组*/

	int count = 0;
	int index;

	printf("Please enter the book title.\n");
	printf("Press [enter] at the start of a line to stop.\n");

	while(count < MAXBKS && gets(library[count].title) != NULL && library[count].title[0] != '\0')
	{
		printf("Now enter the author.\n");
		gets(library[count].author);
		printf("Now enter the value.\n");
		scanf("%f", &library[count++].value);
		while(getchar() != '\n'){
			 continue;
		}
		if (count < MAXBKS)
		{
			printf("Enter the next title.\n");
		}

	}
	if (count > 0)
	{
		printf("Here is the list of your books: \n");
		for (index = 0; index < count; index++)
		{
			printf("%s by %s: $%.2f\n", library[index].title, library[index].author, library[index].value);
		}
	}else{
		printf("No books?Too bad.\n");
	}

	return 0;
}
```



## 结构体指针

声明方式如下：

```c
struct guy *him; // 指向结构体的指针
```

如下的例子：

```c
#include <stdio.h>

#define LEN 20

struct names {
	char first[LEN];
	char last[LEN];
};

struct guy {
	struct names handle;
	char favfood[LEN];
	char job[LEN];
	float income;
};

int main(int argc, char const *argv[])
{
	struct guy fellows[2] = {	
		{
			{"Ewen", "Villard"},
			"grilled salmon",
			"personality coach",
			58112.00
		},
		{
			{"Rodney", "Swillbelly"},
			"tripe",
			"tabloid editor",
			2344422.00
		}
	};

	struct guy *him; // 指向结构体的指针
	printf("address #1: %p #2: %p\n", &fellows[0], &fellows[1]);
	him = &fellows[0];
	printf("pointer #1: %p #2: %p\n", him, him + 1);

	printf("him->income is $%.2f: (*him).income is $%.2f\n", him->income, (*him).income);
	printf("him->favfood is %s: him->handle.last is %s\n", him->favfood, him->handle.last);

	return 0;
}

```

输出结果为：

```c
address #1: 0x7ffeef743ad0 #2: 0x7ffeef743b24
pointer #1: 0x7ffeef743ad0 #2: 0x7ffeef743b24
him->income is $58112.00: (*him).income is $58112.00
him->favfood is grilled salmon: him->handle.last is Villard
```

通过结果可见，`him`指向了`fellows[0]`，`him+1`指向了`fellows[1]`

访问成员，2种方式：

+ 使用`->`，如`him->favfood`
+ 使用`(*him).income`，注意必须用圆括号，因为`.`运算符比`*`的优先级更高

## struct与union的区别

通过如下的例子来说明：

```c
#include <stdio.h>

union unionJob
{
	char name[32];
	float salary;
	int workerNo;
} uJob;

struct structJob
{
   char name[32];
   float salary;
   int workerNo;
} sJob;

int main()
{
	printf("size of union = %d", sizeof(uJob));
   	printf("\nsize of structure = %d", sizeof(sJob));
	return 0;
}
```

输出结果为：

```c
size of union = 32
size of structure = 40
```

>结构体变量所占内存长度是各成员占的内存长度的总和。
>共同体变量所占内存长度是各最长的成员占的内存长度。

共同体每次只能存放哪个的一种！！
共同体变量中起作用的成员是尊后一次存放的成员，
在存入新的成员后原有的成员失去了作用！

如下的例子：

```c
#include <stdio.h>
union job
{
   char name[32];
   float salary;
   int workerNo;
} job1;

int main()
{
   printf("Enter name:\n");
   scanf("%s", job1.name);

   printf("Enter salary: \n");
   scanf("%f", &job1.salary);

   printf("Displaying\nName :%s\n", job1.name);
   printf("Salary: %.1f", job1.salary);

   return 0;
}
```

如下的输出结果：

```c
Enter name 
Hillary
Enter salary
1234.23
Displaying
Name: f%Bary   
Salary: 1234.2
```