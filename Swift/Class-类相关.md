# Class

## 初始化

>在创建类和结构体的实例时必须为所有的存储属性设置一个合适的初始值。存储属性不能遗留在不确定的状态中。


**指定初始化器和便捷初始化器**

指定和便捷初始化器之间的调用关系，三个规则：

1.指定初始化器必须从它的直系父类调用指定初始化器

2.便捷初始化器必须从相同的类里调用另一个初始化器

3.便捷初始化器最终必须调用一个指定初始化器


![指定和便捷初始化器之间的调用关系](https://github.com/winfredzen/iOS-Basic/blob/master/Swift/images/4.png)

**可失败初始化器**

可失败初始化器，可分为2中情况来说

1.指定初始化器的可失败初始化器

```
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

```
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


而在swift中，非可选类型并不会自动初始化为空值，只会讲可选类型初始化为`nil`


**OC中的继承**

如下，`Tank`继承`RocketComponent`，并添加属性`encasingMaterial`

```
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

```
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































