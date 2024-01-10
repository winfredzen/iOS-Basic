# Button

最简单的创建一个Button的方式是使用默认Text样式，如下：

```swift
            Button("Regular Button") {
                
            }
```

另一种方式是自定义button的content：

```swift
            Button {
                
            } label: {
                Text("Regular Button").bold()
            }
```

![036](./images/036.png)





如下的写法：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
            }
```

等价于：

```swift
            Button(action: {
                print("Hello World tapped!")
            }, label: {
                Text("Hello Word")
            })
```

这种形式是[Multiple trailing closures](https://www.hackingwithswift.com/swift/5.3/multiple-trailing-closures)



## 修饰器的顺序

如果给Button添加padding，将`.padding()`放在最后时的效果：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
            }
```

![037](./images/037.png)

如果将`.padding()`放在`.background`前面，则是另一种显示效果：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .font(.title)
            }
```

![038](./images/038.png)



## Border

如：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .border(Color.purple, width: 5)
            }
```

![039](./images/039.png)



而如下的形式，再添加一个padding，可实现如下的效果：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(10)
                    .border(Color.purple, width: 5)
            }
```

![040](./images/040.png)

**圆角**

如果直接使用`.cornerRadius`修饰器，它只是给背景添加了圆角，如下：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(10)
                    .border(Color.purple, width: 5)
            }
```

![041](./images/041.png)



使用`overlay`来解决：

```swift
            Button {
                print("Hello World tapped!")
            } label: {
                Text("Hello Word")
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(.purple, lineWidth: 5)
                    }

            }
```

![042](./images/042.png)





## 带有Image和Text的Button

```swift
            Button(action: {
                print("Delete button tapped!")
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.title)
                    Text("Delete")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .padding()
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(40)

            }
```

![043](./images/043.png)





## Label

从 iOS 14 开始，SwiftUI 框架引入了一个名为 Label 的新视图，可让并排放置图像和文本。 因此，可以使用 Label 来创建相同的布局，而不是使用 HStack 

```swift
            Button {
                print("Delete button tapped")
            } label: {
                Label(
                    title: {
                        Text("Delete")
                            .fontWeight(.semibold)
                            .font(.title)
                    },
                    icon: {
                        Image(systemName: "trash")
                            .font(.title)
                    }
                )
                .padding()
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(40)
            }
```

![044](./images/044.png)























