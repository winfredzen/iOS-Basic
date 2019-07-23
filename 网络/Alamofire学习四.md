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



3.`DataRequest`继承自`Request`，其内部有个`delegate`属性和`taskDelegate`属性，都是`TaskDelegate`类型

```swift
    /// The delegate for the underlying task.
    open internal(set) var delegate: TaskDelegate {
        get {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            return taskDelegate
        }
        set {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            taskDelegate = newValue
        }
    }
    
    private var taskDelegate: TaskDelegate
    private var taskDelegateLock = NSLock()
```

在其初始化方法`init(session:, requestTask:, error:)`中对其进行赋值

![18](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/18.png)



4.`SessionManager.default`，进行`SessionManager`的初始化，相当于是个单例

```swift
    /// A default instance of `SessionManager`, used by top-level Alamofire request methods, and suitable for use
    /// directly for any ad hoc requests.
    public static let `default`: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()
    
    
        public init(
        configuration: URLSessionConfiguration = URLSessionConfiguration.default,
        delegate: SessionDelegate = SessionDelegate(),
        serverTrustPolicyManager: ServerTrustPolicyManager? = nil)
    {
        self.delegate = delegate
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)

        commonInit(serverTrustPolicyManager: serverTrustPolicyManager)
    }
```

可以看到`session`(`URLSession`)的代理被设置为`SessionDelegate`，为`SessionManager`的一个属性：

```swift
    /// The session delegate handling all the task and session delegate callbacks.
    public let delegate: SessionDelegate
```



5.所以当一个请求完成，其调用的是`SessionDelegate`的`urlSession(_:task:didCompleteWithError:)`方法

这个方法内部，会调用request的delegate的`urlSession(_:task:didCompleteWithError:)`方法，即`TaskDelegate`中的方法
![19](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/19.png)

![20](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/20.png)



6.调用`TaskDelegate`的`urlSession(_:task:didCompleteWithError:)`方法

![21](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/21.png)

将queue的`isSuspended`设置为`false`

此时会执行queue的操作，即如下所示的内容，即response的回调

![16](https://github.com/winfredzen/iOS-Basic/blob/master/%E7%BD%91%E7%BB%9C/images/16.png)





















