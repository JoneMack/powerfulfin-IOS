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
    fileprivate var imageIdPicker : XJImagePicker?
    var orderId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "身份信息"
        dataSource = DSUserIdLocalService()
        if hasNext {
            loadFooterView(title: "下一步")
        }else{
            loadFooterView(title: "提交")
        }
        loadUserIdInfo()
        imageIdPicker = XJImagePicker()
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    override func uploadImageSuccess(_ imageInfo: DSUploaderImageInfo) {
        if imageInfo.index == 0 {
            userIdInfo?.idcard_information_pic = imageInfo.imageInfo?.path
            userIdInfo?.idcard_information_pic_url = imageInfo.imageInfo?.url
        }else{
            userIdInfo?.idcard_national_pic = imageInfo.imageInfo?.path
            userIdInfo?.idcard_national_pic_url = imageInfo.imageInfo?.url
        }
        tableView?.reloadData()
       
    }
    func updateUserIdInfo(userInfo:DSUserIdInfo)  {
        self.userIdInfo = userInfo
        dataSource.reloadData(info: userInfo)
        tableView?.reloadData()
    }
    func reloadUserIdPic() {
        loadPicCount = 0
        loadUserIdImageFromService(false)
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
            if hasNext == false {
//                DSApply.default.beginController = self
            }
            DSApply.default.beginAuthFace()
        }
        if model.title == "有限期限" {
            let years:Double = 70
            let yearSecond:Double = 24*60*60*365
            let totle :Double = -years * yearSecond
            
            let minDate = Date(timeIntervalSinceNow: TimeInterval(totle))
            
           showDatePicker(minDate: minDate, maxDate: Date(), indexPath: indexPath)
        }else if model.title?.isEmpty == true || model.title == nil {
            let second = 24*60*60
            let minDate = Date(timeIntervalSinceNow: TimeInterval(second))
            showDatePicker(minDate: minDate, maxDate: nil, indexPath: indexPath)
        }
    }
}

// MARK: - 图片选择和上传
extension DSUserIdViewController {
    func uploadIdCardImage(isFace: Bool, indexPath: IndexPath) {
        
        let placeholder = isFace ? "apply_help_1" : "apply_help_2"
        
        var imageInfo = DSUploaderImageInfo()
        imageInfo.servicename = isFace ? "idcard_information_pic" : "idcard_national_pic"
        imageInfo.index = isFace ? 0 : 1
        imageInfo.indexPath = indexPath
        
        imageIdPicker?.ds_showImagePicker(placeholder: placeholder, complete: {[weak self] (images, datas) in
            if let data = datas.first {
                imageInfo.data = data
                self?.uploadImageToService(imageInfo: imageInfo)
            }
        })
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
                if userIdInfo.user_real == 1 {
                    DSApply.default.beginAuthFace()
                }
                self?.updateUserIdInfo(userInfo: userIdInfo)
            }
        }
    }
  
    
    fileprivate func loadUserIdImageFromService(_ uploadAll:Bool){
        
        DSApplyDataService.getUserIdPic(order: self.orderId ?? "") {[weak self] (success, userInfo) in
            if success {
                self?.userIdInfo?.idcard_national_pic = userInfo!.idcard_national_pic
                self?.userIdInfo?.idcard_national_pic_url = userInfo!.idcard_national_pic_url
                self?.userIdInfo?.idcard_information_pic = userInfo!.idcard_information_pic
                self?.userIdInfo?.idcard_information_pic_url = userInfo!.idcard_information_pic_url
                self?.tableView?.reloadData()
                if uploadAll {
                    self?.footViewClick(footBtn: (self?.footView?.footBtn)!)
                }
            }else{
                self?.loadPicCount += 1
                if self?.loadPicCount ?? 3 < 3 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                        self?.loadUserIdImageFromService(uploadAll)
                    })
                }
            }
        }
    }
    fileprivate func uploadUserIdInfo(complete:@escaping(()->Void)) {
        
        let checker = dataSource.checkUploadParameters(true)
        if checker.canUpload == false {
            return
        }
        if self.userIdInfo?.idcard_information_pic == nil || self.userIdInfo?.idcard_information_pic?.isEmpty == true {
            if loadPicCount > 0 && self.orderId != nil && self.orderId?.isEmpty == false {
                loadPicCount = 0
                XJToast.showToastAction()
                loadUserIdImageFromService(true)
            }else{
                XJToast.showToastAction(message: "请重新选择上传身份证正面照")
            }
            return
        }
        if self.userIdInfo?.idcard_national_pic == nil || self.userIdInfo?.idcard_national_pic?.isEmpty == true {
            XJToast.showToastAction(message: "请重新选择上传身份证反面照")
            return
        }
        var paraDic = checker.paramters as! [String :String]
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
        uploadUserIdInfo {[weak self] in
            if self?.hasNext == true {
                DSApply.default.showNextStep()
            }else{
                self?.popViewController()
            }
        }
    }
}
