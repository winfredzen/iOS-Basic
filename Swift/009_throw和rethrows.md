# throw与rethrows

> 为了明确一个函数或者方法可以抛出错误，你要在它的声明当中的形式参数后边写上 throws关键字。使用 throws标记的函数叫做*抛出函数*。如果它明确了一个返回类型，那么 throws关键字要在返回箭头 ( ->)之前
>
> ```swift
> func canThrowErrors() throws -> String
> ```

**throw与rethrows的区别**

参考：

+ [错误和异常处理](https://swifter.tips/error-handle/)
+ [How to use the rethrows keyword](https://www.hackingwithswift.com/example-code/language/how-to-use-the-rethrows-keyword)
+ [What are the differences between throws and rethrows in Swift?](https://stackoverflow.com/questions/43305051/what-are-the-differences-between-throws-and-rethrows-in-swift)

>**Rethrowing Functions and Methods**

> A function or method can be declared with the `rethrows` keyword to indicate that it throws an error only if one of it’s function parameters throws an error. These functions and methods are known as *rethrowing functions* and *rethrowing methods*. Rethrowing functions and methods must have at least one throwing function parameter.
>
> 函数or方法可以使用 `rethrows` 关键字声明，表示的是只有在它的一个 function parameters(函数参数，类似于闭包) 抛出错误后，它抛出异常

如上面链接中的例子，如下的几个方法：

```swift
extension String: Error { }

//一定会抛出错误
func authenticateBiometrically(_ user: String) throws -> Bool {
    throw "Failed"
}

//不抛出错误
func authenticateByPassword(_ user: String) -> Bool {
    return true
}

func authenticateUser(method: (String) throws -> Bool) throws {
    try method("twostraws")
    print("Success!")
}

```

如下这样调用：

```swift
authenticateUser(method: authenticateByPassword)
```

会有如下的提示

![错误提示](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/14.png)

提示要使用`try`关键字标记

```swift
do {
    try authenticateUser(method: authenticateByPassword)
} catch {
    print("D'oh!")
}
```

但其实`authenticateByPassword()`方法并不会抛出错误，所以如果修改`authenticateUser`的定义，将*throw*修改为*rethrows*，当传入一个non-throwing parameter时，Swift将不再要求使用`do/catch`

```swift
func authenticateUser(method: (String) throws -> Bool) rethrows {
    try method("twostraws")
    print("Success!")
}

authenticateUser(method: authenticateByPassword)
```

当如果使用`authenticateUser(method: authenticateBiometrically)`，则会有如下的提示：

![错误提示](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/15.png)

表示需要使用`do/catch`块

