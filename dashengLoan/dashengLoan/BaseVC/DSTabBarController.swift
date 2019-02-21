//
//  DSTabBarController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import UIKit

class HQTabBar: UITabBar {
    
    var itemFrames = [CGRect]()
    var tabBarItems = [UIView]()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if itemFrames.isEmpty, let UITabBarButtonClass = NSClassFromString("UITabBarButton") as? NSObject.Type {
            tabBarItems = subviews.filter({$0.isKind(of: UITabBarButtonClass)})
            tabBarItems.forEach({itemFrames.append($0.frame)})
        }
        
        if !itemFrames.isEmpty, !tabBarItems.isEmpty, itemFrames.count == items?.count {
            tabBarItems.enumerated().forEach({$0.element.frame = itemFrames[$0.offset]})
        }
    }
}

class DSTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let atabbar = HQTabBar()
        atabbar.tintColor = UIColor.ds_tintColor
        setValue(atabbar, forKey: "tabBar")
        
        let homeNavi = setupHomePage(DSHomeViewController(), title: "首页", image: imageOrgin("tab_home_unselected"), selectedImage: imageOrgin("tab_home_selected"))
        let orderNavi = setupHomePage(DSOrderViewController(), title: "订单", image: imageOrgin("tab_order_unselected"), selectedImage: imageOrgin("tab_order_selected"))
        let userNavi = setupHomePage(DSUserViewController(), title: "我的", image: imageOrgin("tab_my_unselected"), selectedImage: imageOrgin("tab_my_selected"))
        viewControllers = [homeNavi,orderNavi,userNavi]
        
        tabBar.tintColor = UIColor.ds_tintColor
    }
    func imageOrgin(_ name:String) -> UIImage? {
        return UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
    }
    func setupHomePage(_ controller:DSViewController,title:String,image:UIImage?,selectedImage:UIImage?) -> DSNavigationController {
        let navi = DSNavigationController.init(rootViewController: controller)
        navi.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage);
        
        controller.title = title
        return navi
    }

}
