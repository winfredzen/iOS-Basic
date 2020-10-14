# Alamofire 5简单使用

参考自：

+ [Alamofire 5 Tutorial for iOS: Getting Started](https://www.raywenderlich.com/6587213-alamofire-5-tutorial-for-ios-getting-started)

**202010更新**

如下的一个简单请求：

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

`request`的方法定义如下：

```swift
open func request<Parameters: Encodable>(_ convertible: URLConvertible,
                                         method: HTTPMethod = .get,
                                         parameters: Parameters? = nil,
                                         encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
                                         headers: HTTPHeaders? = nil,
                                         interceptor: RequestInterceptor? = nil) -> DataRequest
```

该方法创建了一个`DataRequest`





## responseJSON

如下，获取`Films`

```swift
  func fetchFilms() {
    let requset = AF.request("https://swapi.dev/api/films")

    requset.responseJSON { (data) in
      print(data)
    }
  }
```

>requset是`DataRequest`类型
>
>`DataRequest`的extension有如下的`responseJSON`方法
>
>```swift
>    @discardableResult
>    public func responseJSON(queue: DispatchQueue = .main,
>                             options: JSONSerialization.ReadingOptions = .allowFragments,
>                             completionHandler: @escaping (AFDataResponse<Any>) -> Void) -> Self {
>        return response(queue: queue,
>                        responseSerializer: JSONResponseSerializer(options: options),
>                        completionHandler: completionHandler)
>    }
>```
>
>`completionHandler`闭包中，参数类型为`AFDataResponse<Any>`，`AFDataResponse`为`DataResponse<Success, AFError>`的别名，定义如下：
>
>```swift
>/// Default type of `DataResponse` returned by Alamofire, with an `AFError` `Failure` type.
>public typealias AFDataResponse<Success> = DataResponse<Success, AFError>
>```
>
>`DataResponse`为结构体，有如下的重要属性：
>
>```swift
>/// Type used to store all values associated with a serialized response of a `DataRequest` or `UploadRequest`.
>public struct DataResponse<Success, Failure: Error> {
>    /// The URL request sent to the server.
>    public let request: URLRequest?
>
>    /// The server's response to the URL request.
>    public let response: HTTPURLResponse?
>
>    /// The data returned by the server.
>    public let data: Data?
>
>    /// The final metrics of the response.
>    public let metrics: URLSessionTaskMetrics?
>
>    /// The time taken to serialize the response.
>    public let serializationDuration: TimeInterval
>
>    /// The result of response serialization.
>    public let result: Result<Success, Failure>
>
>    /// Returns the associated value of the result if it is a success, `nil` otherwise.
>    public var value: Success? { return result.success }
>
>    /// Returns the associated error value if the result if it is a failure, `nil` otherwise.
>    public var error: Failure? { return result.failure }
>```
>

> 其中的`value`属性表示的是result成功的关联值



## responseDecodable

如下获取数据，并解码

```swift
request.responseDecodable(of: Films.self) { (response) in
  guard let films = response.value else { return }
  print(films.all[0].title)
}
```

> `Films`为`struct`，相当于是一个数据类型
>
> `DataRequest`有如下的扩展方法`responseDecodable`
>
> ```swift
> extension DataRequest {
>     /// Adds a handler to be called once the request has finished.
>     ///
>     /// - Parameters:
>     ///   - type:              `Decodable` type to decode from response data.
>     ///   - queue:             The queue on which the completion handler is dispatched. `.main` by default.
>     ///   - decoder:           `DataDecoder` to use to decode the response. `JSONDecoder()` by default.
>     ///   - completionHandler: A closure to be executed once the request has finished.
>     ///
>     /// - Returns:             The request.
>     @discardableResult
>     public func responseDecodable<T: Decodable>(of type: T.Type = T.self,
>                                                 queue: DispatchQueue = .main,
>                                                 decoder: DataDecoder = JSONDecoder(),
>                                                 completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
>         return response(queue: queue,
>                         responseSerializer: DecodableResponseSerializer(decoder: decoder),
>                         completionHandler: completionHandler)
>     }
> }
> ```



## 链式方法

Alamofire使用链式方法（*method chaining*），将一个方法的response作为另一个的input

```swift
AF.request("https://swapi.dev/api/films")
  .validate()
  .responseDecodable(of: Films.self) { (response) in
    guard let films = response.value else { return }
    print(films.all[0].title)
  }
```

> validate the response by ensuring the response returned an HTTP status code in the range 200–299 and decode the response into your data model
>
> validate确保响应的HTTP状态码在`200–299` 



## Fetching Multiple Asynchronous Endpoints

我理解的是，同时请求多个数据

这里使用的是`DispatchGroup`，在所有的请求完成后，得到通知

```swift
  private func fecth<T: Decodable & Displayable>(_ list: [String], of: T.Type) {
    var items: [T] = [];
    
    let fetchGroup = DispatchGroup()
    
    list.forEach { (url) in
      fetchGroup.enter()
      
      AF.request(url).validate().responseDecodable(of: T.self) { (response) in
        if let value = response.value {
          items.append(value)
        }
        
        fetchGroup.leave()
      }

    }
    
    fetchGroup.notify(queue: .main) {
      self.listData = items
      self.listTableView.reloadData()
    }

  }
```



## 带参数的请求

如下的使用示例：

```swift
  func searchStarships(for name: String) {
    let url = "https://swapi.dev/api/starships"
    let parameters: [String : String] = ["search": name]
    AF.request(url, parameters: parameters)
      .validate()
      .responseDecodable(of: Starships.self) { (response) in
      
        guard let starships = response.value else { return }
        self.items = starships.all
        self.tableView.reloadData()
        
    }
  }
```

> `request`请求方式的参数如下：
>
> ```swift
>     public static func request<Parameters: Encodable>(_ url: URLConvertible,
>                                                       method: HTTPMethod = .get,
>                                                       parameters: Parameters? = nil,
>                                                       encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default,
>                                                       headers: HTTPHeaders? = nil,
>                                                       interceptor: RequestInterceptor? = nil) -> DataRequest {
>         return Session.default.request(url,
>                                        method: method,
>                                        parameters: parameters,
>                                        encoder: encoder,
>                                        headers: headers,
>                                        interceptor: interceptor)
>     }
> ```
>
> 可以发现，大部分参数都有默认值







