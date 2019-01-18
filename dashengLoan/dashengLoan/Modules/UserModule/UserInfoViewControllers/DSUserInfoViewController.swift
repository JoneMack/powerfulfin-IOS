//
//  DSUserInfoViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUseIdInfoModel : NSObject {
    var logo:String?
    var title:String?
    var detail:String?
    /// 1:待完成OR未认证，2：认证成功；3：认证失败
    var status:Int = 1
    convenience init(logo:String,title:String,detail:String) {
        self.init()
        self.logo = logo
        self.title = title
        self.detail = detail
    }
}
private let cellIdentifier = "cellIdentifier"
class DSUserInfoViewController: DSTableViewController {
    var dataArray:[DSUseIdInfoModel] = []
    var userStatusInfo :DSUserApplyStatusInfo?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadStatusFormServce()
    }
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
        addRefreshControl(#selector(DSUserInfoViewController.reloadStatusFormServce))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
}
extension DSUserInfoViewController {
  
    fileprivate func loadLocalStatusData() {
        let nameModel = DSUseIdInfoModel(logo: "user_icon_1", title: "身份信息", detail: "姓名、身份证号、人脸识别")
        let bankModel = DSUseIdInfoModel(logo: "user_icon_2", title: "银行卡", detail: "本人名下用于还款的银行卡")
        let contactModel = DSUseIdInfoModel(logo: "user_icon_3", title: "联络信息", detail: "本人联系方式及紧急联系人")

        let degreeModel = DSUseIdInfoModel(logo: "user_icon_4", title: "学历及职业", detail: "最高学历以及目前工作情况")
        let locationModel = DSUseIdInfoModel(logo: "user_icon_5", title: "当前位置", detail: "请授权允许获取您的当前位置")
        let bookModel = DSUseIdInfoModel(logo: "user_icon_6", title: "设备信息", detail: "请授权允许获取您的手机通讯录")

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
        
        cell.isComplete =  model.status == 2 ? true : false
        if indexPath.row < 5 {
            cell.showSpearator = true
        }else{
            cell.showSpearator = false
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)

        if userStatusInfo?.user_loaning  ==  true {
            XJToast.showToastAction(message: "您有审核中的订单，在审核结束前，无法修改个人资料")
            return
        }
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
extension DSUserInfoViewController {
   @objc fileprivate func reloadStatusFormServce()  {
        if self.refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSApplyDataService.getUserStatus { [weak self] (statusInfo, success) in
            if success {
                self?.userStatusInfo = statusInfo
                self?.reloadLocalData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    fileprivate func reloadLocalData() {
        for mode in  dataArray {
            if mode.title == "身份信息" {
                mode.status = userStatusInfo?.user_real ?? 1
            }else if mode.title == "银行卡" {
                mode.status = userStatusInfo?.user_bank ?? 1
            }else if mode.title == "联络信息" {
                mode.status = userStatusInfo?.user_real ?? 1
            }else if mode.title == "学历及职业" {
                mode.status = userStatusInfo?.user_work ?? 1
            }else if mode.title == "当前位置" {
                if DSLocationManager.manager.authStatus == .authorizedAlways || DSLocationManager.manager.authStatus == .authorizedWhenInUse {
                    mode.status = 2
                }else if  DSLocationManager.manager.authStatus == .denied {
                    mode.status = 3
                }else {
                   mode.status = 1
                }
            }else if mode.title == "通讯录" {
                mode.status = userStatusInfo?.user_phonebook ?? 1
            }
        }

        tableView?.reloadData()

    }
}
