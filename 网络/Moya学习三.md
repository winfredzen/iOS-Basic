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

