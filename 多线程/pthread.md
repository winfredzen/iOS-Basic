# pthread

[维基百科](https://zh.wikipedia.org/wiki/POSIX%E7%BA%BF%E7%A8%8B)介绍：

>POSIX线程（英语：POSIX Threads，常被缩写为Pthreads）是POSIX的线程标准，定义了创建和操纵线程的一套API。
>
>实现POSIX 线程标准的库常被称作Pthreads，一般用于Unix-like POSIX 系统，如Linux、 Solaris。但是Microsoft Windows上的实现也存在，例如直接使用Windows API实现的第三方库pthreads-w32；而利用Windows的SFU/SUA子系统，则可以使用微软提供的一部分原生POSIX API。
>
>Pthreads定义了一套C语言的类型、函数与常量，它以pthread.h头文件和一个线程库实现。

**pthread的简单使用**

使用pthread，需要导入`#import <pthread.h> `。

使用`pthread_create`创建并执行一个线程，原型如下：

```
int pthread_create(pthread_t _Nullable * _Nonnull __restrict,
		const pthread_attr_t * _Nullable __restrict,
		void * _Nullable (* _Nonnull)(void * _Nullable),
		void * _Nullable __restrict);
```

+ 第一个参数：线程对象 传递地址
+ 第二个参数：线程的属性
+ 第三个参数:指向函数的指针
+ 第四个参数:函数需要接受的参数


如下的例子，参考[How to use iOS Multithreading](http://www.supinfo.com/articles/single/463--how-to-use-ios-multithreading)：

```
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    pthread_t thread;
    //Create a thread and exectute
    pthread_create(&thread, NULL, start, NULL);
}

void *start(void *data) {
    NSLog(@"%@", [NSThread currentThread]);

    return NULL;
}
```

输出结果为：

```
<NSThread: 0x7fbb48d33690>{number = 2, name = (null)}
```

