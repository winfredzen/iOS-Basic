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



### App调用js的方法

如隐藏`#demo`标签：

```
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



























