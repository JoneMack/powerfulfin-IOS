//
//  DSUserInfoViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

struct DSUseIdInfoModel {
    var logo:String?
    var title:String?
    var detail:String?
}
private let cellIdentifier = "cellIdentifier"
class DSUserInfoViewController: DSTableViewController {
    var dataArray:[DSUseIdInfoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人资料"
        loadLocalStatusData()
        configTableView()
    }
    func configTableView() {
        tableView?.rowHeight = 76
        tableView?.separatorStyle = .none
        tableView?.register(DSUserIdTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        addRefreshControl(#selector(DSUserInfoViewController.reloadStatusData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
}
extension DSUserInfoViewController {
    @objc func reloadStatusData()  {
        self.refreshControl?.endRefreshing()
    }
    fileprivate func loadLocalStatusData() {
        let nameModel = DSUseIdInfoModel(logo: "user_icon_1", title: "身份信息", detail: "姓名、身份证、人脸识别等")
        let bankModel = DSUseIdInfoModel(logo: "user_icon_2", title: "银行卡", detail: "用于还款的银行卡")
        let contactModel = DSUseIdInfoModel(logo: "user_icon_3", title: "联络信息", detail: "能够联系到您的其他相关人员")

        let degreeModel = DSUseIdInfoModel(logo: "user_icon_4", title: "学历及职业", detail: "最高学历以及目前工作情况")
        let locationModel = DSUseIdInfoModel(logo: "user_icon_5", title: "当前位置", detail: "请授权允许获取您的当前位置")
        let bookModel = DSUseIdInfoModel(logo: "user_icon_6", title: "通讯录", detail: "请授权允许获取您的手机通讯录")

        dataArray.append(nameModel)
        dataArray.append(bankModel)
        dataArray.append(contactModel)
        dataArray.append(degreeModel)
        dataArray.append(locationModel)
        dataArray.append(bookModel)
    }
}
extension DSUserInfoViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSUserIdTableViewCell
        let model = dataArray[indexPath.row]
        
        cell.logoImageView.image = UIImage(named: model.logo!)
        cell.titleLabel.text = model.title
        cell.detailLabel.text = model.detail
        
        cell.isComplete =  indexPath.row % 2 == 1 ? true : false
        if indexPath.row < 5 {
            cell.showSpearator = true
        }else{
            cell.showSpearator = false
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        var theVC:UIViewController!
        if indexPath.row == 0 {
            theVC =  DSUserIdViewController()
            (theVC as! DSUserIdViewController).hasNext = false
        }else if indexPath.row == 1 {
            theVC =  DSUserBanksController()
        }else if indexPath.row == 2 {
            theVC =  DSContactViewController()
            (theVC as! DSContactViewController).hasNext = false
        }else if indexPath.row == 3 {
            theVC =  DSWorkViewController()
            (theVC as! DSWorkViewController).hasNext = false
        }else if indexPath.row == 4 {
            theVC =  DSLocationViewController()
            (theVC as! DSLocationViewController).hasNext = false
        }else if indexPath.row == 5 {
            theVC =  DSPhoneViewController()
            (theVC as! DSPhoneViewController).hasNext = false
        }
        pushToNextViewController(theVC)
    }
    
}
