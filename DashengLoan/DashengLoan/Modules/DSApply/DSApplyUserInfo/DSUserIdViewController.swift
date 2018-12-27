//
//  DSUserIdViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "cellIdentifier"
/// 用户身份资料
class DSUserIdViewController: DSApplyTableViewController {
    fileprivate var userIdInfo:DSUserIdInfo?
    fileprivate var loadPicCount = 0
    var orderId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "身份信息"
        dataSource = DSUserIdLocalService()
        loadFooterView(title: "下一步")
        loadUserIdInfo()
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    
    func updateUserIdInfo(userInfo:DSUserIdInfo)  {
        self.userIdInfo = userInfo
        dataSource.reloadData(info: userInfo)
        tableView?.reloadData()
    }
    func reloadUserIdPic() {
        loadPicCount = 0
        loadUserIdImageFromService()
    }
    
}
extension DSUserIdViewController {
   @objc override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
        if model.title == "人脸识别" {
           cell.accessoryView = nil
        }
        if model.title == "身份证照"   {
            if let idCell = cell as? DSIdImageCell {
                idCell.idUpImageView?.setImage(userIdInfo?.idcard_information_pic_url, placeholderImage: UIImage(named: "loan_idcard_front"))
                idCell.idDownImageView?.setImage(userIdInfo?.idcard_national_pic_url, placeholderImage: UIImage(named: "loan_idcard_back"))
            }
        }
        if model.title == "身份信息" {
            cell.contentTextField.textColor = UIColor.ds_redText
        }else{
            cell.contentTextField.textColor = UIColor.ds_blackText
        }
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 8 { return 150.0 }
        return 57.0
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "身份信息" {
            DSApply.default.beginAuthFace()
        }
        if model.title == "有限期限" {
            let years = 70
            let yearSecond = 24*60*60*365
            let totle = -years * yearSecond
            
            let minDate = Date(timeIntervalSinceNow: TimeInterval(totle))
            
           showDatePicker(minDate: minDate, maxDate: Date(), indexPath: indexPath)
        }else if model.title?.isEmpty == true || model.title == nil {
            let second = 24*60*60
            let minDate = Date(timeIntervalSinceNow: TimeInterval(second))
            showDatePicker(minDate: minDate, maxDate: nil, indexPath: indexPath)
        }
    }
}
// MARK: - 时间选择器
extension DSUserIdViewController {
    func showDatePicker(minDate:Date?,maxDate:Date?,indexPath:IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)

        let datePicker = DSDatePicker()
        if model.content != nil && model.content?.isEmpty == false {
            datePicker.beginDate = Date.date(model.content!)
        }
        datePicker.minDate = minDate
        datePicker.maxDate = maxDate
        datePicker.selectDateFinish = {[weak self] (dateString) in
            model.content = dateString
            self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
        datePicker.showAlertController(from: self)
    }
}

// MARK: - 网络请求
extension DSUserIdViewController  {
    fileprivate func loadUserIdInfo()  {
        XJToast.showToastAction()
        DSApplyDataService.getUserIdInfo {[weak self] (userIdInfo) in
            DispatchQueue.main.async {
                XJToast.hiddenToastAction()
                self?.updateUserIdInfo(userInfo: userIdInfo)
            }
        }
    }
  
    
    fileprivate func loadUserIdImageFromService(){
        
        DSApplyDataService.getUserIdPic(order: self.orderId ?? "") {[weak self] (success, userInfo) in
            if success {
                self?.userIdInfo?.idcard_national_pic = userInfo!.idcard_national_pic
                self?.userIdInfo?.idcard_national_pic_url = userInfo!.idcard_national_pic_url
                self?.userIdInfo?.idcard_information_pic = userInfo!.idcard_information_pic
                self?.userIdInfo?.idcard_information_pic_url = userInfo!.idcard_information_pic_url
                self?.tableView?.reloadData()
            }else{
                self?.loadPicCount += 1
                if self?.loadPicCount ?? 3 < 3 {
                    self?.loadUserIdImageFromService()
                }
            }
        }
    }
    fileprivate func uploadUserIdInfo(complete:@escaping(()->Void)) {
        var paraDic = dataSource.getDataInfo()
        paraDic["udcredit_order"] = orderId ?? ""
        paraDic["idcard_information_pic"] = self.userIdInfo?.idcard_information_pic
        paraDic["idcard_national_pic"] = self.userIdInfo?.idcard_national_pic
        XJToast.showToastAction()
        DSApplyDataService.uploadUserIdInfo(info: paraDic) { (success) in
            XJToast.hiddenToastAction()
            if success {
                complete()
            }
        }
    }
}
extension DSUserIdViewController {
    override func footViewClick(footBtn: UIButton) {
        uploadUserIdInfo {
            DSApply.default.showNextStep()
        }
//        let bankVC = DSBankViewController()
//        pushToNextViewController(bankVC)
    }
}
