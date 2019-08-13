# Moya学习二

在Moya中，通常的一个网络请求形式是：

```swift
let provider = MoyaProvider<MyService>()
provider.request(.zen) { result in
    // `result` is either .success(response) or .failure(error)
}
```

这里创建一个`MoyaProvider`，调用其`request`方法，参考[(供应者)Providers](https://github.com/Moya/Moya/blob/master/docs_CN/Providers.md)

## MoyaProvider

MoyaProvider的初始化方法如下

```swift
    /// Initializes a provider.
    public init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = nil,
                manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {

        self.endpointClosure = endpointClosure
        self.requestClosure = requestClosure
        self.stubClosure = stubClosure
        self.manager = manager
        self.plugins = plugins
        self.trackInflights = trackInflights
        self.callbackQueue = callbackQueue
    }
```

可以看到每个参数都有默认值，其中：

+ endpointClosure和requestClosure，就是上一节了解的内容

其它：

### stubClosure

`StubClosure`为闭包的别名

```swift
    /// Closure that decides if/how a request should be stubbed.
		/// 表示一个request是否或者怎样被stubbed(如何应对请求)
    public typealias StubClosure = (Target) -> Moya.StubBehavior
```

其默认实现为：

```swift
    /// Do not stub. 不做处理
    final class func neverStub(_: Target) -> Moya.StubBehavior {
        return .never
    }
```

`StubBehavior`为枚举

```swift
/// Controls how stub responses are returned.
public enum StubBehavior {

    /// Do not stub.
    case never

    /// Return a response immediately.
    case immediate

    /// Return a response after a delay. 把stub请求延迟指定时间
    case delayed(seconds: TimeInterval)
}
```

可以自定义闭包，对请求进行区别性的stub

```swift
let provider = MoyaProvider<MyTarget>(stubClosure: { target: MyTarget -> Moya.StubBehavior in
    switch target {
        /* Return something different based on the target. */
    }
})
```



### Manager

Manager为别名，默认为`Alamofire.SessionManager`

```swift
public typealias Manager = Alamofire.SessionManager
```

MoyaProvider有个manager属性，表示会话session的管理者

```swift
    /// The manager for the session.
    public let manager: Manager
```

初始化的默认值为`MoyaProvider<Target>.defaultAlamofireManager()`的返回值

```swift
    final class func defaultAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders

        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }
```

需要注意：由于在AF中创建一个`Alamofire.Request`默认会立即触发请求，即使为单元测试进行 "stubbing" 请求也一样。 因此在Moya中, `startRequestsImmediately` 属性被默认设置成了 `false` 。



### 插件

`MoyaProvider`有个`plugins`属性，表示的是插件的集合

```swift
    /// A list of plugins.
    /// e.g. for logging, network activity indicator or credentials.
		/// 插件列表，可以用于logging 网络指示器 or 证书
    public let plugins: [PluginType]
```

`PluginType`为一个协议

```swift
/// A Moya Plugin receives callbacks to perform side effects wherever a request is sent or received.
///
/// for example, a plugin may be used to
///     - log network requests
///     - hide and show a network activity indicator
///     - inject additional information into a request
public protocol PluginType {
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest

    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType)

    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType)

    /// Called to modify a result before completion.
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
}
```

Moya插件在请求被发送或接收时进行回调，插件可以用来：

+ 对网络请求进行log，记录
+ 隐藏和显示网络指示器
+ 给request添加额外的信息















