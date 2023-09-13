# NSURLAuthenticationMethodServerTrust

[NSURLAuthenticationMethodServerTrust](https://developer.apple.com/documentation/foundation/nsurlauthenticationmethodservertrust?language=objc)含义是:

> Perform server trust authentication (certificate validation) for this protection space.
>
> 对此保护空间执行服务器信任身份验证（证书验证）。

在官方文档[Performing Manual Server Trust Authentication](https://developer.apple.com/documentation/foundation/url_loading_system/handling_an_authentication_challenge/performing_manual_server_trust_authentication?language=objc)一文中

> When you use a secure connection (such as `https`) with a URL request, your [`NSURLSessionDelegate`](https://developer.apple.com/documentation/foundation/nsurlsessiondelegate?language=objc) receives an authentication challenge with an authentication type of [`NSURLAuthenticationMethodServerTrust`](https://developer.apple.com/documentation/foundation/nsurlauthenticationmethodservertrust?language=objc). Unlike other challenges where the server is asking your app to authenticate itself, this is an opportunity for you to authenticate the server’s credentials.
>
> 当您使用带有 URL 请求的安全连接（例如 https）时，您的 `NSURLSessionDelegate` 会收到身份验证类型为 `NSURLAuthenticationMethodServerTrust` 的身份验证质询。 与服务器要求您的应用程序进行自身身份验证的其他挑战不同，**这是您验证服务器凭据的机会**。

如下的文章讲的不错：

+ [iOS Authentication Challenge](https://juejin.cn/post/6844904056767381518#heading-24)

