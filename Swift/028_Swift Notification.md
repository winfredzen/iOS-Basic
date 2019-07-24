# Swift Notification

先看下Swift中通知的通知相关的方法：

```swift
open func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name?, object anObject: Any?)

open func post(name aName: NSNotification.Name, object anObject: Any?)
```

可以看到其中有个`NSNotification.Name`的类型，[NSNotification.Name](https://developer.apple.com/documentation/foundation/nsnotification/name)表示的是通知的名称：

> In Objective-C, [`NSNotification`](https://developer.apple.com/documentation/foundation/nsnotification) names are type aliased to the [`NSString`](https://developer.apple.com/documentation/foundation/nsstring) class. In Swift, [`Notification`](https://developer.apple.com/documentation/foundation/notification) names use the nested [`NSNotification.Name`](https://developer.apple.com/documentation/foundation/nsnotification/name) type.

创建通知，首先需要一个通知名称，名称通常是字符串，所以通常的形式是使用`NSNotification.Name`的扩展：

```swift
extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}
```

也可以直接创建：

```swift
let name = Notification.Name("didReceiveData")
```

然后，就可以post通知了

```swift
NotificationCenter.default.post(name: .didReceiveData, object: nil)
```

抛出通知，带有参数

```swift
let scores = ["Bob": 5, "Alice": 3, "Arthur": 42]

NotificationCenter.default.post(name: .didReceiveData, object: self, userInfo: scores)
```



注册通知观察者

```swift
NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: .didReceiveData, object: nil)
```

```swift
@objc func onDidReceiveData(_ notification: Notification)
{
    if let data = notification.userInfo as? [String: Int]
    {
        for (name, score) in data
        {
            print("\(name) scored \(score) points!")
        }
    }
}
```

参考：

+ [从 Notification.Name 看 Swift 如何优雅的解决 String 硬编码](https://juejin.im/post/5b66ed0bf265da0fa50a3840)
+ [How To: Using Notification Center In Swift](https://learnappmaking.com/notification-center-how-to-swift/)
+ [Notification in Swift (NSNotification)](https://medium.com/@dmytro.anokhin/notification-in-swift-d47f641282fa)



Alamofire中使用通知的方式：

在`Notifications.swift`中定义了如下的内容：

```swift
extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    public struct Task {
        /// Posted when a `URLSessionTask` is resumed. The notification `object` contains the resumed `URLSessionTask`.
        public static let DidResume = Notification.Name(rawValue: "org.alamofire.notification.name.task.didResume")

        /// Posted when a `URLSessionTask` is suspended. The notification `object` contains the suspended `URLSessionTask`.
        public static let DidSuspend = Notification.Name(rawValue: "org.alamofire.notification.name.task.didSuspend")

        /// Posted when a `URLSessionTask` is cancelled. The notification `object` contains the cancelled `URLSessionTask`.
        public static let DidCancel = Notification.Name(rawValue: "org.alamofire.notification.name.task.didCancel")

        /// Posted when a `URLSessionTask` is completed. The notification `object` contains the completed `URLSessionTask`.
        public static let DidComplete = Notification.Name(rawValue: "org.alamofire.notification.name.task.didComplete")
    }
}

// MARK: -

extension Notification {
    /// Used as a namespace for all `Notification` user info dictionary keys.
    public struct Key {
        /// User info dictionary key representing the `URLSessionTask` associated with the notification.
        public static let Task = "org.alamofire.notification.key.task"

        /// User info dictionary key representing the responseData associated with the notification.
        public static let ResponseData = "org.alamofire.notification.key.responseData"
    }
}

```

抛出通知：

```swift
        NotificationCenter.default.post(
            name: Notification.Name.Task.DidResume,
            object: self,
            userInfo: [Notification.Key.Task: task]
        )
```



