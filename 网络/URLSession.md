# URLSession

记录下原来不理解的内容，内容来自[Networking with URLSession](https://www.raywenderlich.com/7476-networking-with-urlsession)

如何创建`URLSession`？

![创建](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/2.png)

可以通过回调block来处理服务器的响应或者实现代理来监测进度、处理响应数据或者做认证(Authentication Challenge)

[URLSessionTask](https://developer.apple.com/documentation/foundation/urlsessiontask)是个抽象类，有如下的实体类：

![URLSessionTask](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/3.png)

以获取测试数据为例，基本过程如下：

```swift
import UIKit
import PlaygroundSupport

let bConfig = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.sessions")

let configuration = URLSessionConfiguration.default
configuration.waitsForConnectivity = true
let session = URLSession(configuration: configuration)

let url = URL(string: "https://jsonplaceholder.typicode.com/users")!

let task = session.dataTask(with: url) { (data, response, error) in
    
    guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode == 200 else {
            return
    }
    
    guard let data = data else {
        print(error.debugDescription)
        return
    }
    
    if let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? {
        print(result)
    }
    
    PlaygroundPage.current.finishExecution()
    
}

task.resume()
```



## Background Session

创建一个background的`URLSessionConfiguration`需要指定一个标识`Identifier`：

```swift
let bConfig = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.sessions")
```

如果在下载的过程中，app被终止了，可以使用这个标识符来创建与数据传输关联的configuration 和 session 对象



