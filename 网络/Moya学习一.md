# Moya学习一

[Moya](https://github.com/Moya/Moya)是对Alamofire的进一步封装，具体的介绍可参考其[中文文档](https://github.com/Moya/Moya/blob/master/Readme_CN.md)，详细介绍可参考[docs_CN](https://github.com/Moya/Moya/tree/master/docs_CN)

基本用法参考：[Basic Usage](https://github.com/Moya/Moya/blob/master/docs_CN/Examples/Basic.md)，可以对其有个直观的映象，可以快速了解该怎么用

## Target

需定义一个遵循`TargetType`协议的枚举类型，具体解释参考[Targets](https://github.com/Moya/Moya/blob/master/docs_CN/Targets.md)

`TargetType`协议的内容

![32](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/32.png)

## Task

Task为枚举，表示的是一个HTTP Task，表示请求数据的方式：

![31](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/31.png)

## Endpoint

官方文档：[(端点)Endpoints](https://github.com/Moya/Moya/blob/master/docs_CN/Endpoints.md)

最终用来生成请求，有如下的属性：

+ url - 代表请求的url
+ sampleResponseClosure - 一个闭包，复制返回一个`EndpointSampleResponse`, 指定返回的数据
+ method - 请求方式
+ task - 请求的Task
+ httpHeaderFields - 请求头



`SampleResponseClosure`的定义为一个闭包，返回一个`EndpointSampleResponse`：

```swift
public typealias SampleResponseClosure = () -> EndpointSampleResponse
```

`EndpointSampleResponse`是一个枚举，指定返回数据，用于测试

![30](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/30.png)



Endpoint有如下的扩展，将一个`Endpoint`转为`URLRequest`，根据task类型进行判断，该调用request的那个方法

![28](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/28.png)



### Target到Endpoint

`EndpointClosure`负责将Target映射为Endpoint，定义如下：

```swift
    /// Closure that defines the endpoints for the provider.
    public typealias EndpointClosure = (Target) -> Endpoint
```

在MoyaProvider的初始化方法中，其默认实现为`MoyaProvider.defaultEndpointMapping`，位于`MoyaProvider+Defaults.swift`，如下：

```swift
    final class func defaultEndpointMapping(for target: Target) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }s
```

1.url，通过Target创建URL，这个方法在 `URL+Moya.swift`文件中，为一个扩展方法

```swift
public extension URL {

    /// Initialize URL from Moya's `TargetType`.
    init<T: TargetType>(target: T) {
        // When a TargetType's path is empty, URL.appendingPathComponent may introduce trailing /, which may not be wanted in some cases
        // See: https://github.com/Moya/Moya/pull/1053
        // And: https://github.com/Moya/Moya/issues/1049
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(target.path)
        }
    }
}
```



### EndpointClosure闭包

在EndpointClosure闭包中，你可以修改`task`, `method`, `url`, `headers` 或者 `sampleResponse`，例如你可以添加新的HTTP Header，或者替换task，`Endpoint`中定义有如下的两个方法，可以实现操作：

![29](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/29.png)

例如可以将应用程序名称设置到HTTP头字段中，从而用于服务器端分析

```swift
let endpointClosure = { (target: MyTarget) -> Endpoint in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint.adding(newHTTPHeaderFields: ["APP_NAME": "MY_AWESOME_APP"])
}
let provider = MoyaProvider<GitHub>(endpointClosure: endpointClosure)
```

也可以为部分或者所有的endpoint提供附加参数，官方的例子如下：

```swift
let endpointClosure = { (target: MyTarget) -> Endpoint in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)

    // Sign all non-authenticating requests
    switch target {
    case .authenticate:
        return defaultEndpoint
    default:
        return defaultEndpoint.adding(newHTTPHeaderFields: ["AUTHENTICATION_TOKEN": GlobalAppStorage.authToken])
    }
}
let provider = MoyaProvider<GitHub>(endpointClosure: endpointClosure)
```



### RequestClosure闭包

除了上面讲的`EndpointClosure`闭包外，还有个`RequestClosure`，其定义为

```swift
/// Closure that resolves an `Endpoint` into a `RequestResult`.
public typealias RequestClosure = (Endpoint, @escaping RequestResultClosure) -> Void
```

> `requestClosure` 是可选的,是最后编辑网络请求的时机 。 它有一个默认值`MoyaProvider.defaultRequestMapping`, 这个值里面仅仅使用了`Endpoint`的 `urlRequest` 属性 .
>
> `requestClosure`用来修改`URLRequest`的指定属性或者提供直到创建request才知道的信息（比如，cookie设置）给request是非常有用的。注意上面提到的`endpointClosure` 不是为了这个目的，也不是任何特定请求的应用级映射。

即requestClosure也可以用来编辑网络请求，一般用来设置cookie

默认值`MoyaProvider.defaultRequestMapping`，实现如下，位于`MoyaProvider+Defaults.swift`文件中：

```swift
    final class func defaultRequestMapping(for endpoint: Endpoint, closure: RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
```

**自定义`requestClosure`**

例如，如下的例子，你可以在此完成网络请求的日志输出，因为这个闭包在request发送到网络之前每次都会被调用

```swift
let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // Modify the request however you like.
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error)))
    }

}
let provider = MoyaProvider<GitHub>(requestClosure: requestClosure)
```

如下，禁用所有请求的cookie

```swift
{ (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request: URLRequest = try endpoint.urlRequest()
        request.httpShouldHandleCookies = false
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error)))
    }
}
```



我自己的理解：

+ endpointClosure - 此时知识使用target构建endpoint，还未构建URLRequest，你还拿不到URLRequest，此时，可以修改target相关信息
+ requestClosure - 此时endpoint构建URLRequest，可以拿到URLRequest，可以修改URLRequest相关信息













