//
//  DSApplyOrderViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyOrderViewController: DSApplyTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSOrderLocalService()
        navigationItem.title = "订单资料"
        loadFooterView(title: "完成")
    }

}
