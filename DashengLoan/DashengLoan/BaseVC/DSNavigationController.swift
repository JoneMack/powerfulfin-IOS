//
//  DSNavigationController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import RTRootNavigationController

class DSNavigationController: RTRootNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barStyle = .blackOpaque
        UINavigationBar.appearance().tintColor = UIColor.white

    }
}

extension DSNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    func updateTopViewControllerSwipBackEnable()  {
        let isRootVC = self.viewControllers.count == 1;
        if (isRootVC) {
            return;
        }
        if rt_topViewController.rt_disableInteractivePop == true {
            interactivePopGestureRecognizer?.delegate = nil
            interactivePopGestureRecognizer?.isEnabled = false
        }else{
            interactivePopGestureRecognizer?.delaysTouchesBegan = true
            interactivePopGestureRecognizer?.delegate = nil
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }

}
