

import Foundation
import UIKit


public class SocialShareManager {
    
    static let shared = SocialShareManager()
    
    
    func socialShare(sender: UIViewController, sView: UIView, sharingText: String?, sharingImage: UIImage?, sharingURL: URL?, sharingURL1: URL? = nil) {
        var sharingItems = [Any]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        if let url1 = sharingURL1 {
            sharingItems.append(url1)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        if let avc = activityViewController.popoverPresentationController {
            avc.sourceView = sView
        }
        sender.present(activityViewController, animated: true, completion: nil)
    }

}
