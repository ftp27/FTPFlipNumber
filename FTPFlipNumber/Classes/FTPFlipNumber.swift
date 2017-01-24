//
//  FTPFlipNumber.swift
//  Pods
//
//  Created by A. Cherepanov on 19/01/2017.
//
//

import UIKit

@IBDesignable
class FTPFlipNumber: UIView {
    
    let kTopAnimaton    = "animationTop"
    let kBottomAnimaton = "animationBottom"
    
    let animDuration: TimeInterval = 1
    
    
    //      _____
    // ____|_    |--- secondTopLayer
    // \     \---|--- firstTopLayer
    //  \     \__|
    //   \_____\ |
    //   |     | |
    //   |     |_|--- secondBottomLayer
    //   |_____|----- firstBottomLayer
    
    let firstTopLayer     = CALayer()
    let secondTopLayer    = CALayer()
    let firstBottomLayer  = CALayer()
    let secondBottomLayer = CALayer()
    
    var bufferContents:CGImage?
  
    @IBInspectable
    var displaedNumber:UInt = 0 {
        didSet {
            
        }
    }
    
    public func displayNumber(newNumber: UInt) {
        displaedNumber = newNumber
    }
    
    public func showNext() {
        if displaedNumber > 9 {
            displayNumber(newNumber: displaedNumber + 1)
        } else {
            displayNumber(newNumber: 1)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    func viewInit() {
        layer.addSublayer(secondBottomLayer)
        layer.addSublayer(secondTopLayer)
        layer.addSublayer(firstTopLayer)
        layer.addSublayer(firstBottomLayer)
        
        let topAnctor    = CGPoint(x: 0.5, y: 1)
        let bottomAnctor = CGPoint(x: 0.5, y: 0)
        
        firstTopLayer.anchorPoint     = topAnctor
        secondTopLayer.anchorPoint    = topAnctor
        firstBottomLayer.anchorPoint  = bottomAnctor
        secondBottomLayer.anchorPoint = bottomAnctor
        
        firstTopLayer.backgroundColor     = UIColor.white.cgColor
        secondTopLayer.backgroundColor    = UIColor.white.cgColor
        firstBottomLayer.backgroundColor  = UIColor.white.cgColor
        secondBottomLayer.backgroundColor = UIColor.white.cgColor
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouch)))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let height = layer.bounds.height/2
        let width  = layer.bounds.width
        let topLayerRect    = CGRect(x: 0, y: 0,
                                     width: width, height: height)
        let bottomLayerRect = CGRect(x: 0, y: height,
                                     width: width, height: height)
        
        firstTopLayer.frame     = topLayerRect
        secondTopLayer.frame    = topLayerRect
        firstBottomLayer.frame  = bottomLayerRect
        secondBottomLayer.frame = bottomLayerRect
        
        FTPImageCreator.images(String(displaedNumber),
                               targetSize: layer.bounds.size) { (topImage:UIImage?, bottomImage:UIImage?) in
                                self.firstTopLayer.contents = topImage?.cgImage
                                self.firstBottomLayer.contents = bottomImage?.cgImage
        }
        
      /*  FTPImageCreator.images(String(displaedNumber+1),
                               targetSize: layer.bounds.size) { (topImage:UIImage?, bottomImage:UIImage?) in
                                self.secondTopLayer.contents = topImage?.cgImage
                                self.secondBottomLayer.contents = bottomImage?.cgImage
        }*/
    }
    
    func onTouch() {
        
        displaedNumber += 1
        FTPImageCreator.images(String(displaedNumber+1),
        targetSize: layer.bounds.size) { (topImage:UIImage?, bottomImage:UIImage?) in
            self.secondTopLayer.contents = topImage?.cgImage
            self.secondBottomLayer.contents = self.firstBottomLayer.contents
            self.bufferContents = bottomImage?.cgImage
        }
        
        firstTopLayer.removeAnimation(forKey: kTopAnimaton)
        
        let topAnim = CABasicAnimation(keyPath: "transform")
        topAnim.duration = animDuration/2
        topAnim.repeatCount = 0
        topAnim.fromValue = NSValue.init(caTransform3D:
            CATransform3DMakeRotation(0, 1, 0, 0))
        topAnim.toValue = NSValue.init(caTransform3D:
            CATransform3DMakeRotation((CGFloat)(-M_PI_2), 1, 0, 0))
        topAnim.fillMode = kCAFillModeForwards
        topAnim.isRemovedOnCompletion = false
        
        topAnim.delegate = self
        topAnim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        firstTopLayer.add(topAnim, forKey: kTopAnimaton)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension FTPFlipNumber: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            let bottomAnim = CABasicAnimation(keyPath: "transform")
            bottomAnim.duration = animDuration/2
            bottomAnim.repeatCount = 1
            bottomAnim.fromValue = NSValue.init(caTransform3D:
                CATransform3DMakeRotation((CGFloat)(M_PI_2), 1, 0, 0))
            bottomAnim.toValue = NSValue.init(caTransform3D:
                CATransform3DMakeRotation(0, 1, 0, 0))
            bottomAnim.isRemovedOnCompletion = true
            bottomAnim.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
            firstBottomLayer.add(bottomAnim, forKey: kBottomAnimaton)
            firstBottomLayer.contents = self.bufferContents
            firstTopLayer.contents = secondTopLayer.contents
        }
    }
}
