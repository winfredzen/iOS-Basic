# Alamofire5源码学习一

参考：

+ [Usage](https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#introduction)

**202010更新**，`Alamofire`版本为`5.2.2`

我只是通过调用请求的一步步升入来理解下代码

通常的一个请求，调用的是如下的方法

```swift
        AF.request("https://jsonplaceholder.typicode.com/todos/1").response { response in
            debugPrint(response)
        }
```

`debugPrint`的输出为：

```swift
[Request]: GET https://jsonplaceholder.typicode.com/todos/1
    [Headers]: None
    [Body]: None
[Response]:
    [Status Code]: 200
    [Headers]:
        access-control-allow-credentials: true
        Age: 25062
        Cache-Control: max-age=43200
        cf-cache-status: HIT
        cf-ray: 5e1da0af7e2f1a42-SIN
        cf-request-id: 05c662c1aa00001a425a85f200000001
        Content-Encoding: br
        Content-Type: application/json; charset=utf-8
        Date: Wed, 14 Oct 2020 01:46:37 GMT
        Etag: W/"53-hfEnumeNh6YirfjyjaujcOPPT+s"
        expect-ct: max-age=604800, report-uri="https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct"
        Expires: -1
        nel: {"report_to":"cf-nel","max_age":604800}
        Pragma: no-cache
        report-to: {"endpoints":[{"url":"https:\/\/a.nel.cloudflare.com\/report?lkg-colo=35&lkg-time=1602639997"}],"group":"cf-nel","max_age":604800}
        Server: cloudflare
        Set-Cookie: __cfduid=dc279cd211feac6411e4914e2ff2879e91602639997; expires=Fri, 13-Nov-20 01:46:37 GMT; path=/; domain=.typicode.com; HttpOnly; SameSite=Lax
        Vary: Origin, Accept-Encoding
        Via: 1.1 vegur
        x-content-type-options: nosniff
        x-powered-by: Express
        x-ratelimit-limit: 1000
        x-ratelimit-remaining: 999
        x-ratelimit-reset: 1598841974
    [Body]:
        {
          "userId": 1,
          "id": 1,
          "title": "delectus aut autem",
          "completed": false
        }
[Network Duration]: 0.46736109256744385s
[Serialization Duration]: 0.0s
[Result]: success(Optional(83 bytes))
```

在Alamofire5中使用的是命令空间`AF`，其定义为：

```swift
public let AF = Session.default
```

`request`方法如下，创建了一个`DataRequest`：

```swift
    open func request(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      interceptor: RequestInterceptor? = nil,
                      requestModifier: RequestModifier? = nil) -> DataRequest 
```

`Session`有2个顶级的API，上面是其中一个，还有一个简单点的方法：

```swift
open func request(_ urlRequest: URLRequestConvertible, 
                  interceptor: RequestInterceptor? = nil) -> DataRequest
```



上面的方法参数说明：

+ `URLConvertible` - 一个协议
+ `method` - 有默认值，默认为get
+ `parameters` - 默认为nil
+ `encoding` -  表示参数的编码方式，默认为`URLEncodedFormParameterEncoder.default`
+ `headers` - 表示未HTTP headers，默认为nil。`HTTPHeaders`为`struct`
+ `interceptor` - `RequestInterceptor` value to be used by the returned `DataRequest`. `nil` by default.
+ `requestModifier` - `RequestModifier` which will be applied to the `URLRequest` created from the provided parameters. `nil` by default



方法内部的调用为：

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

+ 创建了`RequestConvertible`实例
+ 调用了`open func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest`方法

具体内部调用如下：

```swift
    open func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest {
        let request = DataRequest(convertible: convertible,
                                  underlyingQueue: rootQueue,
                                  serializationQueue: serializationQueue,
                                  eventMonitor: eventMonitor,
                                  interceptor: interceptor,
                                  delegate: self)

        perform(request)

        return request
    }

```

+ 创建DataRequest，并执行请求



## RequestConvertible

`RequestConvertible`为结构体，实现了`URLRequestConvertible`协议，见下面

```swift
    struct RequestConvertible: URLRequestConvertible {
        let url: URLConvertible
        let method: HTTPMethod
        let parameters: Parameters?
        let encoding: ParameterEncoding
        let headers: HTTPHeaders?
        let requestModifier: RequestModifier?

        func asURLRequest() throws -> URLRequest {//创建URLRequest
            var request = try URLRequest(url: url, method: method, headers: headers)
            try requestModifier?(&request) //修改request

            return try encoding.encode(request, with: parameters)
        }
    }
```

`RequestModifier`类型定义如下，提供了修改`URLRequest`的闭包

```swift
    /// Closure which provides a `URLRequest` for mutation.
    public typealias RequestModifier = (inout URLRequest) throws -> Void
```



## `URLConvertible`

参数`url`遵循`URLConvertible`协议，该协议可以用来构建`URL`，`URL`用来构建url请求

在`Alamofire.swift`文件中，可见`String`、`URL`、`URLComponents`都实现了该协议

![01](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/8.png)

所以可以使用如下的方式来传递url到 `request`, `upload`, 和 `download` 方法中

```swift
let urlString = "https://httpbin.org/get"
AF.request(urlString)

let url = URL(string: urlString)!
AF.request(url)

let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
AF.request(urlComponents)
```



## `URLRequestConvertible`

另外还有个`URLRequestConvertible`协议，可以用于构建`URLRequest`，其中`URLRequest`默认实现了该协议

![02](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/9.png)

可以直接传递到`request`, `upload`, 和 `download`方法中

> Alamofire uses `URLRequestConvertible` as the foundation of all requests flowing through the request pipeline.
>
> `URLRequestConvertible`是request pipeline调用的基础

建议在`ParameterEncoder`不满足使用要求时，自定义`URLRequest`

```swift
let url = URL(string: "https://httpbin.org/post")!
var urlRequest = URLRequest(url: url)
urlRequest.method = .post

let parameters = ["foo": "bar"]

do {
    urlRequest.httpBody = try JSONEncoder().encode(parameters)
} catch {
    // Handle error.
}

urlRequest.headers.add(.contentType("application/json"))

AF.request(urlRequest)
```

注意这里的`AF.request`方法为`request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil)`，如下：

```swift
    open func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest {
        let request = DataRequest(convertible: convertible,
                                  underlyingQueue: rootQueue,
                                  serializationQueue: serializationQueue,
                                  eventMonitor: eventMonitor,
                                  interceptor: interceptor,
                                  delegate: self)

        perform(request)

        return request
    }
```



## HTTP Methods HTTP方法

`HTTPMethod`定义了HTTP方法

```swift
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
```

这些值可以用在`AF.request`方法的的`method`参数上，如：

```swift
AF.request("https://httpbin.org/get")
AF.request("https://httpbin.org/post", method: .post)
AF.request("https://httpbin.org/put", method: .put)
AF.request("https://httpbin.org/delete", method: .delete)
```

Alamofire也提供了URLRequest的一个扩展，来桥接`httpMethod`属性到`HTTPMethod`值

```swift
public extension URLRequest {
    /// Returns the `httpMethod` as Alamofire's `HTTPMethod` type.
    var method: HTTPMethod? {
        get { return httpMethod.flatMap(HTTPMethod.init) }
        set { httpMethod = newValue?.rawValue }
    }
}
```



## Request Parameters and Parameter Encoders

原来参数为`encoder`，类型为`ParameterEncoder`

现在为`encoding`，类型为`ParameterEncoding`



### `ParameterEncoding`

`ParameterEncoding`是一个协议

```swift
/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]


/// A type used to define how a set of parameters are applied to a `URLRequest`.
public protocol ParameterEncoding {
    /// Creates a `URLRequest` by encoding parameters and applying them on the passed request.
    ///
    /// - Parameters:
    ///   - urlRequest: `URLRequestConvertible` value onto which parameters will be encoded.
    ///   - parameters: `Parameters` to encode onto the request.
    ///
    /// - Returns:      The encoded `URLRequest`.
    /// - Throws:       Any `Error` produced during parameter encoding.
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest
}
```



实现`ParameterEncoding`协议的有：

+ `URLEncoding`
+ `JSONEncoding`

类型大致与原来类似



----

### `ParameterEncoder`

Alamofire支持任何`Encodable`类型作为请求的参数。这写参数通过符合`ParameterEncoding`协议的类型，进行转换，并添加到`URLRequest`中，然后通过网络发送。

```swift
struct Login: Encodable {
    let email: String
    let password: String
}

let login = Login(email: "test@test.test", password: "testPassword")

AF.request("https://httpbin.org/post",
           method: .post,
           parameters: login,
           encoder: JSONParameterEncoder.default).response { response in
    debugPrint(response)
}
```

 Alamofire包括两种ParameterEncoder兼容类型：

+ `JSONParameterEncoder`
+ `URLEncodedFormParameterEncoder`



#### `URLEncodedFormParameterEncoder`

`URLEncodedFormParameterEncoder`编码，可以拼接到URL中，也可以通过request的HTTP body传值，具体的位置取决于`Destination`。`URLEncodedFormParameterEncoder.Destination`有如下的三种形式：

+ `.methodDependent` - 当请求为GET、HEAD和DELETE时，拼接到URL，其它请求方式，设置到HTTP body中
+ `.queryString` - 拼接到URL中
+ `.httpBody` - 拼接到httpBody中

如果`Content-Type`没被设置的话，`Content-Type`会被设置为`application/x-www-form-urlencoded;charset=utf-8`

**GET Request With URL-Encoded Parameters**

```swift
let parameters = ["foo": "bar"]

// All three of these calls are equivalent
AF.request("https://httpbin.org/get", parameters: parameters) // encoding defaults to `URLEncoding.default`
AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
AF.request("https://httpbin.org/get", parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .methodDependent))

// https://httpbin.org/get?foo=bar
```

**POST Request With URL-Encoded Parameters**

```swift
let parameters: [String: [String]] = [
    "foo": ["bar"],
    "baz": ["a", "b"],
    "qux": ["x", "y", "z"]
]

// All three of these calls are equivalent
AF.request("https://httpbin.org/post", method: .post, parameters: parameters)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .httpBody))

// HTTP body: "qux[]=x&qux[]=y&qux[]=z&baz[]=a&baz[]=b&foo[]=bar"
```



另外还涉及到如下的处理，具体参考文档：

+ Array - ArrayEncoding
+ Bool - BoolEncoding
+ Data - DataEncoding
+ Date - DateEncoding
+ KeyEncoding
+ SpaceEncoding



#### `JSONParameterEncoder`

`JSONParameterEncoder`使用`JSONEncoder`编码`Encodable`值。并设置`URLRequest`的`httpBody`的值。`Content-Type`被设置为`application/json`

```swift
let parameters: [String: [String]] = [
    "foo": ["bar"],
    "baz": ["a", "b"],
    "qux": ["x", "y", "z"]
]

AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.prettyPrinted)
AF.request("https://httpbin.org/post", method: .post, parameters: parameters, encoder: JSONParameterEncoder.sortedKeys)

// HTTP body: {"baz":["a","b"],"foo":["bar"],"qux":["x","y","z"]}
```

#### 配置一个自定义的`JSONEncoder`

```swift
let encoder = JSONEncoder()
encoder.dateEncoding = .iso8601
encoder.keyEncodingStrategy = .convertToSnakeCase
let parameterEncoder = JSONParameterEncoder(encoder: encoder)
```



### 手动配置`URLRequest`的参数编码

直接在`URLRequest`中编码参数，`ParameterEncoder`相关API在`Alamofire`之外，也可以使用

```swift
let url = URL(string: "https://httpbin.org/get")!
var urlRequest = URLRequest(url: url)

let parameters = ["foo": "bar"]
let encodedURLRequest = try URLEncodedFormParameterEncoder.default.encode(parameters, 
                                                                          into: urlRequest)
```



## HTTP Headers

添加自定义的`HTTPHeaders`到`Request`

```swift
let headers: HTTPHeaders = [
    "Authorization": "Basic VXNlcm5hbWU6UGFzc3dvcmQ=",
    "Accept": "application/json"
]

AF.request("https://httpbin.org/headers", headers: headers).responseJSON { response in
    debugPrint(response)
}
```

其它的方式参考使用文档



