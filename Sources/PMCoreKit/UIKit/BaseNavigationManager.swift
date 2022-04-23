//
//  BaseNavigationManager.swift
//  Muvyr
//
//  Created by sn99 on 19/10/20.
//  Copyright © 2020 Gpinfotech. All rights reserved.
//

import Foundation
import UIKit


class BaseNavigationManager {
    
    static func baseViewSetup(_ window:UIWindow?){
   
        if isLoggedInAlready(){
            self.loadExistingUserScreen(window)
        }else{
            self.loadOnBoarding(window)
        }
//        if UserDefaults().bool(forKey: "Onboarding") {
//            let authModel = AuthenticationDataStore().getData()
//            if authModel.studentId != "" {
//                self.loadExistingUserScreen(window)
//            }else{
//                self.loadLoginView(window)
//            }
//        }
    }
    
//    static func loadOnBoarding(_ window:UIWindow?){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let splashView =  storyboard.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
//        let navigationController = UINavigationController(rootViewController : splashView)
//        window?.rootViewController = navigationController
//        if let window1 = window {
//            UIView.transition(with: window1, duration: 0.3, options: .transitionCrossDissolve, animations: nil,completion: nil)
//        }
//    }
//    
//    
//    static func loadMainView(_ window:UIWindow?){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainViewController =  storyboard.instantiateViewController(withIdentifier: "BaseTabBarController") as! BaseTabBarController
//      //  let rootView = UINavigationController(rootViewController: mainViewController)
//        window?.rootViewController = mainViewController
//        window?.makeKeyAndVisible()
//        
//        if let window1 = window {
//            UIView.transition(with: window1, duration: 0.3, options: .transitionCrossDissolve, animations: nil,completion: nil)
//        }
//    }
//    
//    static func loadLoginView(_ window:UIWindow?){
//        
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////        let mainViewController =  storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
////        let navigationController = UINavigationController(rootViewController : mainViewController)
////        window?.rootViewController = navigationController
////        window?.makeKeyAndVisible()
////        
////        if let window1 = window {
////            UIView.transition(with: window1, duration: 0.3, options: .transitionCrossDissolve, animations: nil,completion: nil)
////        }
//    }
//    
//    
//    static func loadExistingUserScreen(_ window:UIWindow?){
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let existinguserView =  storyboard.instantiateViewController(withIdentifier: "ExistingLoginViewController") as! ExistingLoginViewController
//        let navigationController = UINavigationController(rootViewController : existinguserView)
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
//        
//        if let window1 = window {
//            UIView.transition(with: window1, duration: 0.3, options: .transitionCrossDissolve, animations: nil,completion: nil)
//        }
//    }
}
