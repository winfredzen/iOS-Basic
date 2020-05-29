# Alamofire基本使用二

```swift
    open func request(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      interceptor: RequestInterceptor? = nil,
                      requestModifier: RequestModifier? = nil) -> DataRequest {
        let convertible = RequestConvertible(url: convertible,
                                             method: method,
                                             parameters: parameters,
                                             encoding: encoding,
                                             headers: headers,
                                             requestModifier: requestModifier)

        return request(convertible, interceptor: interceptor)
    }
```

Alamofire的request方法有个参数类型为`RequestModifier`，它是干什么用的呢？

## RequestModifier

方法的解释是：

> `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default.
>
> RequestModifier会被应用到`URLRequest`

在[Setting Other `URLRequest` Properties](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#setting-other-urlrequest-properties)一节，解释是：

> Alamofire的request创建方法，提供了最通用的参数，但这样还不够。可使用`RequestModifier`闭包来修改`URLRequest`。例如设置`timeoutInterval`为5秒
>
> ```swift
> AF.request("https://httpbin.org/get", requestModifier: { $0.timeoutInterval = 5 }).response(...)
> ```
>
> `RequestModifier` 也可以使用尾随闭包的语法形式
>
> ```swift
> AF.request("https://httpbin.org/get") { urlRequest in
>     urlRequest.timeoutInterval = 5
>     urlRequest.allowsConstrainedNetworkAccess = false
> }
> .response(...)
> ```
>
> `RequestModifier`仅仅适用于通过 URL 和自定义参数创建请求的时候，并不适用于直接从 `URLRequestConvertible` 里面的值们来提供参数值的那种创建请求的方式，因为第二个版本封装起来的那些值应该提供所有的请求所需的参数值。



`RequestModifier`的定义如下

```swift
    /// Closure which provides a `URLRequest` for mutation.
    public typealias RequestModifier = (inout URLRequest) throws -> Void
```



