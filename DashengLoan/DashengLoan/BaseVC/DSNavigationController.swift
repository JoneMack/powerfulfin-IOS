//
//  DSNavigationController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

/// 是否可以滑动返回，只要ViewController遵循这个协议即可
protocol XJSwipToPopBackDelegate:NSObjectProtocol {
    func canSwipToPopBack() -> Bool
}

class DSNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
extension DSNavigationController:UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        let topController = self.topViewController as? (XJSwipToPopBackDelegate & UIViewController)
        return topController?.canSwipToPopBack() ?? true
    }
}
extension DSNavigationController:UINavigationControllerDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
