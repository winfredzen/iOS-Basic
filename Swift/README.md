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



































