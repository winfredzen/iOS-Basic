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



























