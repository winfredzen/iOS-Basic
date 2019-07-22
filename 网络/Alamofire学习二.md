# Alamofire学习二

如何设置请求头？

## HTTP Headers

在`Alamofire.swift`中，请求方法中有请求头的参数，默认为`nil`

```swift
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil)
    -> DataRequest
```

`HTTPHeaders`的定义如下，为字典的别名

```swift
/// A dictionary of headers to apply to a `URLRequest`.
public typealias HTTPHeaders = [String: String]
```

使用上面的方式定义请求头可以很方便的修改请求头

```swift
let headers: HTTPHeaders = [
    "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
    "Accept": "application/json"
]

Alamofire.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
    debugPrint(response)
}
```

> 对于固定的HTTP headers，推荐在`URLSessionConfiguration`中设置，会自动应用到`URLSession`创建的`URLSessionTask`上，可参考[[Session Manager Configurations](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#session-manager) ]

默认的Alamofire的`SessionManager`对每个request提供了如下的默认的请求头

+ Accept-Encoding - 默认为`gzip;q=1.0, compress;q=0.5`
+ Accept-Language - 格式类似于`en;q=1.0`
+ User-Agent - `iOS Example/1.0 (com.alamofire.iOS-Example; build:1; iOS 10.0.0) Alamofire/4.0.0`

在`SessionManager.swift`也可以看到如下的实现

![11](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/11.png)

可见其通过configuration的`httpAdditionalHeaders`设置请求头



## Request

在`Alamofire.swift`文件中，我们可以看到如下的分类：

![12](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/12.png)

在`Request.swift`中，有如下的几个类，它们都继承自`Request`：

+ DataRequest
+ DownloadRequest
+ UploadRequest
+ StreamRequest

> All `Request` instances are always created by an owning session manager, and never initialized directly.
>
> 所有的request实例都是被session manager创建，绝不直接创建

request可以被暂停、恢复、取消

+ `suspend()` - 暂停底层的task和dispatch queue
+ `resume()` - 恢复底层的task和dispatch queue，如果拥有的manager没有将`startRequestsImmediately`设置为true，request必须调用`resume()`来开始
+ `cancel()` - 取消底层的task，生成一个错误，传递给注册的response handlers







































