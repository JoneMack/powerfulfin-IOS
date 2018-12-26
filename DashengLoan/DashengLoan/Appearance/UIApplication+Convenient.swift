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
        var parent: UIViewController?
        if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
            parent = rootVC
            while (parent?.presentedViewController != nil) {
                parent = parent?.presentedViewController!
            }
            if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                return nav
            }else if let nav = parent as? UINavigationController {
                return nav
            }
        }
        return nil
    }
  
    var rootViewController:UIViewController? {
        return keyWindow?.rootViewController
    }
    
    func present(controller:UIViewController) {
        currentNavigationController?.present(controller, animated: true, completion: nil)
    }
    func push(controller:UIViewController)  {
        controller.hidesBottomBarWhenPushed = true
        currentNavigationController?.pushViewController(controller, animated: true)
    }
  
    
}
