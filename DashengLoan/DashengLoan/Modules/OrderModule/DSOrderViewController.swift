//
//  DSOrderViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "cellIdentifier"

class DSOrderViewController: DSTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    func configTableView() {
        tableView?.register(DSOrderTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.rowHeight = 112
        tableView?.separatorStyle = .none
        
        tableView?.snp.remakeConstraints({ (maker) in
            maker.top.left.right.equalTo(0)
            maker.bottom.equalTo(-XJDeviceInfo.tabBarHeight)
        })
        addRefreshControl(#selector(DSOrderViewController.loadOrederListData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
}
extension DSOrderViewController {
    @objc func loadOrederListData()  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
            self.refreshControl?.endRefreshing()
        }
    }
}
extension DSOrderViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSOrderTableViewCell
        cell.orderNumLabel?.text = "订单编号：326005861"
        cell.statusLabel?.text = "已放款"
        cell.organizationNameLabel?.text = "翡翠教育（北京亚太新创网络有限公司）"
        cell.moenyLabel?.text = "￥14,400.00"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 0.01
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9.0
    }
}
