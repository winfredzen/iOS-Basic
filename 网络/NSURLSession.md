# NSURLSession


`NSURLSession`的使用步骤：使用`NSURLSession`对象创建Task，然后执行Task

Task的类型如下，NSURLSessionTask为抽象类，使用时使用其子类：

![Task类型](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/1.png)

## 基本使用

**获取`NSURLSession`的方式**

1.获取共享的Session

```
+ (NSURLSession *)sharedSession;
```

2.自定义Session

```
+ (NSURLSession *)sessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(id <NSURLSessionDelegate>)delegate delegateQueue:(NSOperationQueue *)queue;
```

### GET请求

1.使用`dataTaskWithRequest:completionHandler:`

```
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
```

+ request-表示请求对象
+ completionHandler-表示请求回调

	+ data-响应体信息
	+ response-响应头信息
	+ error-错误信息


如下的例子：

```
  NSURL *url = [NSURL URLWithString:@"xxxxx"];
  NSURLRequest *request =[NSURLRequest requestWithURL:url];
  
  //创建会话对象
  NSURLSession *session = [NSURLSession sharedSession];
  
  //创建Task
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
  
    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
  }];
  
  //执行Task
  [dataTask resume];
```

输出当前的线程信息为：`<NSThread: 0x600000460800>{number = 3, name = (null)}`，表示其调用是在子线程中

2.使用`dataTaskWithURL:completionHandler:`

该方法不用创建`NSURLRequest`对象

```
  NSURL *url = [NSURL URLWithString:@"xxxxx"];

  //创建会话对象
  NSURLSession *session = [NSURLSession sharedSession];
  
  //创建Task
  NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
  }];
  
  //执行Task
  [dataTask resume];
```


### POST请求

```
  NSURL *url = [NSURL URLWithString:@"xxxxx"];
  
  //创建请求对象
  NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
  
  //设置请求方法为post
  request.HTTPMethod = @"POST";
  
  //设置请求体
  request.HTTPBody = [@"username=xxxx&pwd=xxxx" dataUsingEncoding:NSUTF8StringEncoding];
  
  //创建会话对象
  NSURLSession *session = [NSURLSession sharedSession];
  
  //创建Task
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
  }];
  
  //执行Task
  [dataTask resume];
```



















