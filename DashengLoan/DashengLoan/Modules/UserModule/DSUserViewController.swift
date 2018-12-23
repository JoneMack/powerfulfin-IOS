//
//  DSUserViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "DSUserCellIdentifier"
fileprivate let logoutCellIdentifier = "logoutCellIdentifier"
class DSUserViewController: DSTableViewController {
    fileprivate let headerView = DSUserHeaderView()
    fileprivate let headerTopView = UIImageView()
    fileprivate let dataSource = DSUserDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderView()
        configTableView()
        DSUserCenter.defalut.addListener(self)
    }
    func loadHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 179)
        tableView?.tableHeaderView = headerView
        headerView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
            maker.height.equalTo(179)
        }
        headerView.loginAction = {[weak self] in
           self?.loginWithController(comolete: nil)
        }
        headerTopView.image = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 150))
        headerTopView.frame = CGRect(x: 0, y: -150, width: XJDeviceInfo.screenWidth, height: 151)
        tableView?.addSubview(headerTopView)
     
        addRefreshControl(#selector(DSUserViewController.reloadUserInfo))
        tableView?.sendSubviewToBack(headerTopView)
    }
    fileprivate func configTableView()  {
        tableView?.register(DSTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.register(DSLogoutTableViewCell.classForCoder(), forCellReuseIdentifier: logoutCellIdentifier)
        tableView?.rowHeight = 54
        tableView?.separatorStyle = .none
        tableView?.snp.remakeConstraints({ (maker) in
            maker.top.left.right.equalTo(0)
            maker.bottom.equalTo(-XJDeviceInfo.tabBarHeight)
        })
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
}

// MARK: - tableViewDelegate,dataSource
extension DSUserViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: logoutCellIdentifier, for: indexPath) as!  DSLogoutTableViewCell
            cell.titleLabel.text = (dataSource.cellModel(indexPath))?.text
            cell.showSpearator = false
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSTableViewCell
        let cellModel = dataSource.cellModel(indexPath)
        cell.textLabel?.text = cellModel?.text
        cell.imageView?.image = UIImage(named: (cellModel?.logo)!)
        if (indexPath.row >= dataSource.numberOfRows(indexPath.section)-1) {
             cell.showSpearator = false
        }else{
             cell.showSpearator = true
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 19.0
        }
        return 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        if let cellModel = dataSource.cellModel(indexPath) {
            perform(cellModel.action)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -150 {
            var frame = headerTopView.frame
            frame.size.height = -offsetY+1
            frame.origin.y = offsetY
            headerTopView.frame = frame
        }
    }
}

// MARK: - 获取个人信息
extension DSUserViewController:DSUserStatusListener {
    
    @objc func reloadUserInfo() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
            self.refreshControl?.endRefreshing()
        }
    }
    func userLoginSuccess() {
        tableView?.reloadData()
    }
    func userLogoutSuccess() {
        tableView?.reloadData()
    }
}

// MARK: - 页面跳转
extension DSUserViewController {
    @objc func showUserInfoViewController()  {
       
    }
    @objc fileprivate func showBankCardsViewController() {
    
    }
    @objc fileprivate func showPasswordViewController() {
        
    }
    @objc fileprivate func showMessageViewController() {
        
    }
    @objc fileprivate func showSericeViewController() {
        
    }
    @objc fileprivate func showAboutViewController() {
        
    }
    @objc fileprivate func logoutAction() {
        DSUserCenter.defalut.logout()
    }
    
}
