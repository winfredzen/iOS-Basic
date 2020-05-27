# Alamofire 5简单使用

参考自：

+ [Alamofire 5 Tutorial for iOS: Getting Started](https://www.raywenderlich.com/6587213-alamofire-5-tutorial-for-ios-getting-started)

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
>