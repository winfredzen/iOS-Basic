# Alamofire学习四

Alamofire发起一个请求，其调用过程是怎样的呢？

如下一个请求：

```swift
Alamofire.request("https://httpbin.org/get").responseJSON { response in
    debugPrint(response)

    if let json = response.result.value {
        print("JSON: \(json)")
    }
}
```

在Xcode打了一些断点，发现其调用过程如下：

1.注意Alamofire可以链式调用，如后面的`responseJSON`方法，网络调用是个异步的过程，所以必须是在获取结果后调用，这是如何实现的呢？

`DataRequest`的`responseJSON(queue:options:completionHandler:)`内部调用`response(queue:responseSerializer:completionHandler:)`方法(`ResponseSerialization.swift`文件)：

![16](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/16.png)

`response`方法其内部实现如下：

![17](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/17.png)

可以看到，它向`TaskDelegate`的`queue`中，加入如上的内容

2.`TaskDelegate`中有名为`queue`的属性

```swift
/// The serial operation queue used to execute all operations after the task completes.
/// serial operation queue用来执行task完成后的所有操作
public let queue: OperationQueue
```

`TaskDelegate`的初始化方法中，`operationQueue.isSuspended = true`

```swift
    init(task: URLSessionTask?) {
        _task = task

        self.queue = {
            let operationQueue = OperationQueue()

            operationQueue.maxConcurrentOperationCount = 1
            operationQueue.isSuspended = true
            operationQueue.qualityOfService = .utility

            return operationQueue
        }()
    }
```

初始化时[isSuspended](https://developer.apple.com/documentation/foundation/operationqueue/1415909-issuspended)为true，表示不执行任何的operation，那什么执行操作呢？

在`TaskDelegate`的`urlSession(_:task:didCompleteWithError:)`中，将`isSuspended`设为false

```swift
    @objc(URLSession:task:didCompleteWithError:)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let taskDidCompleteWithError = taskDidCompleteWithError {
            taskDidCompleteWithError(session, task, error)
        } else {
            if let error = error {
                if self.error == nil { self.error = error }

                if
                    let downloadDelegate = self as? DownloadTaskDelegate,
                    let resumeData = (error as NSError).userInfo[NSURLSessionDownloadTaskResumeData] as? Data
                {
                    downloadDelegate.resumeData = resumeData
                }
            }

          	//表示队列开始执行操作
            queue.isSuspended = false
        }
    }
```

3.