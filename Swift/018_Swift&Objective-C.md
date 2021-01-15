# Swift & Objective-C

官方文档：

+ [Language Interoperability](https://developer.apple.com/documentation/swift#2984801)



`Swift`和`Objective-C`相互调用的问题，可以参考：

+ [Swift](https://developer.apple.com/documentation/swift#2984801)
+ [How do I call Objective-C code from Swift?](https://stackoverflow.com/questions/24002369/how-do-i-call-objective-c-code-from-swift)



## Swift项目中导入Objective-C

新建一个Swift项目，尝试拖动OC文件到项目中，但是并不弹出"**Would you like to configure an Objective-C bridging header?**"

只有新建一个OC文件是，才有如下的弹窗

![016](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/16.png)

选择创建后，创建了个`SwiftAddOCTest-Bridging-Header.h`文件，`SwiftAddOCTest`为工程名

然后在`SwiftAddOCTest-Bridging-Header.h`文件中导入OC的头文件

我自己试了下，导入`AFNetworking`的文件夹，在桥接文件中导入`#import "AFNetworking.h"`

在swift中使用oc版本的`AFNetworking`如下：

```swift
        var manager = AFURLSessionManager(sessionConfiguration: nil);
        let url = URL(string: "http://httpbin.org/get")!
        let requset = URLRequest(url: url)
        let task = manager.dataTask(with: requset) { (response, responseObject, error) in
            print("\(responseObject)")
        }
        task.resume()
```







## Objective-C项目中导入Swift

同样，新建一个OC项目，添加一个Swift文件，有如下的弹窗

![017](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/17.png)

选择创建后，项目中多了个`OCAddSwiftTest-Bridging-Header.h`文件

按照[在Swift项目中使用OC，在OC项目中使用Swift](<http://kittenyang.com/swiftandoc/>)的方法

我写如下的类：

```swift
class MySwift: NSObject {
    func greeting() {
        print("greeting")
    }
}
```

然后在ViewController中`#import "OCAddSwiftTest-Swift.h"`，使用如下：

```objective-c
    MySwift *obj = [MySwift new];
    [obj greeting];
```

但是提示错误

```
No visible @interface for 'MySwift' declares the selector 'greeting'
```

![018](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/18.png)

而且`OCAddSwiftTest-Swift.h`中，值发现有`init`方法，而没有`greeting`方法

![019](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/19.png)



最后发现，要在方法上添加 `@objc`

```swift
class MySwift: NSObject {
    @objc func greeting() {
        print("greeting")
    }
}
```







