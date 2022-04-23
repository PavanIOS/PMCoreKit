

import Foundation
import UIKit


public class CustomProgressView : UIProgressView {
    
    
    var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            // 2.0 Refers to the default height of 2
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1.0, y: heightScale)
            center = c
        }
    }
    
    var cornerRadius : CGFloat = 5 {
        didSet {
            self.setupCornerRadius(cornerRadius)
        }
    }
    
    
    private func setupCornerRadius(_ radius:CGFloat){
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.sublayers![1].cornerRadius = 8
        self.subviews[1].clipsToBounds = true
    }
    
}
