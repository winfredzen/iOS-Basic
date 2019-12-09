/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class RangeSlider: UIControl {
    
    var minimumValue: CGFloat = 0 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: CGFloat = 1 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValue: CGFloat = 0.2{
        didSet {
            updateLayerFrames()
        }
    }
    
    var upperValue: CGFloat = 0.8{
        didSet {
            updateLayerFrames()
        }
    }
    
    
    
    var thumbImage = #imageLiteral(resourceName: "Oval") {
      didSet {
        upperThumbImageView.image = thumbImage
        lowerThumbImageView.image = thumbImage
        updateLayerFrames()
      }
    }
    
    var highlightedThumbImage = #imageLiteral(resourceName: "HighlightedOval") {
      didSet {
        upperThumbImageView.highlightedImage = highlightedThumbImage
        lowerThumbImageView.highlightedImage = highlightedThumbImage
        updateLayerFrames()
      }
    }
    
    //frame改变的时候更新
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    private var previousLocation = CGPoint() //追踪位置
    
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbImageView = UIImageView()
    private let upperThumbImageView = UIImageView()
    
    var trackTintColor = UIColor(white: 0.9, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)
        
        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
        
        updateLayerFrames()
        
    }
    
    //在类的初始化器前添加 required  修饰符来表明所有该类的子类都必须实现该初始化器
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLayerFrames() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        lowerThumbImageView.frame = CGRect.init(origin: thumbOriginForValue(lowerValue), size: thumbImage.size)
        upperThumbImageView.frame = CGRect.init(origin: thumbOriginForValue(upperValue), size: thumbImage.size)
        
        CATransaction.commit()

        
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    //thumb的原点
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage.size.width / 2.0 //x坐标
        return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }
    
}

extension RangeSlider {
    
    //track开始
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        previousLocation = touch.location(in: self)
        
        if lowerThumbImageView.frame.contains(previousLocation) {
            lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
            upperThumbImageView.isHighlighted = true
        }
        
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        //用户滑动的距离，按最大值，最小值转换
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        
        previousLocation = location
        
        if lowerThumbImageView.isHighlighted {
            
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
            
        } else if upperThumbImageView.isHighlighted {
            
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
            
        }
        
        /*
         This section sets the disabledActions flag inside a CATransaction. This ensures that the changes to the frame for each layer are applied immediately, and not animated.
         直接改变 不做动画
         */
        /*
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
         */
        
        //通知值改变
        sendActions(for: .valueChanged)
    
        return true
    
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
         
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
        
    }
    
    //最大值 最小值
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
      return min(max(value, lowerValue), upperValue)
    }
    
}
