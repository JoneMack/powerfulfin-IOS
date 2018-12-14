//
//  DSHomeViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeViewController: DSViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DSLoactionManager.manager.updateUserLoaction()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configSubViews()
        
        DSLoactionManager.manager.addListener(listen: self)
        
    }
    
    func configSubViews()  {
        
        let button = UIButton(type: .custom)
        button.setTitle("下一个", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(showNextVC), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
    }

    @objc func showNextVC() {
        let searchVC = DSWebViewController()
        searchVC.urlString = "http://www.baidu.com"
        pushToNextViewController(searchVC)
        
    }


}
extension DSHomeViewController:DSLocationDelegate {
    func userLocationDidUpdate(_ success: Bool, error: Error?) {
        if success {
            print(DSLoactionManager.manager.longitude)
            print(DSLoactionManager.manager.latitude)
        }
    }
}
