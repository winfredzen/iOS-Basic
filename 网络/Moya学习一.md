# Moya学习一

[Moya](https://github.com/Moya/Moya)是对Alamofire的进一步封装，具体的介绍可参考其[中文文档](https://github.com/Moya/Moya/blob/master/Readme_CN.md)，详细介绍可参考[docs_CN](https://github.com/Moya/Moya/tree/master/docs_CN)

## Target

需定义一个遵循`TargetType`协议的枚举类型，具体解释参考[Targets](https://github.com/Moya/Moya/blob/master/docs_CN/Targets.md)



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













