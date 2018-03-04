# Swift-Basic

## 基础部分

### 元祖

**元祖中元素的访问**

1.通过下标

```
let coordinates = (2, 3)

let x = coordinates.0
let y = coordinates.1
```

2.也可以在定义元祖的时候给元素命名

```
let coordinatesNamed = (x: 2, y: 3)

let x2 = coordinatesNamed.x
let y2 = coordinatesNamed.y
```

3.将元组的内容分解成单独的常量和变量

```
let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
statusCode // 404
statusMessage //"Not Found"
```

分解的时候可以把要忽略的部分用下划线`_`标记

```
let (justTheStatusCode, _) = http404Error
```

## 流程控制

### 循环

#### While循环

**While**

```
var i = 1
while i < 10 {
    print(i)
    i += 1
}
```

**Repeat-While**

Repeat-While会至少执行一次

```
i = 1
repeat {
    print(i)
    i += 1
} while i < 10
```

#### For-In循环

```
let count = 10

for i in 1...count {
    print(i) //10次
}

for i in 1..<count {
    print(i)  //9次
}
```

`..<`表示一个左闭右开的区间，`...`表示闭区间

半开区间，可使用`stride(from:to:by:)`函数跳过不需要的标记

```
let minutes = 60
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    // 每5分钟渲染一个刻度线 (0, 5, 10, 15 ... 45, 50, 55)
}
```

闭区间则使用`stride(from:through:by:)`

```
let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    // 每3小时渲染一个刻度线 (3, 6, 9, 12)
}
```

在For-In循环也可以使用`where`来做条件判断，如下：

```
for i in 1...count where i % 2 == 1 {
    print("\(i) is an odd number.")
}
/*
1 is an odd number.
3 is an odd number.
5 is an odd number.
7 is an odd number.
9 is an odd number.
*/
```

### Switch

`switch`适用于条件较复杂、有更多排列组合的时候

```
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}
```

`switch`判断既能使用于字符串，也能适用于数字

`case`分支的模式可以使用`where`语句来判断额外的条件

```
let number = 10
switch number {
case _ where number % 2 == 0:
    print("Even")
default:
    print("Odd")
}

```

可以使用元组在同一个`switch`语句中测试多个值。元组中的元素可以是值，也可以是区间。另外，使用下划线`_`来匹配所有可能的值

```
let coordinates = (x: 3, y: 2, z: 5)
switch coordinates {
case (0, 0, 0):
    print("Origin")
case (_, 0, 0):
    print("On the x-axis")
case (0, _, 0):
    print("On the y-axis")
case (0, 0, _):
    print("On the z-axis")
default:
    print("Somewhere in space")
}
```

**值绑定**:`case`分支允许将匹配的值声明为临时常量或变量，并且在`case`分支体内使用

```
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
```

**区间匹配**

```
let myAge = 37
switch myAge {
case 0...2:
    print("Infant")
case 3...12:
    print("Child")
case 13...19:
    print("Teenager")
case 20...39:
    print("Adult")
case 40...60:
    print("Middle Aged")
case _ where myAge >= 61:
    print("Elderly")
default:
    print("Invalid age")
}
```


## 函数

### 函数参数标签和参数名称

每个函数参数都有一个参数标签( argument label )以及一个参数名称( parameter name ):

+ 参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面
+ 参数名称在函数的实现中使用。默认情况下，函数参数使用参数名称来作为它们的参数标签

如下的函数：

```
func someFunction(firstParameterName: Int, secondParameterName: Int) {

}
```

调用时格式为`someFunction(firstParameterName: 1, secondParameterName: 2)`

可以在参数名称前指定它的参数标签

```
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
```

可以使用一个下划线`_`，来忽略参数标签

### 默认参数

函数调用时可以忽略默认参数

```
func printMultipleOf(_ multiplier: Int, and value: Int = 1) {
    print("\(multiplier) * \(value) = \(multiplier * value)")
}
print(4)
```

### 可变参数

可变参数可以接受零个或多个值。在变量类型名后面加入（`...`）的方式来定义可变参数

```
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
// 返回 3.0, 是这 5 个数的平均数。
arithmeticMean(3, 8.25, 18.75)
// 返回 10.0, 是这 3 个数的平均数。
```

### 元祖作为返回值

如下的可选元组返回类型

```
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
```

### 输入输出参数

函数参数默认是常量。试图在函数体中更改参数值将会导致编译错误(compile-time error)。如下：

```
func incrementAndPrint(_ value: Int) {
    value += 1
    print(value)
}
```

会提示`Left side of mutating operator isn't mutable: 'value' is a 'let' constant`

所以需使用`inout`关键字，将其定义为输入输出参数。注意：

+ 只能传递变量给输入输出参数，不能传入常量或者字面量，因为其不能修改
+ 传入时，需要在其前面添加`&`符，表示这个值可以被函数修改

修改后的例子，如下：

```
func incrementAndPrint(_ value: inout Int) {
    value += 1
    print(value)
}

var value = 5
incrementAndPrint(&value) //value为6
```

### 函数类型

每个函数都有种特定的函数类型，函数的类型由函数的参数类型和返回类型组成

```
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
```

如上的函数，其函数类型都是`(Int, Int) -> Int`

```
func printHelloWorld() {
    print("hello, world")
}
```

如上的函数其函数类型是`() -> Void`

如同使用其它类型一样，可以使用函数类型，如下的例子：

```
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

var function = add
function(4, 2) //6

func subtract(_ a: Int, _ b: Int) -> Int {
    return a - b
}

function = subtract
function(4, 2) //2
```

函数类型作为参数，如下：

```
func printResult(_ function: (Int, Int) -> (Int), _ a: Int, _ b: Int) {
    let result = function(a, b)
    print(result)
}
printResult(add, 4, 2)
printResult(subtract, 4, 2)
```

函数类型作为返回值，如下：

```
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
 func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
```

使用`typealias`来为已经存在的类型重新定义名字的，如定义函数类型：

```
typealias operation = (Int, Int) -> (Int)
```


















