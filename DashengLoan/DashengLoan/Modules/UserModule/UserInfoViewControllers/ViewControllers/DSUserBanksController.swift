//
//  DSUserBanksController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "cellIdentifier"
class DSUserBanksController: DSTableViewController {
    
    fileprivate var userBanksInfo:DSUserBanksInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "银行卡管理"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(DSUserBanksController.addNewBank))
        configTableView()
        reloadBanksInfo()
    }
    func configTableView()  {
        tableView?.register(DSUseBankTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.rowHeight = 55
        addRefreshControl(#selector(DSUserBanksController.reloadBanksInfo))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
    @objc func addNewBank() {
        
    }
    @objc func reloadBanksInfo() {
        if self.refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSApplyDataService.getBindsBakCards {[weak self] (banksInfo,success) in
            if success {
                self?.userBanksInfo = banksInfo
                self?.tableView?.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
        
    }
}
extension DSUserBanksController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBanksInfo?.banks?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSUseBankTableViewCell
        if let bankInfo = userBanksInfo?.banks?[indexPath.row] {
            cell.logo.setImage(bankInfo.logo)
            let num = bankInfo.bank_account ?? ""
            cell.nameLabel.text = "\(bankInfo.bank_name ?? "") ****\(num)"
            cell.selectedImageView.isHidden = bankInfo.type == 1 ? false : true

            
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
