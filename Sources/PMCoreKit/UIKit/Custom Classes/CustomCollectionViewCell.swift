
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var cornerRadius : CGFloat = 0 {
        didSet {
            self.setupCornerRadius(radius: cornerRadius)
        }
    }

    
    
    private func setupCornerRadius(radius:CGFloat){
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true
      }
    
    
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
        })
    }
    
   
}
