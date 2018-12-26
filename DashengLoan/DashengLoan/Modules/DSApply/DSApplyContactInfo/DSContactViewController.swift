//
//  DSContactViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSContactViewController: DSApplyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联络信息"
        dataSource = DSContactLocalService()
        loadFooterView(title: "下一步")
    }
}
extension DSContactViewController {
    override func footViewClick(footBtn: UIButton) {
        let workVC = DSWorkViewController()
        pushToNextViewController(workVC)
        
    }
}
