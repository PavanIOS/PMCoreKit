

import UIKit
#if canImport(SDWebImage)
import SDWebImage
#endif



public class CustomImageView: UIImageView {
    
    var updateColor : UIColor = Colors.white {
        didSet {
            self.changeColor(color: updateColor)
        }
    }
    
    private func changeColor(color:UIColor) {
        self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    private func setDefaultColor(){
        self.image?.withRenderingMode(.alwaysOriginal)
    }

    
}



public extension UIImageView {
    func setImage(_ filePath:String,_ placeHolder:UIImage = UIImage()){
        #if canImport(SDWebImage)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: filePath.toUrl, completed: nil)
        #else
        self.load(filePath, placeHolder)
        #endif
    }
    
    
    func getSd_Image(_ filePath:String, completion:@escaping(UIImage?) -> Void) {
        #if canImport(SDWebImage)
        self.sd_setImage(with: filePath.toUrl) { (image1, error, imageCacheType, imageUrl) in
            completion(image1)
        }
//        #else
//        do {
//            let imageData = try Data(contentsOf: filePath.toUrl)
//            return completion(UIImage(data: imageData))
//        } catch {
//            print("Error loading image : \(error)")
//        }
        #endif
    }
}
