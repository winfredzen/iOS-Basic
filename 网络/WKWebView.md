# WKWebView

[WKWebView](https://developer.apple.com/documentation/webkit/wkwebview)是用来替代UIWebView的，Apple建议使用WKWebView来加载web内容

> 使用[`init(frame:configuration:)`](https://developer.apple.com/documentation/webkit/wkwebview/1414998-init) 方法创建一个新的WKWebView对象，使用[`loadHTMLString(_:baseURL:)`](https://developer.apple.com/documentation/webkit/wkwebview/1415004-loadhtmlstring)方法加载本地的HTML文件，或者使用[`load(_:)`](https://developer.apple.com/documentation/webkit/wkwebview/1414954-load)方法来加载web内容。使用[`stopLoading()`](https://developer.apple.com/documentation/webkit/wkwebview/1414981-stoploading)方法来停止加载，通过[`isLoading`](https://developer.apple.com/documentation/webkit/wkwebview/1414964-isloading) 属性来判断web views是否正在加载内容。
>
> 通过[`WKUIDelegate`](https://developer.apple.com/documentation/webkit/wkuidelegate) 协议来跟踪Web内容的加载
>
> ```swift
> import UIKit
> import WebKit
> class ViewController: UIViewController, WKUIDelegate {
>     
>     var webView: WKWebView!
>     
>     override func loadView() {
>         let webConfiguration = WKWebViewConfiguration()
>         webView = WKWebView(frame: .zero, configuration: webConfiguration)
>         webView.uiDelegate = self
>         view = webView
>     }
>     override func viewDidLoad() {
>         super.viewDidLoad()
>         
>         let myURL = URL(string:"https://www.apple.com")
>         let myRequest = URLRequest(url: myURL!)
>         webView.load(myRequest)
>     }}
> ```

## 类介绍

### WKWebViewConfiguration

[WKWebViewConfiguration](https://developer.apple.com/documentation/webkit/wkwebviewconfiguration)表示：

>A collection of properties used to initialize a web view.
>
>用来初始化web view的属性集合
>
>Using the `WKWebViewConfiguration` class, you can determine how soon a webpage is rendered, how media playback is handled, the granularity of items that the user can select, and many other options.
>
>WKWebViewConfiguration is only used when a web view is first initialized. You cannot use this class to change the web view's configuration after it has been created.
>
>使用 `WKWebViewConfiguration` 类，可以处理webpage渲染的速度，media播放的处理，用户选择的粒度
>
>WKWebViewConfiguration只在第一次初始化时才可使用。在web view被创建后，不能使用该类来改变web view的配置

其[`var userContentController: WKUserContentController`](https://developer.apple.com/documentation/webkit/wkwebviewconfiguration/1395668-usercontentcontroller)属性，在与js交互的过程中非常有用



## WKUIDelegate

 js中调用`alert()`、`confirm()`和`prompt()`时，在WKWebView中确不会显示，如果要显示的话，需要实现[WKUIDelegate](https://developer.apple.com/documentation/webkit/wkuidelegate)协议

例如，如果要显示Alert，需要这样做：

```swift
func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(ac, animated: true)
    completionHandler()
}
```

```javascript
        function show_alert() {
            alert('alert');
        }

```

效果如下：

![Alert效果](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/7.png)

其它的形式可参考：

+ [iOS与JS交互之WKWebView-WKUIDelegate协议](https://www.jianshu.com/p/7a1fceae5880)



## WKNavigationDelegate

[WKNavigationDelegate](https://developer.apple.com/documentation/webkit/wknavigationdelegate)的介绍如下：

> The methods of the `WKNavigationDelegate` protocol help you implement custom behaviors that are triggered during a web view's process of accepting, loading, and completing a navigation request.
>
> 用于处理网页接受、加载和导航请求等自定义的行为

例如，是否允许加载某个navigation

实现如下的方法：

```swift
extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("\(String(describing: navigationAction.request.url?.host))")
        
        if let host = navigationAction.request.url?.host {
            
            if host == "localhost" {
                decisionHandler(.allow)
                return
            }
            
            if host == "www.apple.com" {
                UIApplication.shared.open(navigationAction.request.url!)
                decisionHandler(.cancel)
                return
            }
            
        }
        
        decisionHandler(.cancel)
        
        
    }
    
}
```

其它方法的说明参考：

+ [WKWebView代理方法解析](https://www.cnblogs.com/zhanggui/p/6626483.html)



## 监测页面的加载进度

使用KVO

```swift
webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)


override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
        progressView.progress = Float(webView.estimatedProgress)
    }
}
```





## JavaScript

与JavaScript交互的入门Demo例子，可参考：

+ [Using Javascript with WKWebView](https://medium.com/@hoishing/using-javascript-with-wkwebview-64f94153ad0)
+ [JavaScript Manipulation on iOS Using WebKit](https://medium.com/capital-one-tech/javascript-manipulation-on-ios-using-webkit-2b1115e7e405)

参照上面的例子，首先在WebStorm中创建一个H5页面，如下的内容：

```html
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <script>
        function hideText() {
            document.getElementById("demo").style.display = "none";
        }

        function showText() {
            document.getElementById("demo").style.display = "block";
            window.webkit.messageHandlers.jsHandler.postMessage("trigger from JS");
        }


    </script>
</head>
<body>
    <p id="demo">Hello World.</p>
    <input type="button" onclick="showText()" value="Show Text and Trigger Handler">
    <input type="button" onclick="hideText()" value="Hide Text">

    <p>
        <a href="http://www.apple.com">Apple</a>
    </p>

</body>
</html>
```

主要是2个按钮，一个用来显示`#demo`标签，一个用来隐藏

效果如下：

![HTML效果](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/5.png)

在控制器View上添加一个`WKWebView`和一个`UIButton`按钮，如下：

![App效果](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/6.png)



### 使用脚本

[WKUserScript](https://developer.apple.com/documentation/webkit/wkuserscript)对象，可以添加到userContentController中，允许开发者将JavaScript注入到网页中

如下的例子，改变web page的背景颜色

```swift
let contentController = WKUserContentController()
let scriptSource = "document.body.style.backgroundColor = `red`;"
let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
contentController.addUserScript(script)

let config = WKWebViewConfiguration()
config.userContentController = contentController

let webView = WKWebView(frame: .zero, configuration: config)
```

参数说明：

+ source - 字符串，JavaScript源代码

+ injectionTime - 表示document是在start或者end时加载JavaScript

  > If you pass in [WKUserInjectionTime.atDocumentStart](https://developer.apple.com/documentation/webkit/wkuserscriptinjectiontime/1537575-atdocumentstart), your script will run right after the document element has been created but before any of the document has been parsed. If you pass in [WKUserInjectionTime.atDocumentEnd](https://developer.apple.com/documentation/webkit/wkuserscriptinjectiontime/1537798-atdocumentend), then your script will run after the document is finished parsing but before any subresources (e.g., images) have loaded. This corresponds with when the DOMContentLoaded event is fired.

+ forMainFrameOnly - Specify whether your script runs in all frames or just in the main frame.



### App调用js的方法

如隐藏`#demo`标签：

```swift
    @objc func hideText(_ sender: Any) {
        
        let js = "hideText()"
        
        webView?.evaluateJavaScript(js, completionHandler: nil)

    }
```

在web view中使用`evaluateJavaScript(_:completionHandler:)`来触发JavaScript，`hideText()`是在JavaScript中自定义的方法



### 接受来自js的消息

要从javascript接收消息，需要为要调用的javascript提供消息名称，把它命名为`jsHandler`

```javascript
window.webkit.messageHandlers.jsHandler.postMessage("trigger from JS");
```

还需要遵循`WKScriptMessageHandler`协议，实现`userContentController(_:didReceive:)`方法

```swift
extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if message.name == "jsHandler", let messageBody = message.body as? String {
            
            print(messageBody)
            
        }
        
    }
    
}
```

但先要使用`WKUserContentController`的`add(_ scriptMessageHandler: WKScriptMessageHandler, name: String)`方法，添加script message handler，如下：

```swift
contentController.add(self, name: "jsHandler")
```

## Local Storage

设置Local Storage，可参考如下的链接：

+ [Is there a way to set local storage in WKWebView](https://stackoverflow.com/questions/44896823/is-there-a-way-to-set-local-storage-in-wkwebview)
+ [How to set the local storage before a UIWebView loading its initial request?](https://stackoverflow.com/questions/42622192/how-to-set-the-local-storage-before-a-uiwebview-loading-its-initial-request?noredirect=1&lq=1)

## 其它

文章：

+ [The Ultimate Guide to WKWebView](https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview)
+ [iOS下JS与OC互相调用（二）--WKWebView 拦截URL](https://www.jianshu.com/p/99c3af6894f4)
+ [iOS下JS与OC互相调用（三）--MessageHandler](https://www.jianshu.com/p/433e59c5a9eb)
+ [iOS与JS交互之WKWebView-协议拦截](https://www.jianshu.com/p/e23aa25d7514)



