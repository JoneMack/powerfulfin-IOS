//
//  DSBankListViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "cellIdentifier"
class DSBankListViewController: DSTableViewController {
    var banksInfo: DSUserBanksInfo?
    var footView:DSApplyFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "银行卡"
        configTableView()
        loadFooterView(title: "下一步")
    }
    func configTableView()  {
        tableView?.register(DSApplyBankCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.rowHeight = 55
    }
    func loadFooterView(title:String)  {
        footView = DSApplyFooterView(title: title)
        footView?.delegate = self
        tableView?.tableFooterView = footView
    }
}
extension DSBankListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banksInfo?.banks?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSApplyBankCell
        cell.selectionStyle = .none
        if let bankInfo = banksInfo?.banks?[indexPath.row] {
            cell.logo.setImage(bankInfo.logo)
            let num = bankInfo.bank_account ?? ""
            cell.nameLabel.text = "\(bankInfo.bank_name ?? "") ****\(num)"
        }
        return cell
    }
}
extension DSBankListViewController : DSApplyFooterViewDelegate {
    func footViewClick(footBtn: UIButton) {
        DSApply.default.showNextStep()
    }
}
