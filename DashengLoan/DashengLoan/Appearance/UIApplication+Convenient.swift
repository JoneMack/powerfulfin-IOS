//
//  UIApplication+Convenient.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
extension UIApplication {
    var topViewController:UIViewController? {
        return self.currentNavigationController?.viewControllers.last
    }
    var currentNavigationController:UINavigationController? {
        if self.rootViewController?.isKind(of: UINavigationController.classForCoder()) ?? false {
            return (self.rootViewController as! UINavigationController)
        }else if self.rootViewController?.isKind(of: UITabBarController.classForCoder()) ?? false {
            let tabBar = self.rootViewController as! UITabBarController
            let viewController = tabBar.selectedViewController
            if viewController?.isKind(of: UINavigationController.classForCoder()) ?? false {
                return (viewController as! UINavigationController)
            }
        }
        return nil
    }
  
    var rootViewController:UIViewController? {
        return keyWindow?.rootViewController
    }
    
    
    
    func present(controller:UIViewController) {
        
    }
    func push(controller:UIViewController)  {
        
    }
    
}
