# AFNetworking

[AFNetworking][1]3.0中`NSURLConnection`相关的APIs，已完全移除。移除的类包括：

+ `AFURLConnectionOperation`
+ `AFHTTPRequestOperation`
+ `AFHTTPRequestOperationManager`

AFNetworking内部结构

+ NSURLSession
	+ `AFURLSessionManager`
	+ `AFHTTPSessionManager`
+ 序列化
	+ `<AFURLRequestSerialization>`-请求的数据格式/默认是二进制的
	+ <`AFURLResponseSerialization>`-响应的数据格式/默认是JSON格式	
+ 附加功能
	+ `AFSecurityPolicy`-安全策略
	+ `AFNetworkReachabilityManager`-网络检测



## 使用

### GET

GET请求可使用`AFHTTPSessionManager`类的如下的方法：

```
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
```

如下的实例：

```
- (void)get
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //参数
    NSDictionary *paramDict = @{
                                @"username":@"xxx",
                                @"pwd":@"xxx"
                                };
    //发送GET请求
    [manager GET:@"xxxx" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
```

`AFHTTPSessionManager`继承自`AFURLSessionManager`，`[AFHTTPSessionManager manager]`并不是创建了一个单例，只是创建了一个实例



### POST

POST请求使用如下的方法：

```
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
```

如下的示例：

```
-(void)post
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *paramDict = @{
                                @"username":@"xxx",
                                @"pwd":@"xxx"
                                };
    //发送POST请求
    [manager POST:@"xxxxx" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
```

### 下载

`AFURLSessionManager`中关于下载的有两个方法：

```
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;
                                    
                          
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;                                    
```

+ downloadProgressBlock-表示下载进度的回调
+ destination-表示目标位置的回调，它有个返回值，表示最终的文件路径
	+ targetPath-临时文件路径
	+ response-响应头信息
+ completionHandler-下载完成之后的回调
	+ filePath-最终的文件路径

如下的例子：

```
-(void)download
{
    //创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"xxxxx"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载文件
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
    }];
    
    //执行Task
    [download resume];
}
```


查看输出结果为：

1.`targetPath`为`file:///Users/xxxxx/Library/Developer/CoreSimulator/Devices/67DC202E-CD4C-4098-90FA-80C43B6BF510/data/Containers/Data/Application/3D9F8731-D320-4E86-86AA-68C7E825DDDE/tmp/CFNetworkDownload_fGIBBt.tmp`

2.`fullPath`为`/Users/xxxxx/Library/Developer/CoreSimulator/Devices/67DC202E-CD4C-4098-90FA-80C43B6BF510/data/Containers/Data/Application/3D9F8731-D320-4E86-86AA-68C7E825DDDE/Library/Caches/xxxxx.mp4`


### 上传

1.使用`uploadTaskWithRequest:`的方法：

```
- (NSURLSessionUploadTask *)uploadTaskWithRequest:(NSURLRequest *)request
                                         fromData:(nullable NSData *)bodyData
                                         progress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                                completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;
```

+ bodyData-A data object containing the HTTP body to be uploaded


使用这个方法需要创建请求体数据，如下的使用例子：

```
-(void)upload
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSURL *url = [NSURL URLWithString:@"http://xxxxx/upload"];
    
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方法
    request.HTTPMethod = @"POST";
    
    //设请求头信息
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary] forHTTPHeaderField:@"Content-Type"];
    
    //发送请求上传文件
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:[self getBodyData] progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/ uploadProgress.totalUnitCount);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        NSLog(@"%@",responseObject);
    }];
    
    //执行task
    [uploadTask resume];
}

//请求体数据
-(NSData *)getBodyData
{
    NSMutableData *fileData = [NSMutableData data];
    //文件参数
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
    [fileData appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"Sss.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:KNewLine];
    [fileData appendData:KNewLine];
    
    UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
    //UIImage --->NSData
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:KNewLine];
    
    //非文件参数
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
    
    //结尾标识
    /*
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--",Kboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return fileData;
}

```

这种方式使用起来比较麻烦，并不怎么推荐

2.Creating an Upload Task for a Multi-Part Request, with Progress

```
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
```


+ URLString-请求路径
+ parameters-字典(非文件参数)
+ block-constructingBodyWithBlock 处理要上传的文件数据
+ uploadProgress-进度回调

如下的例子：

```
-(void)upload
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //发送post请求上传文件
    [manager POST:@"http://xxxxx/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

			//拼接上传的数据
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xxxxx/Desktop/xxxx.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
}
```

也可参考[Creating an Upload Task for a Multi-Part Request, with Progress][2]例子


### 序列化

如果请求返回的是JSON数据，则不需要修改manager的`responseSerializer`。`AFHTTPSessionManager`默认的序列化为：

```
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
```

如果请求返回的是XML数据，则需要修改

```
manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
```

如下的XML响应：

```
-(void)xml
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *paramDict = @{
                                @"type":@"XML"
                                };
    //发送GET请求
    [manager GET:@"http://xxxx" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task,NSXMLParser *parser) {
        
        //NSLog(@"%@---%@",[responseObject class],responseObject);
        //NSXMLParser *parser =(NSXMLParser *)responseObject;
        
        //设置代理
        parser.delegate = self;
        
        //开始解析
        [parser parse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
```

如果返回的数据既不是JOSN也不是XML，例如一张图片，需使用`AFHTTPResponseSerializer`，表示二进制数据，如下的例子：

```
-(void)httpData
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:@"http://xxxxx/images/minion_01.png" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        NSLog(@"%@-",[responseObject class]);
        
        //UIImage *image = [UIImage imageWithData:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
```

还有一种情况是，发送一个请求给服务器，返回的数据为网页，需修改`manager.responseSerializer.acceptableContentTypes`

`AFURLResponseSerialization`中的`acceptableContentTypes`属性，其默认支持的类型包括：

```
self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
```

如下的例子：

```
-(void)httpData
{
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送GET请求
    [manager GET:@"http://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task,id  _Nullable responseObject) {
        NSLog(@"%@-%@",[responseObject class],[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

```


如果不添加如下的代码：

```
manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
manager.responseSerializer = [AFHTTPResponseSerializer serializer];
```

则会提示错误：

```
Error Domain=com.alamofire.error.serialization.response Code=-1016 "Request failed: unacceptable content-type: text/html" UserInfo={NSLocalizedDescription=Request failed: unacceptable content-type: text/html
```


### 网络状态监测

网络状态检查可使用`AFNetworkReachabilityManager`类

使用例子如下：

```
    //获得一个网络状态检测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //监听状态的改变
    /*
     AFNetworkReachabilityStatusUnknown          = -1, 未知
     AFNetworkReachabilityStatusNotReachable     = 0,  没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,  蜂窝网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2   Wifi
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            default:
                break;
        }
    }];
    
    //开始监听
    [manager startMonitoring];
```








[1]: https://github.com/AFNetworking/AFNetworking "AFNetworking"
[2]: https://github.com/AFNetworking/AFNetworking#creating-an-upload-task-for-a-multi-part-request-with-progress "creating-an-upload-task-for-a-multi-part-request-with-progress"