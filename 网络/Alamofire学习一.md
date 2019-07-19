# Alamofire学习一

只是对[**Alamofire**](<https://github.com/Alamofire/Alamofire>)的初步理解，现在还无法做到对Alamofire的整体理解

对Alamofire源码的解析，可参考[Alamofire源码解读系列(一)之概述和使用](<https://www.jianshu.com/p/f39ad2a3c10b>)的系列文章

我只是通过调用请求的一步步升入来理解下代码

通常的一个请求，调用的是如下的方法，其内部调用的是`SessionManager.default.request`

```swift
public func request(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil)
    -> DataRequest
{
    return SessionManager.default.request(
        url,
        method: method,
        parameters: parameters,
        encoding: encoding,
        headers: headers
    )
}
```

上面的方法：

+ method - 有默认值，默认为get

+ parameters - 默认为nil

+ encoding - 表示参数的编码方式，默认为`URLEncoding.default`

+ headers - 表示未HTTP headers，默认为nil。`HTTPHeaders`为别名

  ```swift
  /// A dictionary of headers to apply to a `URLRequest`.
  public typealias HTTPHeaders = [String: String]
  ```



在`SessionManager`中调用如下的方法：

```swift
    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        var originalRequest: URLRequest?

        do {
            originalRequest = try URLRequest(url: url, method: method, headers: headers)
            let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
            return request(encodedURLRequest)
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }
```

参数`url`遵循`URLConvertible`协议，该协议可以用来构建`URL`，`URL`用来构建url请求

在`Alamofire.swift`文件中，可见`String`、`URL`、`URLComponents`都实现了该协议

![01](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/8.png)

另外还有个`URLRequestConvertible`协议，可以用于构建URL requests，其中`URLRequest`实现了该协议

![02](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/9.png)

在上面方法的内部，调用`URLRequest`扩展的`init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil)`方法，构建`URLRequest`

```swift
    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL() //协议方法

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers { //设置请求头
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
```

然后对urlRequest进行编码

```swift
let encodedURLRequest = try encoding.encode(originalRequest!, with: parameters)
```

`ParameterEncoding`为一个协议，表示的是如果将参数集合应用到`URLRequest`

```swift
/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}
```

具体调用的是`ParameterEncoding.swift`中的如下方法：

![03](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/10.png)



然后调用`request(_ urlRequest: URLRequestConvertible) -> DataRequest`，创建DataRequest，获取请求的结果

```swift
    /// Creates a `DataRequest` to retrieve the contents of a URL based on the specified `urlRequest`.
    ///
    /// If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    ///
    /// - parameter urlRequest: The URL request.
    ///
    /// - returns: The created `DataRequest`.
    @discardableResult
    open func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        var originalRequest: URLRequest?

        do {
            originalRequest = try urlRequest.asURLRequest()
            let originalTask = DataRequest.Requestable(urlRequest: originalRequest!)

            let task = try originalTask.task(session: session, adapter: adapter, queue: queue)
            let request = DataRequest(session: session, requestTask: .data(originalTask, task))

          	//自定义下标
            delegate[task] = request

            if startRequestsImmediately { request.resume() }

            return request
        } catch {
            return request(originalRequest, failedWith: error)
        }
    }
```

`SessionDelegate.swift`中有自定义下标的实现

```swift
    /// Access the task delegate for the specified task in a thread-safe manner.
    open subscript(task: URLSessionTask) -> Request? {
        get {
            lock.lock() ; defer { lock.unlock() }
            return requests[task.taskIdentifier]
        }
        set {
            lock.lock() ; defer { lock.unlock() }
            requests[task.taskIdentifier] = newValue
        }
    }

```





