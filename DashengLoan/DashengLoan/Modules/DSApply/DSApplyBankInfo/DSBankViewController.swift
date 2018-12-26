//
//  DSBankViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSBankViewController: DSApplyTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "银行卡"
        dataSource = DSBankLocalService()
        loadFooterView(title: "下一步")
    }
    override func tableViewType() -> UITableView.Style {
        return .plain
    }
    override func configTableView()  {
        super.configTableView()
    }
}
extension DSBankViewController {
  
    override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
    }
}
// MARK: - cell 代理
extension DSBankViewController {
    
}

// MARK: - footView代理
extension DSBankViewController {
    override func footViewClick(footBtn: UIButton) {
        let contactVC = DSContactViewController()
        pushToNextViewController(contactVC)
        
    }
}
