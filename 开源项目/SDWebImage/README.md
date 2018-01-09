# SDWebImage

## 基本使用

一般使用[SDWebImage](https://github.com/rs/SDWebImage)来加载图片，会使用如下的类似的方法：

```
- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
```

对一些参数的说明：

**1.SDWebImageOptions**

对SDWebImageOptions的详细解释可参考[iOS开发SDWebImageOptions理解](http://www.cnblogs.com/WJJ-Dream/p/5816750.html)，常用的有：

+ `SDWebImageRefreshCached`刷新缓存，重新下载图片

**2.SDWebImageCompletionBlock**

`SDWebImageCompletionBlock`的定义如下：

```
typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
```

其中`SDImageCacheType`枚举表示的是，图片的来源，是来自网络下载、还是内存缓存，还是磁盘缓存

+ `SDImageCacheTypeNone`直接下载
+ `SDImageCacheTypeDisk`磁盘缓存
+ `SDImageCacheTypeMemory`内存缓存


在[HowToUse](https://github.com/rs/SDWebImage/blob/master/Docs/HowToUse.md)文档中，也有详细的说明。一般使用的是`UIImageView+WebCache.h`中的方法。其实`UIImageView+WebCache.h`分类的背后是`SDWebImageManager`。可使用`SDWebImageManager`来直接下载图片，可用在非`UIView`的环境中


----

如果只是想直接获取一张图片，可使用的`[SDWebImageManager sharedManager]`的如下的方法：

```
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;
```
该方法也会做内存缓存和磁盘缓存

----

如果不想做缓存，可以使用`[SDWebImageManager sharedManager]`的如下方法：

```
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageDownloaderOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageDownloaderCompletedBlock)completedBlock;
```

-----


`UIImage+GIF.h`分类可以用来播放GIF图片

```
UIImage *image = [UIImage sd_animatedGIFNamed:@"xxx];
```

-----

`NSData+ImageContentType.h`分类，获取图片的类型：

```
    NSData *imageData = [NSData dataWithContentsOfFile:@"xxxx.png"];
    NSString *typeStr = [NSData sd_contentTypeForImageData:imageData];
```

在判断图片类型的时候，只匹配第一个字节，请参考源代码

----

`SDImageCache`维护一个内存缓存和一个可选的磁盘缓存。 磁盘缓存写操作是异步执行的，所以不会给UI增加不必要的延迟。

当用内存警告的时候，需要清除缓存，可在`AppDelegate`的`applicationDidReceiveMemoryWarning:`中处理：

```
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager].imageCache clearMemory];

    [[SDWebImageManager sharedManager] cancelAll];
}
```


`- (void)cleanDisk;`方法清除所有过期的磁盘缓存。内部处理是：清除过期缓存,计算当前缓存的大小,和设置的最大缓存数量做比较,如果超出那么会继续删除(按照文件了创建的先后顺序)


`- (void)clearDisk;`直接删除缓存目录下面的文件,然后重新创建空的缓存文件

默认的缓存时间`maxCacheAge`是一星期：

```
static const NSInteger kDefaultCacheMaxCacheAge = 60 * 60 * 24 * 7; // 1 week
```

----

## 深入了解

其类结构图如下：

![类结构图](https://github.com/winfredzen/iOS-Basic/blob/master/%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE/SDWebImage/images/1.png)

调用过程如下：

![调用过程](https://github.com/winfredzen/iOS-Basic/blob/master/%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE/SDWebImage/images/2.png)

**1.最大并发数、请求超时时间**

`SDWebImageDownloader`中的`maxConcurrentDownloads`设置最大并发数，默认为6，如下：

```
_downloadQueue.maxConcurrentOperationCount = 6;
```

请求超时时间默认为**15s**，参考`SDWebImageDownloader`的`downloadTimeout`属性



**2.队列中任务**

先进先出FIFO

```
_executionOrder = SDWebImageDownloaderFIFOExecutionOrder;//队列中任务的处理方式
```

**3.缓存文件的名称**

SDWebImage是对URL的绝对路径，进行MD5加密后得到的字符串作为文件名称

在`SDImageCache.m`中的`- (NSString *)cachedFileNameForKey:(NSString *)key `，可见此方法

```
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];

    return filename;
}
```

如`URL`为`https://raw.githubusercontent.com/rs/SDWebImage/master/Docs/SDWebImageClassDiagram.png`，MD5加密后的结果为`fa43a40b4b7b3d72bde2beb226fe26e8.png`

**4.对内存警告的处理**

`SDImageCache`中有一个类`AutoPurgeCache`，监听`UIApplicationDidReceiveMemoryWarningNotification`通知

```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
```

会对NSCache对象调用`removeAllObjects`方法

```
- (void)clearMemory {
    [self.memCache removeAllObjects];
}
```

其次`SDImageCache`，也订阅了app事件的通知，做内存相关的处理：

```
[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundCleanDisk)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
```

**5.缓存**

使用[NSCache](https://developer.apple.com/documentation/foundation/nscache)来处理缓存，介绍可参考[NSCache](http://nshipster.cn/nscache/)

>`NSCache`与可变集合的不同:

>1.`NSCache`类结合了各种自动删除策略，以确保不会占用过多的系统内存。如果其它应用需要内存时，系统自动执行这些策略。当调用这些策略时，会从缓存中删除一些对象，以最大限度减少内存的占用
>
>2.`NSCache`是线程安全的，我们可以在不同的线程中添加、删除和查询缓存中的对象，而不需要锁定缓存区域。
>
>3.不像`NSMutableDictionary`对象，一个缓存对象不会拷贝key对象。
>

属性介绍：

+ name - 缓存的名称
+ delegate - 缓存的带来
+ countLimit - 能够缓存的对象的最大数量，默认为0，表示没有限制。不严格
+ totalCostLimit - 来限定缓存能维持的最大内存，默认为0，表示没有限制。不严格

常用方法：

1.存数据

```
- (void)setObject:(ObjectType)obj forKey:(KeyType)key; // 0 cost
- (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;
```

2.取数据

```
- (nullable ObjectType)objectForKey:(KeyType)key;
```

3.移除数据

```
- (void)removeObjectForKey:(KeyType)key;
```

4.代理方法

```
@protocol NSCacheDelegate <NSObject>
@optional
- (void)cache:(NSCache *)cache willEvictObject:(id)obj;
@end
```





