//
//  CommonWebView.swift
//  GpHealthPlus
//
//  Created by sn99 on 17/06/20.
//


import UIKit
import WebKit

class CommonWebView: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var webUrl = ""
    
    var request : URLRequest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.setupBarButtons()
        webView.navigationDelegate = self
        
        
        if let urlRequest = request {
            self.webView.load(urlRequest)
        }else{
            if let url = webUrl.toUrl {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    func setupBarButtons(){
        var closeButton = UIBarButtonItem()
        if #available(iOS 13.0, *) {
            closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissView))
        } else {
            closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
            closeButton.tintColor = UIColor.systemBlue
        }
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func dismissView(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
extension CommonWebView : WKNavigationDelegate  {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if let url = webView.url {
//            let request = URLRequest(url: url)
//            let resp: CachedURLResponse? = URLCache.shared.cachedResponse(for: request)
//            if let aFields = (resp?.response as? HTTPURLResponse)?.allHeaderFields {
//                print("\(aFields)")
//            }
//        }
    }
}
