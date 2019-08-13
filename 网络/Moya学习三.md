# Moya学习三

如果有非常多个endpoint，会导致枚举中的case非常的多，所以就引出了[高级用法 - 为多个target在同一个`Provider`中使用而采用 `MultiTarget`](https://github.com/Moya/Moya/blob/master/docs_CN/Examples/MultiTarget.md)

## MultiTarget

官方demo中使用MultiTarget的例子

```swift
let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
```

![34](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/34.png)

![35](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/35.png)

![36](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/36.png)

看下`MultiTarget`的实现，如下，它也遵循`TargetType`协议

```swift
/// A `TargetType` used to enable `MoyaProvider` to process multiple `TargetType`s.
public enum MultiTarget: TargetType {
    /// The embedded `TargetType`.
    case target(TargetType)

    /// Initializes a `MultiTarget`.
    public init(_ target: TargetType) {
        self = MultiTarget.target(target)
    }

    /// The embedded target's base `URL`.
    public var path: String {
        return target.path
    }

    /// The baseURL of the embedded target.
    public var baseURL: URL {
        return target.baseURL
    }

    /// The HTTP method of the embedded target.
    public var method: Moya.Method {
        return target.method
    }

    /// The sampleData of the embedded target.
    public var sampleData: Data {
        return target.sampleData
    }

    /// The `Task` of the embedded target.
    public var task: Task {
        return target.task
    }

    /// The `ValidationType` of the embedded target.
    public var validationType: ValidationType {
        return target.validationType
    }

    /// The headers of the embedded target.
    public var headers: [String: String]? {
        return target.headers
    }

    /// The embedded `TargetType`.
    public var target: TargetType {
        switch self {
        case .target(let target): return target
        }
    }
}
```

类似于枚举的嵌套



