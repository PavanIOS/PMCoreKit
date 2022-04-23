

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    weak var delegate : CustomCellParserDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func disableAllSubViews(enabled:Bool){
//        for case let textfield as CustomTextField in self.contentView.subviews {
//            textfield.isEnabled = enabled
//        }
        self.contentView.isUserInteractionEnabled = enabled
    }
    
     func setupCornerRadius(radius:CGFloat){
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true
      }
     func setupBorders(width:CGFloat,color:UIColor){
        self.layer.borderColor = color.cgColor
          self.layer.borderWidth = width
      }
    
    

    func removeSeperator(){
         self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
    }
    
    func removeSectionSeparators() {
           for subview in subviews {
               if subview != contentView && subview.frame.width == frame.width {
                   subview.removeFromSuperview()
               }
           }
       }
    
    func updateBadgeValue(count: Int) {
        if count > 0 {

            // Create label
            let fontSize: CGFloat = 16
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: fontSize)
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.backgroundColor = UIColor.red

            // Add count to label and size to fit
            label.text = "\(count)"
            label.sizeToFit()

            // Adjust frame to be square for single digits or elliptical for numbers > 9
            var frame: CGRect = label.frame
            frame.size.height += CGFloat(Int(0.4 * fontSize))
            frame.size.width = (count <= 9) ? frame.size.height : frame.size.width + CGFloat(Int(fontSize))
            label.frame = frame

            // Set radius and clip to bounds
            label.layer.cornerRadius = frame.size.height / 2.0
            label.clipsToBounds = true

            // Show label in accessory view and remove disclosure
            self.accessoryView = label
        } else {
            self.accessoryView = nil
        }
     }
}

extension CustomTableViewCell {
    func showAccessoryView(_ title:String = "",_ image:UIImage = UIImage(),_ enable:Bool = false,_ indexPath:IndexPath) {
          let button = CustomButton(type: .custom)
          button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
          button.addTarget(self, action: #selector(accessoryButtonTapped), for: .touchUpInside)
          button.buttonImage = image
          button.buttonTitle = title
          button.contentMode = .scaleAspectFit
          button.row = indexPath.row
          button.section = indexPath.section
          button.isUserInteractionEnabled = enable
          self.accessoryView = button as UIView
      }
      
      @objc func accessoryButtonTapped(sender : CustomButton){
          print(sender.tag)
          print("Tapped")
      }
}
