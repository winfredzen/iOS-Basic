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

