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

