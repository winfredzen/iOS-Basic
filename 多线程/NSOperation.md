# NSOperation

`NSOperation`配合`NSOperationQueue`也能实现多线程

`NSOperation`是个抽象类，并不具备封装操作的能力，必须使用它的子类：

+ `NSInvocationOperation`
+ `NSBlockOperation`
+ 自定义子类继承`NSOperation`，实现内部相应的方法

## NSOperation基本使用

### NSInvocationOperation

调用`initWithTarget: selector: object:`方法创建`NSInvocationOperation`对象

调用`start`方法开始执行操作，`start`方法并不会开启新的线程，只是在当前的线程中执行

只有将`NSOperation`放到一个`NSOperationQueue`中，才会异步执行操作

```
     NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
     NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
     NSInvocationOperation *op3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download3) object:nil];

     [op1 start];
     [op2 start];
     [op3 start];
     
     ......
     
     -(void)download1
	{
	    NSLog(@"%s----%@",__func__,[NSThread currentThread]);
	}

	......
     
```

输出结果为：

```
-[ViewController download1]----<NSThread: 0x60000007ec80>{number = 1, name = main}
-[ViewController download2]----<NSThread: 0x60000007ec80>{number = 1, name = main}
-[ViewController download3]----<NSThread: 0x60000007ec80>{number = 1, name = main}
```

可见都是在当前的主线程中运行

### NSBlockOperation

通过`blockOperationWithBlock:`方法创建`NSBlockOperation`对象

通过`addExecutionBlock:`方法添加更多的操作

**需要注意的是**：如果一个操作中的任务数量大于1,则会开子线程并发执行任务。任务可能在子线程中执行，也可能在主线程中执行

如下的例子：

```

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op1 1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op2 1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"op3 1----%@",[NSThread currentThread]);
    }];
    

    [op3 addExecutionBlock:^{
        NSLog(@"op3 2---%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"op3 3---%@",[NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"op3 4---%@",[NSThread currentThread]);
    }];

    [op1 start];
    [op2 start];
    [op3 start];
```
输出如下：

```
op1 1----<NSThread: 0x60000007f840>{number = 1, name = main}
op2 1----<NSThread: 0x60000007f840>{number = 1, name = main}
op3 1----<NSThread: 0x60000007f840>{number = 1, name = main}
op3 3---<NSThread: 0x60000007f840>{number = 1, name = main}
op3 4---<NSThread: 0x60000007f840>{number = 1, name = main}
op3 2---<NSThread: 0x60000026bf00>{number = 3, name = (null)}
```

### 添加到NSOperationQueue中

`NSOperation`调用`start`方法，默认是同步执行的，如果将`NSOperation`添加到`NSOperationQueue`（操作队列）中，系统会自动异步执行`NSOperation`中的操作

`NSOperationQueue`中的队列：

1.主队列

```
[NSOperationQueue mainQueue];
```

2.非主队列

```
[[NSOperationQueue alloc] init];
```

`[[NSOperationQueue alloc] init];`创建的队列，可以是串行的，也可以是并发的。默认是并发的

如下的简单的例子：

```
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download2) object:nil];
    NSInvocationOperation *op3 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(download3) object:nil];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //添加操作到队列
    [queue addOperation:op1];   //内部已经调用了start方法
    [queue addOperation:op2];
    [queue addOperation:op3];
    
```

输出结果如下，表示其在子线程中执行：

```
-[ViewController download2]----<NSThread: 0x600000264780>{number = 4, name = (null)}
-[ViewController download1]----<NSThread: 0x60800007d380>{number = 3, name = (null)}
-[ViewController download3]----<NSThread: 0x60800007d3c0>{number = 5, name = (null)}
```

**NSOperationQueue相关方法**

1.添加操作到`NSOperationQueue`中

```
- (void)addOperation:(NSOperation *)op;
- (void)addOperationWithBlock:(void (^)(void))block;
```

2.最大并发数的相关方法

```
- (NSInteger)maxConcurrentOperationCount;
- (void)setMaxConcurrentOperationCount:(NSInteger)cnt;
```

`maxConcurrentOperationCount`设置为1，表示串行执行。设置为0，则不会执行。设置为-1，表示最大值。

注意的是：串行执行任务并不意味着只开一条线程，如下的例子，开了2条线程

```
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    queue.maxConcurrentOperationCount = 1;

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"4----%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"5----%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"6----%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op7 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"7----%@",[NSThread currentThread]);
    }];

    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    [queue addOperation:op6];
    [queue addOperation:op7];
```

输出结果如下：

```
1----<NSThread: 0x6080000771c0>{number = 3, name = (null)}
2----<NSThread: 0x60800006da40>{number = 4, name = (null)}
3----<NSThread: 0x60800006da40>{number = 4, name = (null)}
4----<NSThread: 0x60800006da40>{number = 4, name = (null)}
5----<NSThread: 0x60800006da40>{number = 4, name = (null)}
6----<NSThread: 0x60800006da40>{number = 4, name = (null)}
7----<NSThread: 0x60800006da40>{number = 4, name = (null)}
```



3.取消队列的所有操作

```
- (void)cancelAllOperations;
```

也可以调用`NSOperation`的`- (void)cancel`方法取消单个操作

4.暂停和恢复队列

```
- (void)setSuspended:(BOOL)b; // YES代表暂停队列，NO代表恢复队列
- (BOOL)isSuspended;
```


## 自定义NSOperation

自定义`NSOperation`，重写`main`方法，注意点：

+ 自己创建自动释放池（因为如果是异步操作，无法访问主线程的自动释放池）
+ 通过isCancelled方法检查操作是否被取消

自定义`NSOperation`的好处：

1. 封装操作
2. 代码复用

如下自定义一个简单的`SimpleOperation`，如下：

```
//SimpleOperation.h

@interface SimpleOperation : NSOperation

@end

//SimpleOperation.m
@implementation SimpleOperation

- (void)main
{
    NSLog(@"SimpleOperation---%@",[NSThread currentThread]);
}

@end

```
使用时将其添加到NSOperationQueue中，如下：

```
        SimpleOperation *op1 = [[SimpleOperation alloc]init];
        SimpleOperation *op2 = [[SimpleOperation alloc]init];

        NSOperationQueue *queue = [[NSOperationQueue alloc]init];

        [queue addOperation:op1];
        [queue addOperation:op2];
```

输出如下：

```
SimpleOperation---<NSThread: 0x600000071380>{number = 3, name = (null)}
SimpleOperation---<NSThread: 0x60800006da00>{number = 4, name = (null)}
```

## 调用顺序

如下的`XMGOperation`继承自`NSBlockOperation`，重写了`start`和`main`方法

```
//XMGOperation.h
@interface XMGOperation : NSBlockOperation

@end
//XMGOperation.m

@implementation XMGOperation

-(void)start
{
    NSLog(@"start---start");
    [super start];
    NSLog(@"start----end");
}

-(void)main
{
    NSLog(@"main---start");
    [super main];
    NSLog(@"main---end");
}
@end

```

如下创建一个操作，添加到操作队列中：

```
    //1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2.封装操作
    XMGOperation *op1 = [XMGOperation blockOperationWithBlock:^{
        NSLog(@"1---%@",[NSThread currentThread]);
    }];
    
    //3.添加
    [queue addOperation:op1];   //[op1 start]---->main
```

其输出如下：

```
start---start
main---start
1---<NSThread: 0x608000264e00>{number = 5, name = (null)}
main---end
start----end
```

**可见，是`start`方法调用了`main`方法，且任务是在`main`方法中执行的**




## NSOperation线程间通信

1.下载图片，显示图片

```
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"xxxx"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        NSLog(@"下载---%@",[NSThread currentThread]);
        
        //主线程更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
        
    }];
    
    //添加操作到队列
    [queue addOperation:download];
```

2.下载多个图片，然后合成图片

```
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    __block UIImage *image1;
    __block UIImage *image2;
    
    //下载图片1
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"xxx"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //下载图片2
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSURL *url = [NSURL URLWithString:@"xxx];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:imageData];
        
        NSLog(@"download---%@",[NSThread currentThread]);
        
    }];
    
    //封装合并图片的操作
    NSBlockOperation *combie = [NSBlockOperation blockOperationWithBlock:^{

        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
        [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //主线程更新
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
        
    }];
    
    //设置依赖关系
    [combie addDependency:download1];
    [combie addDependency:download2];
    
    //添加操作到队列中
    [queue addOperation:download2];
    [queue addOperation:download1];
    [queue addOperation:combie];
```






