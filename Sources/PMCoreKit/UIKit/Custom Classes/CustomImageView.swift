

import UIKit
#if canImport(SDWebImage)
import SDWebImage
#endif



let UrlCacheKey = malloc(4)

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
    
    
    func load(_ urlStr:String,_ placeHolder:UIImage) {
        if let url = URL(string: urlStr) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }else{
            self.image = placeHolder
        }
    }
    
    fileprivate func generateQRCode(from string: String) -> UIImage? {
        if  string == "" {
            return nil
        }
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    
    public func clearCache() {
        urlCacheKey = nil
    }
    
    fileprivate func value<T>(_ key:UnsafeMutableRawPointer?, _ defaultValue:T) -> T {
        return (objc_getAssociatedObject(self, key!) as? T) ?? defaultValue
    }
    
    private var urlCacheKey: String? {
        get {
            return value(UrlCacheKey, "")
        }
        set {
            objc_setAssociatedObject(self, UrlCacheKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}

//MARK: UIImage
public extension UIImage {
    
    func scaleToFit(in size: CGSize) -> UIImage? {
        var ratio = max(size.width / self.size.width, size.height / self.size.height)
        if ratio >= 1.0 {
            return self
        }
        
        ratio = ceil(ratio * 100) / 100
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
}



public extension UIView {
    static let loadingViewTag = 1938123987
    static let imageViewTag = 1938123988
    
    
    func showLoading(style: UIActivityIndicatorView.Style = .gray) {
        var activity = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        if activity == nil {
            var activityStyle = style
            
            if #available(iOS 13.0, *) {
                activityStyle = .medium
            }
            activity = UIActivityIndicatorView(style: activityStyle)
        }
        
        activity?.translatesAutoresizingMaskIntoConstraints = false
        activity!.startAnimating()
        activity!.hidesWhenStopped = true
        activity?.tag = UIView.loadingViewTag
        activity?.color = .gray
        addSubview(activity!)
        activity?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activity?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func stopLoading() {
        let activity = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        activity?.stopAnimating()
        activity?.removeFromSuperview()
    }
    
    
    func showImageIcon(image:UIImage){
        var iconView = viewWithTag(UIView.imageViewTag) as? UIImageView
        if iconView == nil {
            iconView = UIImageView()
        }
        self.backgroundColor = .groupTableViewBackground
        iconView?.translatesAutoresizingMaskIntoConstraints = false
        iconView!.image = image.withRenderingMode(.alwaysTemplate)
        iconView!.tintColor = Colors.gray
        iconView?.tag = UIView.imageViewTag
        addSubview(iconView!)
        iconView?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func hideImageIcon() {
        let iconView = viewWithTag(UIView.imageViewTag) as? UIImageView
        iconView?.removeFromSuperview()
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
