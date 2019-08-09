# 闭包初始化属性、lazy

参考：

+ [Swift Lazy Initialization with Closures](https://www.bobthedeveloper.io/blog/swift-lazy-initialization-with-closures)
+ [Swift Lazy Property Initialization](https://useyourloaf.com/blog/swift-lazy-property-initialization/)



## 闭包初始化属性

如下的例子，会提示：`Instance member 'arr' cannot be used on type 'Manager'`

本意是在一个属性中使用另一个属性，但提示错误

![25](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/25.png)

如果直接返回某一个值会是什么情况？

![26](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/26.png)

大概的意思是：Function生成了期望的类型Int，是否使用`()`调用它

所以这样写就OK了

```swift
struct Manager {
    var arr = ["1", "one"]
    var p : Int = {
        return 2
    }()
}
```

这种形式的闭包的写法，适用于初始化某个值需要多个步骤的时候，如：

```swift
let button: UIButton = {
  let button = UIButton(type: .system)
  button.titleLabel?.font = UIFont.systemFont(ofSize: ViewMetrics.fontSize)
  ...
  return button
}()
```

这样写的具体含义是什么，可参考[Swift Lazy Initialization with Closures](https://www.bobthedeveloper.io/blog/swift-lazy-initialization-with-closures)

如下的例子，通过闭包创建一个对象：

```swift
struct Human {
    init() {
        print("Born 1996")
    }
}

//createBob类型为() -> Human
let createBob = { () -> Human in
    let human = Human()
    return human
}

let babyBob = createBob()
```

上面的2步，可以合并为1步，如下：

```swift
let boby = { () -> Human in
    let human = Human()
    return human
}()
```

实际上可以不指定闭包的类型，去掉`() -> Human in`，但会提示如下的错误：

![27](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/27.png)

大意是不能推断复杂闭包的返回类型，要显式的指定

所以修改成如下的形式：

```swift
let boby: Human = {
    let human = Human()
    return human
}()
```



## lazy

在oc中我们会使用如下的形式在需要属性的时候创建属性：

```objective-c
- (NSNumberFormatter *)decimalFormatter
{
  if (_decimalFormatter == nil)
  {
    _decimalFormatter = [[NSNumberFormatter alloc] init];
    [_decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];        
  }
  return _decimalFormatter;
}
```

在Swift中可以通过lazy来实现：

> *延迟存储属性*的初始值在其第一次使用时才进行计算。你可以通过在其声明前标注 lazy 修饰语来表示一个延迟存储属性。

```swift
lazy var decimalFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  return formatter
}()
```

需要注意的是：`lazy`属性要使用`var`

另一种使用`lazy`的方式是，如果初始值取决于初始化实例的属性或方法，如下的例子：

![28](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/28.png)

提示错误：**Instance member 'spacing' cannot be used on type 'Manager'**

添加`lazy`后就正常了

```swift
    var spacing: CGFloat = 16.0  {
        didSet {
            stackView.spacing = spacing
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = spacing
        return stackView
    }()
```

> Remember that the closure is called during initialization so you cannot use `self` to access any properties or methods of the instance yet. If you need to access `self` you must replace the `let` with `lazy var`
>
> 闭包在初始化的过程中调用，所以不能使用self，来获取实例的属性or方法。如果要使用self，需要将let替换为lazy var



一些要注意的点：

+ You do not need to write `self` when referencing other instance properties or methods within the closure.

  闭包中，引用别的实例的属性or方法时不需要使用self

+ The closure is not escaping so you do not need to do the weak self dance to avoid creating a retain cycle.

  闭包是非逃逸的，所以不需要weak self，来避免循环引用

+ Be careful if your property can be accessed by multiple threads before it is initialized. There is no guarantee that it will be initialized only once if several threads access the property at the same time before the initial value is set.

  如果被标记为 lazy 修饰符的属性同时被多个线程访问并且属性还没有被初始化，则无法保证属性只初始化一次。









