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
        layer.addSublayer(firstBottomLayer)
        layer.addSublayer(secondBottomLayer)
        layer.addSublayer(firstTopLayer)
        layer.addSublayer(secondTopLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let height = layer.bounds.height/2
        let width  = layer.bounds.width
        let topLayerRect    = CGRect(x: 0, y: 0,      width: width, height: height)
        let bottomLayerRect = CGRect(x: 0, y: height, width: width, height: height)
        
        firstTopLayer.frame     = topLayerRect
        secondTopLayer.frame    = topLayerRect
        firstBottomLayer.frame  = bottomLayerRect
        secondBottomLayer.frame = bottomLayerRect
        
        FTPImageCreator.images(String(displaedNumber),
                               targetSize: layer.bounds.size) { (topImage:UIImage?, bottomImage:UIImage?) in
                                self.firstTopLayer.contents = topImage?.cgImage
                                self.firstBottomLayer.contents = bottomImage?.cgImage
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
