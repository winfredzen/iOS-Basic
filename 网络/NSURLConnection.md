# NSURLConnection

`NSURLConnection`负责发送请求，建立客户端和服务器的连接，发送数据给服务器，并接收服务器的响应


`NSURLConnection`使用步骤：

1. 创建`NSURL`
2. 创建`NSURLRequest`，设置请求头和请求体
3. `NSURLConnection`发送请求

`NSURLConnection`发送请求的方式

1.同步请求

```
+ (nullable NSData *)sendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse * _Nullable * _Nullable)response error:(NSError **)error
```

该方法是阻塞的，三个参数：

+ request - 请求对象
+ response - 响应头信息
+ error - 错误信息

其返回值为响应体信息，表示获取的数据

使用方式如下，为GET请求：

```
NSURL *url = [NSURL URLWithString:@"xxxx"];
NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
NSHTTPURLResponse *response = nil;
NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
```

2.异步请求

```
+ (void)sendAsynchronousRequest:(NSURLRequest*) request
                          queue:(NSOperationQueue*) queue
              completionHandler:(void (^)(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError)) handler 
```

+ queue表示的是`completionHandler`调用的线程

使用方式如下：

```
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {

        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);

    }];
```

## 使用代理

NSURLConnection相关协议：

1. `NSURLConnectionDelegate`
2. `NSURLConnectionDataDelegate`继承自`NSURLConnectionDelegate`
3. `NSURLConnectionDownloadDelegate`继承自`NSURLConnectionDelegate`

**NSURLConnectionDelegate**主要做自定义认证处理和请求失败的处理，如：

```
//认证
connection:willSendRequestForAuthenticationChallenge:
......
//请求失败
connection:didFailWithError:
```


**NSURLConnectionDataDelegate**提供的是connection接收数据相关的方法，如：

```
//接收到服务器响应
connection:​did​Receive​Response:​
//接收到服务器返回数据的时候调用,调用多次
connection:​did​Receive​Data:​​
//请求成功加载完成
connection​Did​Finish​Loading:​
//发送数据的进度
connection:​did​Send​Body​Data:​total​Bytes​Written:​total​Bytes​Expected​To​Write:
//重定向处理
connection:​will​Send​Request:​redirect​Response:​
connection:needNewBodyStream:
//当系统准备缓存该响应数据的时候告诉代理
connection:willCacheResponse:
```

**NSURLConnectionDownloadDelegate**该协议中的方法提供关于URL资源下载的进度信息，并且在下载结束时提供可以访问下载的文件的文件URL

```
//下载的时候会一直调用这个方法, 利用这几个参数刷新UI的进度条
connection:​did​Write​Data:​total​Bytes​Written:​expected​Total​Bytes:​ 
//当恢复下载的时候告诉代理
connection​Did​Resume​Downloading:​total​Bytes​Written:​expected​Total​Bytes:​ 
//下载完成的时候告诉代理目标文件的URL
connection​Did​Finish​Downloading:​destination​URL:​
```

**使用例子**

简单的使用方式如下：

```
NSURL *url = [NSURL URLWithString:@"xxxx"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
//设置代理，发送请求
[NSURLConnection connectionWithRequest:request delegate:self];
```

有可以通过`[[NSURLConnection alloc]initWithRequest:request delegate:self];`来设置代理

还有一个方法是：

```
- (nullable instancetype)initWithRequest:(NSURLRequest *)request delegate:(nullable id)delegate startImmediately:(BOOL)startImmediately
```

+ startImmediately为YES表示马上发送请求，为NO，则需要调用`start`方法来开始起请求

```
NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:NO];
[connection start];
```

`cancel`方法来取消请求

剩下的就是实现代理，一般遵循`NSURLConnectionDataDelegate`协议即可，实现如下的方法：

```
//1.当接收到服务器响应的时候调用
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%s",__func__);
}

//2.接收到服务器返回数据的时候调用,调用多次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%s",__func__);
    //拼接数据
    [self.resultData appendData:data];
}

//3.当请求失败的时候调用
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
}

//4.请求结束的时候调用
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s",__func__);
    NSLog(@"%@",[[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding]);
}
```

## 发送POST请求

发送POST请求，需使用`NSMutableURLRequest`对象，修改请求头信息。常用方法有：

```
//设置请求超时等待时间（超过这个时间就算超时，请求失败）
- (void)setTimeoutInterval:(NSTimeInterval)seconds;

//设置请求方法（比如GET和POST）
- (void)setHTTPMethod:(NSString *)method;

//设置请求体
- (void)setHTTPBody:(NSData *)data;

//设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

```

如下的例子：

```
    NSURL *url = [NSURL URLWithString:@"xxxx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //POST请求
    request.HTTPMethod = @"POST";
    //请求超时时间
    request.timeoutInterval = 15;
    
    //设置请求头User-Agent
    [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    
    //设置请求体信息，为NSData类型
    request.HTTPBody = [@"username=xxx&pwd=xxx" dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
    }];
```

## 转码操作

GET请求，如果请求参数中有中文，需要转码。如`http://xxx.xxx.xxx.xxx:xxxx?username=用户名&pwd=xxx`字符串，转为`NSURL`对象时，`NSURL`对象为nil，没有创建成功。需要使用`stringByAddingPercentEscapesUsingEncoding:`方法来转码

```
urlStr =  [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
```


POST请求并不需要转码













