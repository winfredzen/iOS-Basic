# Text

显示简单的文本，如：

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Stay Hungry. Stay Foolish.")
    }
}

#Preview {
    ContentView()
}
```

![001](./images/001.png)

## 修改Font和Color

如设置font为粗体，font为系统内置`.title`：

```swift
        Text("Stay Hungry. Stay Foolish.")
            .fontWeight(.bold)
            .font(.title)
```

设置font to be rounded：

```swift
        Text("Stay Hungry. Stay Foolish.")
            .fontWeight(.bold)
            .font(.system(.title, design: .rounded))
```



使用固定大小的font

```swift
        Text("Stay Hungry. Stay Foolish.")
            .font(.system(size: 20))
```



使用`foregroundColor`设置颜色

```swift
        Text("Stay Hungry. Stay Foolish.")
            .font(.system(size: 20))
            .foregroundColor(.green)
```

![002](./images/002.png)





## 多行文本

如：

```swift
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.")
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.gray)
```

![003](./images/003.png)

居中对齐

```swift
.multilineTextAlignment(.center)
```



限制行数

```swift
.lineLimit(3)
```



`truncationMode`设置如何截断text

```swift
struct ContentView: View {
    var body: some View {
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.")
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .truncationMode(.head)
    }
}
```

![004](./images/004.png)



## 设置Padding和Line Spacing

`lineSpacing`设置Line Spacing

`padding()`设置padding

```swift
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition.")
            .fontWeight(.bold)
            .font(.title)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .lineSpacing(10)
            .padding()
```

![005](./images/005.png)



## 旋转Text

```swift
.rotationEffect(.degrees(45))
```

![006](./images/006.png)





























