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









