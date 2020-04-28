# Alamofire学习二 - HTTPHeaders

如何设置请求头？

--------

在新版本中，`HTTPHeaders`被定义为结构体，表示是的`An order-preserving and case-insensitive representation of HTTP headers.`HTTP header的顺序保存和不区分大小写的表示

`HTTPHeader`表示是单个HTTP header的`name / value`对

```swift
/// A representation of a single HTTP header's name / value pair.
public struct HTTPHeader: Hashable {
    /// Name of the header.
    public let name: String

    /// Value of the header.
    public let value: String

    /// Creates an instance from the given `name` and `value`.
    ///
    /// - Parameters:
    ///   - name:  The name of the header.
    ///   - value: The value of the header.
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
```



------

以下下为旧版本内容，源码已修改，不再适用

-----



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



### RequestAdapter

`RequestAdapter`为一个协议，定义如下：

```swift
/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
public protocol RequestAdapter {
    /// Inspects and adapts the specified `URLRequest` in some manner if necessary and returns the result.
    ///
    /// - parameter urlRequest: The URL request to adapt.
    ///
    /// - throws: An `Error` if the adaptation encounters an error.
    ///
    /// - returns: The adapted `URLRequest`.
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest
}
```

大致的意思是：可以用来检查或者以某种方式改变一个`URLRequest`

> RequestAdapter 请求适配器，目的是自定义修改请求，一个典型的例子是为每一个请求添加Token请求头
>
> —[Alamofire源码解读系列(十三)之请求(Request)](https://www.jianshu.com/p/823926f35396)

在`SessionManager.swift`中的SessionManager类，有属性`adapter`：

```swift
/// The request adapter called each time a new request is created.
/// 每次一个新的request被创建的时候被调用
open var adapter: RequestAdapter?
```

`URLRequest`有如下的扩展extension：

```swift
extension URLRequest {
		......

    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
}
```



官方文档中的例子，[RequestAdapter](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#requestadapter)：

```swift
class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://httpbin.org") {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}
```

```swift
let sessionManager = SessionManager()
sessionManager.adapter = AccessTokenAdapter(accessToken: "1234")

sessionManager.request("https://httpbin.org/get")
```



### TaskConvertible

```swift
protocol TaskConvertible {
    func task(session: URLSession, adapter: RequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask
}
```

为一个协议，其中的方法返回值为`URLSessionTask`类型

`DataRequest`中的实现如下：

![13](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/13.png)

所以请求的过程如下，可参考[Alamofire源码解读系列(十三)之请求(Request)](https://www.jianshu.com/p/823926f35396)

![14](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/14.png)

![15](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/15.png)





























