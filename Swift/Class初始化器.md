# Class初始化器

## 初始化

>在创建类和结构体的实例时必须为所有的存储属性设置一个合适的初始值。存储属性不能遗留在不确定的状态中。


**指定初始化器和便捷初始化器**

>类偏向于少量指定初始化器，并且一个类通常只有一个指定初始化器。指定初始化器是初始化开始并持续初始化过程到父类链的“传送”点
>
>每个类至少得有一个指定初始化器。如同在自动初始化器的继承里描述的那样，在某些情况下，这些需求通过从父类继承一个或多个指定初始化器来满足。
>
>便捷初始化器是次要的，为一个类支持初始化器。你可以在相同的类里定义一个便捷初始化器来调用一个指定的初始化器作为便捷初始化器来给指定初始化器设置默认形式参数。你也可以为具体的使用情况或输入的值类型定义一个便捷初始化器从而创建这个类的实例。
>

指定和便捷初始化器之间的调用关系，三个规则：

1.指定初始化器必须从它的直系父类调用指定初始化器

2.便捷初始化器必须从相同的类里调用另一个初始化器

3.便捷初始化器最终必须调用一个指定初始化器

简单记忆的这些规则的方法如下：

+ 指定初始化器必须总是向上委托
+ 便捷初始化器必须总是横向委托


![指定和便捷初始化器之间的调用关系](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/4.png)

## 两段式初始化

Swift 的类初始化是一个两段式过程。在第一个阶段，每一个存储属性被引入类为分配了一个初始值。一旦每个存储属性的初始状态被确定，第二个阶段就开始了，每个类都有机会在新的实例准备使用之前来定制它的存储属性。

两段式初始化过程的使用让初始化更加安全，同时在每个类的层级结构给与了完备的灵活性。两段式初始化过程可以防止属性值在初始化之前被访问，还可以防止属性值被另一个初始化器意外地赋予不同的值。

>注意:Swift 的两段式初始化过程与 Objective-C 的初始化类似。主要的不同点是在第一阶段，Objective-C 为每一个属性分配零或空值(例如 `0` 或 `nil` )。Swift 的初始化流程更加灵活，它允许你设置自定义的初始值，并可以自如应对 `0` 或 `nil` 不为合法值的情况
>


Swift编译器执行四种有效的安全检查来确保两段式初始化过程能够顺利完成：

**安全检查 1**: 指定初始化器必须保证在向上委托给父类初始化器之前，其所在类引入的所有属性都要初始化完成。

**安全检查 2**: 指定初始化器必须先向上委托父类初始化器，然后才能为继承的属性设置新值。如果不这样做，指定初始化器赋予的新值将被父类中的初始化器所覆盖。

**安全检查 3**: 便捷初始化器必须先委托同类中的其它初始化器，然后再为任意属性赋新值（包括同类里定义的属性）。如果没这么做，便捷构初始化器赋予的新值将被自己类中其它指定初始化器所覆盖。

**安全检查 4**: 初始化器在第一阶段初始化完成之前，不能调用任何实例方法、不能读取任何实例属性的值，也不能引用 `self` 作为值

直到第一阶段结束类实例才完全合法。属性只能被读取，方法也只能被调用，直到第一阶段结束的时候，这个类实例才被看做是合法的。

参考[初始化](https://www.cnswift.org/initialization)

**可失败初始化器**

可失败初始化器，可分为2中情况来说

1.指定初始化器的可失败初始化器

```swift
// Init #1c - Designated
init?(identifier: String, reusable: Bool) {
  let identifierComponents = identifier.components(separatedBy: "-")
  guard identifierComponents.count == 2 else {
    return nil
  }
  self.reusable = reusable
  self.model = identifierComponents[0]
  self.serialNumber = identifierComponents[1]
}
```


2.便捷初始化器的可失败初始化器

```swift
// Init #1c - Convenience
convenience init?(identifier: String, reusable: Bool) {
  let identifierComponents = identifier.components(separatedBy: "-")
  guard identifierComponents.count == 2 else {
    return nil
  }
  self.init(model: identifierComponents[0], serialNumber: identifierComponents[1],
    reusable: reusable)
}
```

在写初始化器是，使指定初始化器non-failable，设置其所有属性。在便捷初始化器中包含可失败的逻辑，代理到指定初始化器


### 初始化的继承

#### 与OC的区别

如下的OC代码：

```
@interface RocketComponent : NSObject

@property(nonatomic, copy) NSString *model;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) BOOL reusable;

- (instancetype)init;

@end
```

如上，如果初始化器没有设置任何属性，OC会自动的将属性初始化为空值，如`NO`或者`0`或者`nil`


而在swift中，非可选类型并不会自动初始化为空值，只会将可选类型初始化为`nil`


**OC中的继承**

如下，`Tank`继承`RocketComponent`，并添加属性`encasingMaterial`

```objective-c
@interface RocketComponent : NSObject

@property(nonatomic, copy) NSString *model;
@property(nonatomic, copy) NSString *serialNumber;
@property(nonatomic, assign) BOOL reusable;

- (instancetype)initWithModel:(NSString *)model
                 serialNumber:(NSString *)serialNumber
                     reusable:(BOOL)reusable;

@end

@interface Tank : RocketComponent

@property(nonatomic, copy) NSString *encasingMaterial;

@end

Tank *fuelTank = [[Tank alloc] initWithModel:@"Athena" serialNumber:@"003" reusable:YES];
```


`Tank`类可以使用父类`RocketComponent`中初始化方法，并不会出错

但如下的Swift代码：

```swift
class RocketComponent {
    let model: String
    let serialNumber: String
    let reusable: Bool
    
    // Init #1a - Designated
    init(model: String, serialNumber: String, reusable: Bool) {
        self.model = model
        self.serialNumber = serialNumber
        self.reusable = reusable
    }
    
    // Init #1b - Convenience
    convenience init(model: String, serialNumber: String) {
        self.init(model: model, serialNumber: serialNumber, reusable: false)
    }
    
    // Init #1c - Designated
    init?(identifier: String, reusable: Bool) {
        let identifierComponents = identifier.components(separatedBy: "-")
        guard identifierComponents.count == 2 else {
            return nil
        }
        self.reusable = reusable
        self.model = identifierComponents[0]
        self.serialNumber = identifierComponents[1]
    }
}



class Tank: RocketComponent {
    let encasingMaterial: String
}
```


却会提示编译错误:

![编译错误](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/5.png)


原因是Swift不知道怎样来初始化一个`Tank`实例

如下的方式可以修改错误：

1.添加一个指定初始化器，调用或者重写父类`RocketComponent`的指定初始化器

2.添加一个便捷初始化，调用父类`RocketComponent`的指定初始化器

3.为存储属性添加个默认值

**在子类中添加指定初始化器**

如果子类引入一个存储属性，而且没有默认值，就至少需要一个指定初始化器。除了`encasingMaterial`的初始值，还要包括父类中的所有属性的值

首先，引入如下的初始化方法：

```swift
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.model = model
  self.serialNumber = serialNumber
  self.reusable = reusable
  self.encasingMaterial = encasingMaterial
}
```

但是，编译会提示出错：

![编译会提示出错](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/6.png)

原因是`Tank`是子类，在Swift中，子类只能初始化它引入的属性，子类不能初始化父类的属性。所以，子类的指定初始化器必须`delegate up`到父类的指定初始化器

```swift
    // Init #2a - Designated
    init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
        self.encasingMaterial = encasingMaterial
        super.init(model: model, serialNumber: serialNumber, reusable: reusable)
    }
```


但如果我们如下写初始化方法：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
  self.encasingMaterial = encasingMaterial
}
```

会提示：

![编译会提示出错](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/7.png)


同样，如下：

```swift
// Init #2a - Designated
init(model: String, serialNumber: String, reusable: Bool, encasingMaterial: String) {
  self.encasingMaterial = encasingMaterial
  self.model = model + "-X"
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```

会提示：

![编译会提示出错](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/8.png)



需要记住的是，子类的指定初始化器不能`delegate up`到父类的便捷初始化器

![子类的指定初始化器不能delegate up到父类的便捷初始化器](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/9.png)


同样，子类的便捷初始化器不能`delegate up`到父类的便捷初始化器

![子类的便捷初始化器不能`delegate up`到父类的便捷初始化器](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/10.png)


**Example Class Hierarchy**

![Example Class Hierarchy](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/11.png)


### Re-inheriting初始化器

>Remember that subclasses stop inheriting initializers once they define their own designated initializer. What if you want to be able to initialize a subclass using one of the superclass initializers?
>如果想子类想使用父类的初始化器怎么办？


使用`override`

```swift
// Init #2b - Designated
override init(model: String, serialNumber: String, reusable: Bool) {
  self.encasingMaterial = "Aluminum"
  super.init(model: model, serialNumber: serialNumber, reusable: reusable)
}
```


当重写父类的指定初始化器时，你可以让其成为一个指定初始化或者一个便捷初始化

如下方法：

```swift
    // Init #3d - Designated
     override init(model: String, serialNumber: String, reusable: Bool) {
        self.liquidType = "LOX"
        super.init(model: model, serialNumber: serialNumber,
                   reusable: reusable, encasingMaterial: "Aluminum")
    }
    
    // Init #3e - Designated
    override init(model: String, serialNumber: String, reusable: Bool,
                  encasingMaterial: String) {
        self.liquidType = "LOX"
        super.init(model: model, serialNumber: serialNumber, reusable:
            reusable, encasingMaterial: encasingMaterial)
    }
```


可以被替换为便捷初始化方法：

```swift
// Init #3d - Convenience
convenience override init(model: String, serialNumber: String, reusable: Bool) {
  self.init(model: model, serialNumber: serialNumber, reusable: reusable,
    encasingMaterial: "Aluminum", liquidType: "LOX")
}

// Init #3e - Convenience
convenience override init(model: String, serialNumber: String, reusable: Bool,
    encasingMaterial: String) {
  self.init(model: model, serialNumber: serialNumber,
    reusable: reusable, encasingMaterial: "Aluminum")
}
```
























