//
//  DSWorkViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSWorkViewController: DSApplyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSWorkLocalService()
        navigationItem.title = "学历及职业"
        loadFooterView(title: "下一步")
    }
}
extension DSWorkViewController {
    override func footViewClick(footBtn: UIButton) {
        let orderVC = DSApplyOrderViewController()
        pushToNextViewController(orderVC)
    }
}
