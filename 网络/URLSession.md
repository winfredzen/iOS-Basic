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

## POST请求

```swift
import UIKit

let json = "{ 'hello' : 'world' }"
let url = URL(string: "http://httpbin.org/post")!
var request = URLRequest(url: url)

request.httpMethod = "Post"
request.httpBody = json.data(using: .utf8)

let session = URLSession(configuration: .default)
let task = session.dataTask(with: request) {
  
  (data, response, error) in
    if let data = data {
      if let postResponse = String(data: data, encoding: .utf8) {
        print(postResponse)
      }
    }
  
}
task.resume()
```

## 优先级与缓存策略

......

## Uploading

不能使用`URL`来创建一个[URLSessionUploadTask](https://developer.apple.com/documentation/foundation/urlsessionuploadtask)，原因是你需要设置HTTP请求方式为POST或者PUT，因此需要使用[`URLRequest`](https://developer.apple.com/documentation/foundation/urlrequest) 

>Unlike data tasks, you can use upload tasks to upload content in the background.
>
>While the upload is in progress, the task calls the session delegate’s [`urlSession(_:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:)`](https://developer.apple.com/documentation/foundation/urlsessiontaskdelegate/1408299-urlsession) method periodically to provide you with status information.

代理的分类：

![URLSessionTask](https://github.com/winfredzen/iOS-Basic/blob/master/网络/images/4.png)

```swift
import UIKit

class SessionDelegate: NSObject, URLSessionDataDelegate {
    
    //进度
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let progress = round(Float(totalBytesSent) / Float(totalBytesExpectedToSend) * 100)
        print("progress: \(progress) %")
        
    }
    
}

let image = UIImage(named: "mojave-day.jpg")
let imageData = image?.jpegData(compressionQuality: 1.0)
let uploadURL = URL(string: "http://127.0.0.1:5000/upload")!

var request = URLRequest(url: uploadURL)
request.httpMethod = "Post"

let session = URLSession(configuration: .default, delegate: SessionDelegate(), delegateQueue: OperationQueue.main)
let task = session.uploadTask(with: request, from: imageData) {
    
    (data, response, error) in
    let serverResponse = String(data: data!, encoding: .utf8)
    print(serverResponse!)
    
}

task.resume()
```

Console输出为：

```
progress: 0.0 %
progress: 1.0 %
progress: 1.0 %
progress: 1.0 %
progress: 1.0 %
progress: 2.0 %
progress: 2.0 %
progress: 2.0 %
......
progress: 98.0 %
progress: 99.0 %
progress: 99.0 %
progress: 99.0 %
progress: 100.0 %
progress: 100.0 %
progress: 100.0 %
Uploaded

```

## Downloading

使用[URLSessionDownloadTask](https://developer.apple.com/documentation/foundation/urlsessiondownloadtask)进行下载，下载时将数据写入到一个临时文件中

> Download tasks directly write the server’s response data to a temporary file, providing your app with progress updates as data arrives from the server. When you use download tasks in background sessions, these downloads continue even when your app is suspended or is otherwise not running.
>
> You can pause (cancel) download tasks and resume them later (assuming the server supports doing so). You can also resume downloads that failed because of network connectivity problems
>
> - During download, the session periodically calls the delegate’s [`urlSession(_:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)`](https://developer.apple.com/documentation/foundation/urlsessiondownloaddelegate/1409408-urlsession)method with status information.
> - Upon successful completion, the session calls the delegate’s [`urlSession(_:downloadTask:didFinishDownloadingTo:)`](https://developer.apple.com/documentation/foundation/urlsessiondownloaddelegate/1411575-urlsession) method or completion handler. In that method, you must either open the file for reading or move it to a permanent location in your app’s sandbox container directory.
> - Upon unsuccessful completion, the session calls the delegate’s [`urlSession(_:task:didCompleteWithError:)`](https://developer.apple.com/documentation/foundation/urlsessiontaskdelegate/1411610-urlsession) method or completion handler. Unlike [`URLSessionDataTask`](https://developer.apple.com/documentation/foundation/urlsessiondatatask) or [`URLSessionUploadTask`](https://developer.apple.com/documentation/foundation/urlsessionuploadtask), a download task reports server-side errors reported through HTTP status codes into corresponding [`NSError`](https://developer.apple.com/documentation/foundation/nserror) objects. These errors are shown in [Table 1](https://developer.apple.com/documentation/foundation/urlsessiondownloadtask#2934479).

## Background Session

创建一个background的`URLSessionConfiguration`需要指定一个标识`Identifier`：

```swift
let configuration = URLSessionConfiguration.background(withIdentifier: "com.raywenderlich.sessions")
//设置为.background，可降低session task的优先级
configuration.networkServiceType = .background
```

如果在下载的过程中，app被终止了，可以使用这个标识符来创建与数据传输关联的configuration 和 session 对象

一个background session必须有一个自定义的delegate，所以要使用如下的方法：

```swift
init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue: OperationQueue?)
```

如果设置delegateQueue为`nil`，表示会设置一个默认的delegate queue

如果background session正在运行时，系统终止了你的app，网路请求会在系统中的特别的process继续工作，当task完成or需要认证，iOS会在后台重新加载你的app，调用UIApplication 代理的如下方法：

> application(_:handleEventsForBackgroundURLSession:completionHandler:)
>
> Tells the delegate that events related to a URL session are waiting to be processed.

该方法会传递`identifier`和一个`completionHandler`

app应该保存`completionHandler`，使用`identifier`创建一个background configuration对象，再使用background configuration对象创建一个session

session的任务完成后，会调用[urlSessionDidFinishEvents(forBackgroundURLSession: URLSession)](https://developer.apple.com/documentation/foundation/nsurlsessiondelegate/1617185-urlsessiondidfinisheventsforback)方法，然后在这个方法的主线程中调用`completionHandler`，这是为了告知系统，现在暂停app是安全的

background session中的upload和download任务，在发出错误是，会由`URL Loading System`自动的尝试重新连接，所以并不需要使用reachability相关的接口

如果用户重新启动了app，应该使用同样的`identifier`直接创建background configuration对象，创建app上次运行时未完成的task，并为每个background configuration对象创建session



