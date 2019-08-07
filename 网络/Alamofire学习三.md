# Alamofire学习三

如何处理响应？

## Response

在Alamofire中使用链式调用处理响应，[官方文档](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-handling)例子如下： 

```swift
Alamofire.request("https://httpbin.org/get").responseJSON { response in
    print("Request: \(String(describing: response.request))")   // original url request
    print("Response: \(String(describing: response.response))") // http url response
    print("Result: \(response.result)")                         // response serialization result

    if let json = response.result.value {
        print("JSON: \(json)") // serialized json response
    }

    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
        print("Data: \(utf8Text)") // original server data as UTF8 string
    }
}
```

Alamofire包含5种不同的响应处理：

```swift
// Response Handler - Unserialized Response
func response(
    queue: DispatchQueue?,
    completionHandler: @escaping (DefaultDataResponse) -> Void)
    -> Self

// Response Data Handler - Serialized into Data
func responseData(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Data>) -> Void)
    -> Self

// Response String Handler - Serialized into String
func responseString(
    queue: DispatchQueue?,
    encoding: String.Encoding?,
    completionHandler: @escaping (DataResponse<String>) -> Void)
    -> Self

// Response JSON Handler - Serialized into Any
func responseJSON(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Any>) -> Void)
    -> Self

// Response PropertyList (plist) Handler - Serialized into Any
func responsePropertyList(
    queue: DispatchQueue?,
    completionHandler: @escaping (DataResponse<Any>) -> Void))
    -> Self
```

这些方法都在`ResponseSerialization.swift`中定义

任何一个response handler都不会对从服务器返回的`HTTPURLResponse`进行验证

>For example, response status codes in the `400..<500` and `500..<600` ranges do NOT automatically trigger an `Error`. Alamofire uses [Response Validation](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation) method chaining to achieve this.
>
>例如，状态码在 `400..<500` 和 `500..<600` 之间，并不会自动的触发一个 `Error`

以处理json的响应为例，其定义如下：

```swift
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
```



##DataResponse 

上面的`response`相关的方法中，回调的闭包的参数，都是`DataResponse`类型：

> Used to store all data associated with a serialized response of a data or upload request.
>
>  用来存储response数据 or 上传请求 序列化的结果 

属性如下：

![22](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/22.png)

+ request - 表示请求
+ response - 表示服务器对请求的响应
+ data - 表示服务器返回的数据
+ result - 表示响应序列化的结果，其类型为`Result<Value>`
+ value - 如果成功，表示result的关联类型的值，失败则为`nil`
+ error - 如果失败，表示result的error关联类型的值，失败则为`nil`



## Result

`Result`是个枚举，用来表示请求是否成功还是发生了错误

![23](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/23.png)

那么是如何创建`Result`的呢？

已`responseJSON`为例，内部调用`DataRequest`的如下的方法：

```swift
    @discardableResult
    public func responseJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.jsonResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
```

注意这里的`responseSerializer`类型为`DataRequest.jsonResponseSerializer(options: options)`，其返回结果为`DataResponseSerializer`，其有个变量`serializeResponse`，为一个闭包类型

![25](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/25.png)

![26](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/26.png)

在该方法的内部

![24](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/24.png)

`responseSerializer`调用`serializeResponse`方法，返回的就是`Result`类型

这里调用的就是：

```swift
Request.serializeResponseJSON(options: options, response: response, data: data, error: error)
```

![27](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/27.png)



