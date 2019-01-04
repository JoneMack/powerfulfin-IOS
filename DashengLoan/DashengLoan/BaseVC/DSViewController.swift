//
//  DSViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import SnapKit
import RTRootNavigationController
class DSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        configNavigationBarApperance()
    }
    deinit {
        print(NSStringFromClass(self.classForCoder)+"释放了")
    }
    func loginWithController(comolete:(()->Void)?) {	
        let loginVC = DSLoginViewController()
        let navi = DSNavigationController.init(rootViewController: loginVC)
        UIApplication.shared.present(controller: navi)
        loginVC.loginSuccess = {
            comolete?()
        }
    }
    func configNavigationBarApperance()  {
        navigationController?.navigationBar.setBackgroundImage(UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.naivgaitonBarHeight)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 2))
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.ds_font(ptSize: 17)]
        navigationController?.navigationBar.barTintColor = UIColor.white
        
    }
  
}

// MARK: - 设置导航栏
extension DSViewController {
 
    func pushToNextViewController(_ viewController:UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        let backBtn = UIButton(type: .system)
        backBtn.setImage(UIImage(named: "back_icon"), for: .normal)
        backBtn.tintColor = UIColor.white
        backBtn.addTarget(target, action: action, for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: XJDeviceInfo.defaultBarHeight)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        return UIBarButtonItem(customView: backBtn)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

