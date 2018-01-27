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

## 文件下载

### 小文件下载

使用以下的下载方式会导致内存的暴增

1.使用`NSURLConnection`的`sendAsynchronousRequest`方法，异步下载。

如下下载一个视频文件，写入到沙盒

```
    NSURL *url = [NSURL URLWithString:@"xxxxx.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //数据到沙盒中
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"video.mp4"];
        [data writeToFile:fullPath atomically:YES];
    }];
```

使用上面的方法，不能监控下载的进度


2.使用代理，可以计算下载的进度

```
-(void)download
{
    NSURL *url = [NSURL URLWithString:@"xxxx.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //文件大小
    self.totalSize = response.expectedContentLength;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   //拼接数据
    [self.fileData appendData:data];
    //计算下载进度
    NSLog(@"%f",1.0 * self.fileData.length /self.totalSize);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //写入到沙盒
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"xxxx.mp4"];
    [self.fileData writeToFile:fullPath atomically:YES];
}
```

### 大文件下载

为防止下载时内存的暴增

1. 在接收到响应时创建文件
2. 在接收到数据时，在文件后面拼接数据，并计算下载进度

如下：

```
-(void)download
{
    NSURL *url = [NSURL URLWithString:@"http:xxxxx/xxxx.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    self.totalSize = response.expectedContentLength;
	 //路径
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"xxxx.mp4"];
    
    //创建一个空的文件
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //创建文件句柄(指针)
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //移动文件句柄到数据的末尾
    [self.handle seekToEndOfFile];
    //写数据
    [self.handle writeData:data];
    //获得进度
    self.currentSize += data.length;
    //进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 *  self.currentSize/self.totalSize);
    self.progressView.progress = 1.0 *  self.currentSize/self.totalSize;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //关闭文件句柄
    [self.handle closeFile];
    self.handle = nil;
}
```

#### 大文件断点下载

断点下载设置请求头中的`Range`信息

>Range: bytes=5001-10000
>
>对于只需获取部分资源的范围请求，包含首部字段Range即可告知服务器资源的指定范围。上面的实例表示请求获取从5001字节到第10000字节的资源
>
>接收到附带Range首部的字段请求的服务器，会在处理请求之后返回状态码206 Partial Content的响应。无法处理该范围请求时，则会返回状态码200 OK的响应及全部资源
>


```
-(void)download
{
    NSURL *url = [NSURL URLWithString:@"http:xxxxx.jpg"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求头信息,告诉服务器值请求一部分数据range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    //发送请求
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.connect = connect;
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

	//之前已经下载过，直接返回
    if (self.currentSize >0) {
        return;
    }
    
    //注意位置
    self.totalSize = response.expectedContentLength;
    
    //写数据到沙盒
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"xxx.jpg"];
    
    NSLog(@"%@",self.fullPath);
    
    //创建一个空的文件
    [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    
    //创建文件句柄(指针)
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //移动文件句柄到数据的末尾
    [self.handle seekToEndOfFile];
    //写数据
    [self.handle writeData:data];
    //获得进度
    self.currentSize += data.length;
    //进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 *  self.currentSize/self.totalSize);
    self.progressView.progress = 1.0 *  self.currentSize/self.totalSize;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //关闭文件句柄
    [self.handle closeFile];
    self.handle = nil;
}
```

### 输出流

输出流`NSOutputStream`

>A stream that provides write-only stream functionality.
>
>NSOutputStream is “toll-free bridged” with its Core Foundation counterpart(副本), CFWriteStreamRef. For more information on toll-free bridging, see Toll-Free Bridging.
>

一般使用的初始化方法：

```
- (nullable instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend
```

+ url-文件的路径
+ shouldAppend-为YES表示追加，否则即为NO

注意:如果该输出流指向的地址没有文件,那么会自动创建一个空的文件


如下使用输出流来写入下载的文件：

```
-(void)download
{   
    NSURL *url = [NSURL URLWithString:@"xxxxx"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    //发送请求
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.connect = connect;
}

#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    if (self.currentSize >0) {
        return;
    }
    
    self.totalSize = response.expectedContentLength;
    
    self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"xxx.jpg"];
    
    NSOutputStream *stream = [[NSOutputStream alloc]initToFileAtPath:self.fullPath append:YES];
    
    //打开输出流
    [stream open];
    self.stream = stream;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //写数据
    [self.stream write:data.bytes maxLength:data.length];
    
    //获得进度
    self.currentSize += data.length;
 
    //进度=已经下载/文件的总大小
    NSLog(@"%f",1.0 *  self.currentSize/self.totalSize);
    self.progressView.progress = 1.0 *  self.currentSize/self.totalSize;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    //关闭流
    [self.stream close];
    self.stream = nil;
}
```

## 文件上传

文件上传步骤：

1.设置请求头`Content-Type`

```
Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
```

2.按照固定的格式拼接请求体数据

```
 ------WebKitFormBoundaryjv0UfA04ED44AhWx
 Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
 Content-Type: image/png
 
 
 ------WebKitFormBoundaryjv0UfA04ED44AhWx
 Content-Disposition: form-data; name="username"
 
 123456
 ------WebKitFormBoundaryjv0UfA04ED44AhWx--
```

+ 第一部分表示上传的图片(文件参数)
+ 第一部分表示表单的参数(非文件参数)
+ 最后一部分`------WebKitFormBoundaryjv0UfA04ED44AhWx--`表示结尾标示


拼接请求体的数据格式如下：

```
 拼接请求体
 分隔符:----WebKitFormBoundaryjv0UfA04ED44AhWx
 1)文件参数
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
 2)非文件参数
     --分隔符
     Content-Disposition: form-data; name="username"
     空行
     123456
 3)结尾标识
    --分隔符--
```

如下的文件上传的例子：

```
#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]


-(void)upload
{
    //1.确定请求路径
    NSURL *url = [NSURL URLWithString:@"xxxx"];
    
    //2.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.设置请求方法
    request.HTTPMethod = @"POST";
    
    //4.设置请求头信息
    //Content-Type:multipart/form-data; boundary=----WebKitFormBoundaryjv0UfA04ED44AhWx
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //5.拼接请求体数据
    NSMutableData *fileData = [NSMutableData data];
    //5.1 文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png(MIMEType:大类型/小类型)
     空行
     文件参数
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //name:file 服务器规定的参数
    //filename:Snip20160225_341.png 文件保存到服务器上面的名称
    //Content-Type:文件的类型
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Snip20160225_341.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    
    UIImage *image = [UIImage imageNamed:@"Snip20160225_341"];
    //UIImage --->NSData
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:KNewLine];
    
    //5.2 非文件参数
    /*
     --分隔符
     Content-Disposition: form-data; name="username"
     空行
     123456
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    
    //5.3 结尾标识
    /*
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //6.设置请求体
    request.HTTPBody = fileData;
    
    //7.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       
        //8.解析数据
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

```















