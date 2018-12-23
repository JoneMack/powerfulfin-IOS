//
//  DSTabBarController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNavi = setupHomePage(DSHomeViewController(), title: "首页", image: imageOrgin("tab_home_unselected"), selectedImage: imageOrgin("tab_home_selected"))
        let orderNavi = setupHomePage(DSOrderViewController(), title: "订单", image: imageOrgin("tab_order_unselected"), selectedImage: imageOrgin("tab_order_selected"))
        let userNavi = setupHomePage(DSUserViewController(), title: "我的", image: imageOrgin("tab_my_unselected"), selectedImage: imageOrgin("tab_my_selected"))
        viewControllers = [homeNavi,orderNavi,userNavi]
        tabBar.tintColor = UIColor.ds_tintColor
    }
    func imageOrgin(_ name:String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysOriginal)
    }
    func setupHomePage(_ controller:DSViewController,title:String,image:UIImage?,selectedImage:UIImage?) -> DSNavigationController {
        let navi = DSNavigationController.init(rootViewController: controller)
        navi.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage);
        controller.title = title
        return navi
    }

}
