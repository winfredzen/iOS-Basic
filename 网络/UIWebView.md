# UIWebView

[UIWebView][1]是iOS内置的浏览器控件

>In apps that run in iOS 8 and later, use the `WKWebView` class instead of using `UIWebView`. Additionally, consider setting the `WKPreferences` property `javaScriptEnabled` to **false** if you render files that are not supposed to run JavaScript.
>
>如果App运行在iOS8及其以后，考虑使用`WKWebView`


使用`loadHTMLString(_:baseURL:)`方法加载本地的HTML文件或者使用`loadRequest(_:)`方法来加载网络内容。使用`stopLoading()`方法来终止加载，通过`isLoading`属性来判断web view是否在加载过程中

一些方法介绍：

1.重新加载（刷新）

```
- (void)reload;
```

2.停止加载

```
- (void)stopLoading;
```

3.回退

```
- (void)goBack;
```

4.前进

```
- (void)goForward;
```


一些属性介绍：

1.需要进行检测的数据类型

```
@property(nonatomic) UIDataDetectorTypes dataDetectorTypes
```

2.是否能回退

```
@property(nonatomic,readonly,getter=canGoBack) BOOL canGoBack;
```

3.是否能前进

```
@property(nonatomic,readonly,getter=canGoForward) BOOL canGoForward;
```

4.是否正在加载中

```
@property(nonatomic,readonly,getter=isLoading) BOOL loading;
```

5.是否伸缩内容至适应屏幕当前尺寸

```
@property(nonatomic) BOOL scalesPageToFit;
```


**`UIWebView`支持的格式**

`UIWebView`不但能加载远程的网页资源，还能加载绝大部分的常见文件，包括Keynote、PDF、Pages等


**监听UIWebView的加载过程**

```
//开始发送请求（加载数据）时调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView;

//请求完毕（加载数据完毕）时调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView;

//请求错误时调用这个方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

//UIWebView在发送请求之前，都会调用这个方法，如果返回NO，代表停止加载请求，返回YES，代表允许加载请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

```



**在OC中调用JavaScript代码**

使用`stringByEvaluatingJavaScriptFromString`方法









[1]: https://developer.apple.com/documentation/uikit/uiwebview "UIWebView"