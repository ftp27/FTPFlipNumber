//
//  FTPImageFactory.swift
//  Pods
//
//  Created by A. Cherepanov on 22/01/2017.
//
//

import UIKit

class FTPImageCreator: NSObject {
    
    class func images(_ text: String!,
                      targetSize: CGSize!,
                      done: @escaping (UIImage?, UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var fontSize:CGFloat = 0;
            // For quick first search cycle
            var step: CGFloat = max(targetSize.width, targetSize.height)/2;
            
            while step > 0 {
                var resSize = CGSize(width: 0, height: 0)
                while resSize.lessTo(targetSize) {
                    fontSize += step
                    let font = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)];
                    resSize = text.size(attributes: font)
                }
                fontSize -= step
                step = step > 1 ? 1 : 0
            }
            
            let textFont = UIFont.systemFont(ofSize: fontSize)
            
            let font = [NSFontAttributeName:textFont]
            
            let resSize = text.size(attributes: font)
            let dX = (targetSize.width  - resSize.width)/2
            let dY = (targetSize.height - resSize.height)/2
            
            let size = CGSize(width: targetSize.width, height: targetSize.height/2)
            
            UIGraphicsBeginImageContext(size)
                text.draw(at: CGPoint.init(x: dX, y: dY) , withAttributes: font)
                let topImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIGraphicsBeginImageContext(size)
                text.draw(at: CGPoint.init(x: dX, y: dY-size.height) , withAttributes: font)
                let bottomImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            DispatchQueue.main.async {
                done(topImage, bottomImage)
            }
            
        }
    }
    
}

extension CGSize {
    func lessTo(_ size2 :CGSize) -> Bool {
        return (width < size2.width &&
               height < size2.height)
    }
}
