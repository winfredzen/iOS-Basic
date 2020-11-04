# 波

如何实现绘制波形和对波形做动画？

先看理论，可参考：

+ [三角法入门](https://www.shuxuele.com/algebra/trigonometry.html)

+ [正弦、余弦和正切的图](https://www.shuxuele.com/algebra/trig-sin-cos-tan-graphs.html)
+ [振幅、周期、相移和频率](https://www.shuxuele.com/algebra/amplitude-period-frequency-phase-shift.html)

方程：

```tex
y = A sin(Bx + C) + D
```

- 振幅是**A**
- 周期是**2π/B**
- 相移是**−C/B**
- 垂直移位是**D**



## 正弦波

参考：[How do I draw a cosine or sine curve in Swift?](https://stackoverflow.com/questions/40230312/how-do-i-draw-a-cosine-or-sine-curve-in-swift)实现绘制正弦波

```swift
class SineView: UIView{
    let graphWidth: CGFloat = 0.8  // Graph is 80% of the width of the view
    let amplitude: CGFloat = 0.3   // Amplitude of sine wave is 30% of view height

    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 5.0, through: 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        UIColor.black.setStroke()
        path.stroke()
    }
}

let sineView = SineView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
sineView.backgroundColor = .white
```

![001](https://github.com/winfredzen/iOS-Basic/blob/master/UI/Wave/images/001.png)



## 动画

波形动画其实就是设置**相移**

可以开一个定时器，来对相移进行加或者减

为了演示，我这里直接就用`Timer`了，其它的可以使用`CADisplayLink`

```swift
import UIKit
import Foundation
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true

class SineView: UIView {
    
    let graphWidth: CGFloat = 0.8
    let amplitude: CGFloat = 0.3
    
    var offset = 0.0


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in

            self.offset += 0.01

            self.setNeedsDisplay()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)

        let path = UIBezierPath()
        
        for angle in stride(from: 5.0, to: 360.0, by: 5.0) {
            
            let x = origin.x + CGFloat(angle/360.0) * width * graphWidth
            let y = origin.y - CGFloat(sin( angle / 180.0 * Double.pi + offset)) * height * amplitude
            
            if angle == 5.0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }

        }
        
        UIColor.red.setStroke()
        path.stroke()
        
    }
}

let sineView = SineView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
sineView.backgroundColor = .white

PlaygroundPage.current.liveView = sineView
```

![002](https://github.com/winfredzen/iOS-Basic/blob/master/UI/Wave/images/002.png)



参考：

+ [一个优雅的水波动画](http://yangzq007.com/2017/08/11/%E4%B8%80%E4%B8%AA%E4%BC%98%E9%9B%85%E7%9A%84%E6%B0%B4%E6%B3%A2%E5%8A%A8%E7%94%BB/)



















