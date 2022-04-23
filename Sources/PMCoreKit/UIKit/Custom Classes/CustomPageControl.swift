

import UIKit

class CustomPageControl: UIPageControl {
    
    let activeImage = ImageNames.emptyImage
    let inactiveImage = ImageNames.emptyImage
    
    var updateFrameSize = false
    
    var cornerRadius : CGFloat = 5 {
           didSet {
               self.setupCornerRadius(radius: cornerRadius)
           }
       }
    
    override var numberOfPages: Int {
        didSet {
            if updateFrameSize {
                updateSize()
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.autoresizingMask = [.flexibleRightMargin,.flexibleLeftMargin]
    }
    
    private func setupCornerRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func updateSize(){
           if numberOfPages != 1 {
               let size1 = self.size(forNumberOfPages: self.numberOfPages + 1)
               self.frame.size.width = size1.width
           }
       }
    
    func setImages(){
        self.pageIndicatorTintColor = UIColor.clear
        self.currentPageIndicatorTintColor = UIColor.clear
        self.clipsToBounds = false
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            if let imageView = self.imageForSubview(view) {
                if i == self.currentPage {
                    imageView.image = self.activeImage
                } else {
                    imageView.image = self.inactiveImage
                }
                i = i + 1
            } else {
                var dotImage = self.inactiveImage
                if i == self.currentPage {
                    dotImage = self.activeImage
                }
                view.clipsToBounds = false
                view.addSubview(UIImageView(image:dotImage))
                i = i + 1
            }
        }
    }
    
    fileprivate func imageForSubview(_ view:UIView) -> UIImageView? {
        var dot:UIImageView?
        
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }
    
    func updateBorders(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
    func updateColors(_ selectedColor:UIColor,_ normalColor:UIColor){
        self.currentPageIndicatorTintColor = selectedColor
        self.pageIndicatorTintColor = normalColor
    }
    
}
