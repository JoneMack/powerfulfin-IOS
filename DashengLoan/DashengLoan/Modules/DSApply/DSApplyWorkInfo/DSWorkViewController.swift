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
    override func configTableView() {
        super.configTableView()
        tableView?.register(DSWorkHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "headerId")
    }
}
extension DSWorkViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! DSWorkHeaderView
           headerView.delegate = self
            let index = (dataSource as! DSWorkLocalService).cuttentIndex
            headerView.segmentControl?.endMoveTo(index: index)
            return headerView
        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 1 {
            return 128.0
        }
        return 0.01
    }
}
extension DSWorkViewController:DSWorkHeaderViewDelegate {
    func headerView(_ headerView: DSWorkHeaderView, selectedInex index: Int) {
        
        (dataSource as! DSWorkLocalService).changeItem(index: index)
        tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
}
extension DSWorkViewController {
    override func footViewClick(footBtn: UIButton) {
        let orderVC = DSApplyOrderViewController()
        pushToNextViewController(orderVC)
    }
}
