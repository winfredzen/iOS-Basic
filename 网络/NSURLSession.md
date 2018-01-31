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

+ configuration-配置信息，可使用`[NSURLSessionConfiguration defaultSessionConfiguration]`
+ delegate-代理
+ queue-设置代理方法在哪个线程中调用



### 代理相关

`NSURLSession`相关的代理包括：

+ [NSURLSessionDelegate](https://developer.apple.com/documentation/foundation/nsurlsessiondelegate)
+ [NSURLSessionTaskDelegate](https://developer.apple.com/documentation/foundation/nsurlsessiontaskdelegate)
+ [NSURLSessionDataDelegate](https://developer.apple.com/documentation/foundation/nsurlsessiondatadelegate?language=objc)
+ [NSURLSessionDownloadDelegate](https://developer.apple.com/documentation/foundation/nsurlsessiondownloaddelegate?language=objc)
+ [NSURLSessionStreamDelegate](https://developer.apple.com/documentation/foundation/nsurlsessionstreamdelegate)


#### NSURLSessionTaskDelegate

```
//请求结束或者是失败的时候调用
URLSession:task:didCompleteWithError:
```

#### NSURLSessionDataDelegate

```
//接收到服务器的响应
URLSession:dataTask:didReceiveResponse:completionHandler:

//接收到服务器返回的数据
URLSession:dataTask:didReceiveData:
```

`URLSession:dataTask:didReceiveResponse:completionHandler:`方法说明：

+ session-会话对象
+ dataTask-请求任务
+ response-响应头信息
+ completionHandler- 回调，是需要传给系统的

`NSURLSessionResponseDisposition`有四个类型的值：

+ NSURLSessionResponseCancel-取消请求，是默认情况
+ NSURLSessionResponseAllow-接收数据
+ NSURLSessionResponseBecomeDownload-变成下载任务
+ NSURLSessionResponseBecomeStream-变成流

使用例子如下：

```
  NSURL *url = [NSURL URLWithString:@"xxxxx"];
  
  //创建请求对象
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  //创建会话对象,设置代理
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  
  //创建Task
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
  
  //执行Task
  [dataTask resume];
  
#pragma mark ----------------------
#pragma mark NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
  NSLog(@"%s",__func__);
  //告诉系统如何处理响应信息
  completionHandler(NSURLSessionResponseAllow);
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  NSLog(@"%s",__func__);
  
  //拼接数据
  [self.fileData appendData:data];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  NSLog(@"%s",__func__);
  
  //解析数据
  NSLog(@"%@",[[NSString alloc]initWithData:self.fileData encoding:NSUTF8StringEncoding]);
}
  
```

输出调用过程如下：

```
-[ViewController URLSession:dataTask:didReceiveResponse:completionHandler:]
-[ViewController URLSession:dataTask:didReceiveData:]
-[ViewController URLSession:task:didCompleteWithError:]
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

## 文件下载

### 大文件下载

1.使用`downloadTaskWithRequest:completionHandler:`便利方法

```
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
```

此方法描述：

>download task convenience methods.  When a download successfully completes, the NSURL will point to a file that must be read or copied during the invocation of the completion routine.  The file will be removed automatically.

如下的例子：

```
  NSURL *url = [NSURL URLWithString:@"xxxxx"];

  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  NSURLSession *session = [NSURLSession sharedSession];
  
  //创建Task
  //该方法内部已经实现了边接受数据边写沙盒(tmp)的操作
  NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    NSLog(@"%@---%@",location,[NSThread currentThread]);
    
    //拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
    
    //剪切文件
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
  }];
  
  //执行Task
  [downloadTask resume];
```

使用此种方式无法监控下载的进度

2.使用代理

实现`NSURLSessionDownloadDelegate`协议的相关方法

```
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
```

方法描述：Periodically informs the delegate about the download’s progress.（周期性调用来通知下载的进度）

+ session-会话对象
+ downloadTask-下载任务
+ bytesWritten-本次写入的数据大小
+ totalBytesWritten-已下载的数据总大小
+ totalBytesExpectedToWrite-文件的总大小


```
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
```

方法描绘：Tells the delegate that the download task has resumed downloading.（当恢复下载的时候调用该方法）

+ fileOffset-this value is an integer representing the number of bytes on disk that do not need to be retrieved again（表示不需要获取的数据）
+ expectedTotalBytes-文件的总大小


```
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
```

方法描述：Tells the delegate that a download task has finished downloading.（当下载完成的时候调用）

+ location-文件的临时存储路径

如下的示例：

```
//代理下载
-(void)delegateDownload
{
    NSURL *url = [NSURL URLWithString:@"xxxxx"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //创建session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //创建Task
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request];

    [downloadTask resume];
}

#pragma mark NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //获得文件的下载进度
    NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"%s",__func__);
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"%@",location);
    
    //拼接文件全路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    //剪切文件
    [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
    NSLog(@"%@",fullPath);
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError");
}


```


### 断点下载

注意一些方法：

1.暂停下载

```
- (void)suspend;
```

注意暂停下载后是可以恢复下载的

2.取消下载

取消方法`- (void)cancel;`，在取消后是不可以恢复下载的，即调用`resume`方法来恢复下载是没有用的

此时可使用`- (void)cancelByProducingResumeData:(void (^)(NSData * _Nullable resumeData))completionHandler;`方法，来恢复下载

如下的例子，包括开始下载，暂停下载，取消下载，继续下载：

```
//开始下载
- (IBAction)startBtnClick:(id)sender
{
  NSURL *url = [NSURL URLWithString:@"xxxxx"];

  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
  self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
 
  NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];

  [downloadTask resume];
  //下载任务
  self.downloadTask = downloadTask;
}

//暂停下载
- (IBAction)suspendBtnClick:(id)sender
{
  NSLog(@"暂停");
  [self.downloadTask suspend];
}

//取消下载
- (IBAction)cancelBtnClick:(id)sender
{
  NSLog(@"取消");
  //[self.downloadTask cancel];
  
  //保存恢复下载的数据
  [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
    self.resumData = resumeData;
  }];
}

//继续下载
- (IBAction)goOnBtnClick:(id)sender
{
  NSLog(@"恢复下载");
  if(self.resumData)
  {
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumData];
  }
  
  [self.downloadTask resume];
}

#pragma mark NSURLSessionDownloadDelegate

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
  //获得文件的下载进度
  NSLog(@"%f",1.0 * totalBytesWritten/totalBytesExpectedToWrite);
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
  NSLog(@"%s",__func__);
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
  NSLog(@"%@",location);
  
  //拼接文件全路径
  NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
  
  //剪切文件
  [[NSFileManager defaultManager]moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
  NSLog(@"%@",fullPath);
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  NSLog(@"didCompleteWithError");
}

```

但上面的方法还有一个问题是，如果当前用户kill程序，当用户再次使用下载时，此时又会从头开始下载。这种方式非常不适合，我们需要的是此时可以在原来的基础上继续下载。此时使用`NSURLSessionDownloadTask`操作起来，有些麻烦，可考虑使用`NSURLSessionDataTask`

### NSURLSessionDataTask实现大文件下载

#### 普通使用方式

在接收到响应后，创建一个空的文件，使用`NSFileHandle`文件句柄，写入下载的数据

```
- (void)download {
  NSURL *url = [NSURL URLWithString:@"xxxxx"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  
  //创建会话对象,设置代理
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
  
  //创建Task
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
  
  //执行Task
  [dataTask resume];
}

#pragma mark NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
  //获得文件的总大小
  self.totalSize = response.expectedContentLength;
  
  //获得文件全路径
  self.fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
  
  //创建空的文件
  [[NSFileManager defaultManager]createFileAtPath:self.fullPath contents:nil attributes:nil];
  
  //创建文件句柄
  self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
  
  [self.handle seekToEndOfFile];
  
  completionHandler(NSURLSessionResponseAllow);
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  
  //写入数据到文件
  [self.handle writeData:data];
  
  //计算文件的下载进度
  self.currentSize += data.length;
  NSLog(@"%f",1.0 * self.currentSize / self.totalSize);
  
  self.proessView.progress = 1.0 * self.currentSize / self.totalSize;
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  NSLog(@"%@",self.fullPath);
  
  //关闭文件句柄
  [self.handle closeFile];
  self.handle = nil;
}

```

#### `NSURLSessionDataTask`离线断点下载

要实现在原来已下载的基础上，重行下载

1. 获取已保存的文件总大小的数据
2. 获得当前已经下载的数据的大小
3. 计算得到进度信息


如下的例子：

```
//保存文件的路径
-(NSString *)fullPath
{
    if (_fullPath == nil) {
        _fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:FileName];
    }
    return _fullPath;
}

//获取已下载文件的大小
-(NSInteger)getFileSize
{
    //获得指定文件路径对应文件的数据大小
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager]attributesOfItemAtPath:self.fullPath error:nil];
    NSLog(@"%@",fileInfoDict);
    NSInteger currentSize = [fileInfoDict[@"NSFileSize"] integerValue];
    
    return currentSize;
}

//创建的session
-(NSURLSession *)session
{
    if (_session == nil) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}



//创建dataTask
-(NSURLSessionDataTask *)dataTask
{
    if (_dataTask == nil) {
        NSURL *url = [NSURL URLWithString:@"xxxxx"];
        
        //创建请求对象
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //设置请求头信息,告诉服务器请求那一部分数据
        self.currentSize = [self getFileSize];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //创建Task
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}

//开始下载
- (IBAction)startBtnClick:(id)sender
{
    [self.dataTask resume];
}

//暂停下载
- (IBAction)suspendBtnClick:(id)sender
{
    NSLog(@"暂停下载");
    [self.dataTask suspend];
}

//取消下载
- (IBAction)cancelBtnClick:(id)sender
{
    NSLog(@"取消下载");
    [self.dataTask cancel];
    self.dataTask = nil;
}

//继续下载
- (IBAction)goOnBtnClick:(id)sender
{
    NSLog(@"继续下载");
    [self.dataTask resume];
}


#pragma mark NSURLSessionDataDelegate
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //获得文件的总大小
    //expectedContentLength 本次请求的数据大小
    self.totalSize = response.expectedContentLength + self.currentSize;
    
    if (self.currentSize == 0) {
        //创建空的文件
        [[NSFileManager defaultManager]createFileAtPath:self.fullPath contents:nil attributes:nil];
        
    }
    //创建文件句柄
    self.handle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    
    //移动指针
    [self.handle seekToEndOfFile];
    
    completionHandler(NSURLSessionResponseAllow);
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    //写入数据到文件
    [self.handle writeData:data];
    
    //计算文件的下载进度
    self.currentSize += data.length;
    NSLog(@"%f",1.0 * self.currentSize / self.totalSize);
    
    self.proessView.progress = 1.0 * self.currentSize / self.totalSize;
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%@",self.fullPath);
    
    //关闭文件句柄
    [self.handle closeFile];
    self.handle = nil;
}

-(void)dealloc
{
    //清理工作
    //finishTasksAndInvalidate
    [self.session invalidateAndCancel];
}


```


















