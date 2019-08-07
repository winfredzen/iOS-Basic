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

所以可以使用如下的方式来传递url到 `request`, `upload`, 和 `download` 方法中

```swift
let urlString = "https://httpbin.org/post"
Alamofire.request(urlString, method: .post)

let url = URL(string: urlString)!
Alamofire.request(url, method: .post)

let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
Alamofire.request(urlComponents, method: .post)
```

另外还有个`URLRequestConvertible`协议，可以用于构建URL requests，其中`URLRequest`实现了该协议

![02](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/9.png)

可以直接传递到`request`, `upload`, 和 `download`方法中

例如`Alamofire`文件中的Data Request，定义了如下的一个方法：

```swift
/// Creates a `DataRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
/// specified `urlRequest`.
///
/// - parameter urlRequest: The URL request
///
/// - returns: The created `DataRequest`.
@discardableResult
public func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
    return SessionManager.default.request(urlRequest)
}
```

可以使用如下的方式来进行请求：

```swift
let url = URL(string: "https://httpbin.org/post")!
var urlRequest = URLRequest(url: url)
urlRequest.httpMethod = "POST"

let parameters = ["foo": "bar"]

do {
    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
} catch {
    // No-op
}

urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

Alamofire.request(urlRequest)
```

>Applications interacting with web applications in a significant manner are encouraged to have custom types conform to `URLRequestConvertible` as a way to ensure consistency of requested endpoints. Such an approach can be used to abstract away server-side inconsistencies and provide type-safe routing, as well as manage authentication credentials and other state.

具体的一些自定义实现`URLRequestConvertible`，可参考：[API Parameter Abstraction](https://github.com/Alamofire/Alamofire/blob/master/Documentation/AdvancedUsage.md#api-parameter-abstraction)



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



## Parameter Encoding

在官方文档[Parameter Encoding](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#parameter-encoding)也有详细的解释，也可参考：

+ [Alamofire源码解读系列(四)之参数编码(ParameterEncoding)](https://www.jianshu.com/p/88d756f81fa9)

Parameter Encoding表示的是参数的编码方式，在`Alamofire`源码的`ParameterEncoding.swift`中定义

通过枚举`HTTPMethod`定义了请求方式，如下：

```swift
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
```

参数`Parameters`为字典的别名

```swift
public typealias Parameters = [String: Any]
```

定义了一个协议`ParameterEncoding`

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

定义三种编码方式

+ URLEncoding - URL相关的编码，可以拼接到URL中，也可以通过request的HTTP body传值，具体的位置取决于`Destination`
  + `.methodDependent` - 当请求为GET、HEAD和DELETE时，拼接到URL，其它请求方式，设置到HTTP body中
  + `.queryString` - 拼接到URL中
  + `.httpBody` - 拼接到httpBody中
+ JSONEncoding
+ PropertyListEncoding



### URLEncoding

使用HTTP body的请求，`Content-Type`会被设置为`application/x-www-form-urlencoded; charset=utf-8`

##### GET Request With URL-Encoded Parameters

GET请求，如下的形式是等价的

```swift
let parameters: Parameters = ["foo": "bar"]

// All three of these calls are equivalent
Alamofire.request("https://httpbin.org/get", parameters: parameters) // encoding defaults to `URLEncoding.default`
Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding.default)
Alamofire.request("https://httpbin.org/get", parameters: parameters, encoding: URLEncoding(destination: .methodDependent))

// https://httpbin.org/get?foo=bar
```

##### POST Request With URL-Encoded Parameters

POST请求

```swift
let parameters: Parameters = [
    "foo": "bar",
    "baz": ["a", 1],
    "qux": [
        "x": 1,
        "y": 2,
        "z": 3
    ]
]

// All three of these calls are equivalent
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters)
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.default)
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: URLEncoding.httpBody)

// HTTP body: foo=bar&baz[]=a&baz[]=1&qux[x]=1&qux[y]=2&qux[z]=3
```

##### Configuring the Encoding of `Bool` Parameters

Bool参数的编码，`URLEncoding.BoolEncoding`枚举提供如下的方法来编码`Bool`参数

+ `.numeric` - 将true作为1，false作为0
+ `.literal` - 将true和false作为字符串字面量

默认，Alamofire使用`.numeric`方法

可以使用你自己的`URLEncoding`，指定 `Bool` 的编码：

```swift
let encoding = URLEncoding(boolEncoding: .literal)
```

##### Configuring the Encoding of `Array` Parameters

对应Array参数，`URLEncoding.ArrayEncoding`提供了如下的方法来编码 `Array` 参数：

+ `.brackets` -   `foo=[1,2]`编码为`foo[]=1&foo[]=2`
+ `.noBrackets` - `foo=[1,2]`编码为`foo=1&foo=2`

默认使用`.brackets`编码，也可以自己指定：

```swift
let encoding = URLEncoding(arrayEncoding: .noBrackets)
```



### JSON Encoding

`JSONEncoding`类型创建JSON来表示参数，HTTP header中`Content-Type`被设置为`application/json`

```swift
let parameters: Parameters = [
    "foo": [1,2,3],
    "bar": [
        "baz": "qux"
    ]
]

// Both calls are equivalent
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding(options: []))

// HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}
```



### Property List Encoding

`PropertyListEncoding`使用`PropertyListSerialization`创建一个plist来表示参数对象，`Content-Type`被设置为`application/x-plist`



### Custom Encoding

可以自定义编码，如下的例子表示的是，将一个string数组编码

```swift
struct JSONStringArrayEncoding: ParameterEncoding {
    private let array: [String]

    init(array: [String]) {
        self.array = array
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = data

        return urlRequest
    }
}
```




