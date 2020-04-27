 # Alamofire中的代码例子

**1.单例**

例如，Session类中定义的单例

```swift
open class Session {
    /// Shared singleton instance used by all `AF.request` APIs. Cannot be modified.
    public static let `default` = Session()
 		...... 
}
```

使用这个单例

```swift
/// Reference to `Session.default` for quick bootstrapping and examples.
public let AF = Session.default
```

**2.默认形式参数值**

即参数有默认值，如下面的request

```swift
    open func request(_ convertible: URLConvertible,
                      method: HTTPMethod = .get,
                      parameters: Parameters? = nil,
                      encoding: ParameterEncoding = URLEncoding.default,
                      headers: HTTPHeaders? = nil,
                      interceptor: RequestInterceptor? = nil,
                      requestModifier: RequestModifier? = nil) -> DataRequest {
        
				.....
        return request(convertible, interceptor: interceptor)
    }
```

**3.方法抛出异常**

如下的代码，定义了一个协议`URLConvertible`，`String`实现了协议，在协议方法中可以抛出异常

`String`实现了协议方法，抛出了异常`throw AFError.invalidURL(url: self)` 

```swift
/// Types adopting the `URLConvertible` protocol can be used to construct `URL`s, which can then be used to construct
/// `URLRequests`.
public protocol URLConvertible {
    /// Returns a `URL` from the conforming instance or throws.
    ///
    /// - Returns: The `URL` created from the instance.
    /// - Throws:  Any error thrown while creating the `URL`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    /// Returns a `URL` if `self` can be used to initialize a `URL` instance, otherwise throws.
    ///
    /// - Returns: The `URL` initialized with `self`.
    /// - Throws:  An `AFError.invalidURL` instance.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AFError.invalidURL(url: self) }

        return url
    }
}
```





