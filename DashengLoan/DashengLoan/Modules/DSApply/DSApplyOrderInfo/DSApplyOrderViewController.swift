//
//  DSApplyOrderViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyOrderViewController: DSApplyTableViewController {
    
    fileprivate var configer:DSUserOrderConfiger?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSOrderLocalService()
        navigationItem.title = "订单资料"
        loadFooterView(title: "完成")
        footView?.showAgreement()
        tableView?.tableFooterView = footView
        loadConfiger()
    }
}
extension DSApplyOrderViewController {
    override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
        if model.title == "分期产品" {
            if let rightCell = cell as? DSSelectorRightButtonCell {
                rightCell.rightButton.isHidden = false
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 40))
            view.backgroundColor = UIColor.white
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            view.addSubview(titleLabel)
            let name = self.configer?.org?.org_name ?? ""
            
            let attributedText = NSMutableAttributedString(string: "您正在\(name)申请培训分期", attributes: [NSAttributedString.Key.font:UIFont.ds_font(ptSize: 12),NSAttributedString.Key.foregroundColor:UIColor(hex: "777777")])
            attributedText.addAttributes([NSAttributedString.Key.font:UIFont.ds_font(ptSize: 12),NSAttributedString.Key.foregroundColor:UIColor.ds_blueText], range: NSMakeRange(3, name.count))
            
            titleLabel.attributedText = attributedText
            titleLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(15)
                maker.centerY.equalToSuperview()
            }
            return view
            
        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "场景照片" || model.title == "培训协议" || model.title == "手持身份证照片" || model.title == "声明照片" {
            let height = dataSource.heightOfMutableImageRow(atIndexPath: indexPath)
            return height
        }
        return 57
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "培训课程" {
            var titles = [String]()
            for course in configer?.course ?? [] {
                titles.append(course.class_name ?? "")
            }
            showDataPicker(dataArray: titles, mode: model, indexPath: indexPath)
        }else if model.title == "分期产品" {
            var titles = [String]()
            for course in configer?.loanProducts ?? [] {
                titles.append(course.name ?? "")
            }
            showDataPicker(dataArray: titles, mode: model, indexPath: indexPath)
        }else if model.title == "开课日期" {
            showDatePicker(minDate: Date(), maxDate: nil, indexPath: indexPath)
        }
        
    }
}

// MARK: - 数据和日期选择
extension DSApplyOrderViewController {
    func inputCell(inputCell: DSInputTableViewCell, rightButtonClick rightBtn: UIButton) {
        
        let amountModel = dataSource.cellMode(indexPath: IndexPath(row: 1, section: 0))
        
        if amountModel.content == nil || amountModel.content?.isEmpty == true || amountModel.content?.count == 0 {
            XJToast.showToastAction(message: amountModel.placeholder!)
            return
        }
        let model = dataSource.cellMode(indexPath: inputCell.indexPath)
        if model.content == nil || model.content?.isEmpty == true || model.content?.count == 0  {
            XJToast.showToastAction(message: model.placeholder!)
            return
        }
     getLoanSimpleInfo(money: amountModel.content!, productId: model.subContent!)
        
    }
    fileprivate func showApplyInfoAlertView(_ applyInfo:DSApplyInfo) {
        let alertView =  DSApplyInfoAlertView()
        alertView.applyInfo = applyInfo
        alertView.showAlertController(from: self)
    }
   fileprivate func showDataPicker(dataArray:[String],mode:DSInputModel,indexPath:IndexPath)  {
        let dataPicker = XJDataPicker()
        dataPicker.dataArray = dataArray
        dataPicker.selectIndex = dataArray.index(of:mode.content ?? "")
        dataPicker.showAlertController(from: self)
        dataPicker.selectData = { [weak self] (data) in
            mode.content = data
            self?.updataModelDataInfo(indexPath)
            self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
    }
   fileprivate func updataModelDataInfo(_ indexPath:IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "培训课程" {
            for course in configer?.course ?? [] {
                if course.class_name == model.content {
                    model.subContent = course.cid?.description
                    break
                }
            }
        }else if model.title == "分期产品" {
            for productInfo in configer?.loanProducts ?? [] {
                if productInfo.name == model.content {
                    model.subContent = productInfo.loan_product
                    break
                }
            }
        }
    }
    fileprivate func showDatePicker(minDate:Date?,maxDate:Date?,indexPath:IndexPath) {
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
extension DSApplyOrderViewController {
    /// 获取配置信息
    func loadConfiger()  {
        XJToast.showToastAction()
        DSApplyDataService.getOrderConfiger(oid: self.schooId) {[weak self] (configer) in
            self?.configer = configer
            if let localDataSource = self?.dataSource as? DSOrderLocalService {
                localDataSource.updateOrderConfig((self?.configer)!)
                self?.tableView?.reloadData()
            }
        }
    }
    func getLoanSimpleInfo(money:String,productId:String)  {
        XJToast.showToastAction()
        DSApplyDataService.getLoanSimpleInfo(money: money, productId: productId) {[weak self] (applyInfo) in
            self?.showApplyInfoAlertView(applyInfo)
        }
    }
    func uploadUserOrderInfos()  {
        
        XJToast.showToastAction()
        var paraDic = (dataSource as! DSOrderLocalService).getOrderDataInfo()
        paraDic["oid"] = self.schooId
        DSApplyDataService.uploadUserOrderInfo(paramDic: paraDic) {[weak self] (successInfo) in
            self?.showSuccessView(successInfo)
        }
    }
}
extension DSApplyOrderViewController {
    override func footViewClick(footBtn: UIButton) {
        if footView?.trainButton?.isSelected == false {
            XJToast.showToastAction(message: "请先阅读以及同意分期贷款培训协议")
            return
        }
        if footView?.dutyButton?.isSelected == false {
            XJToast.showToastAction(message: "请先阅读以及同意数字证书申请及使用责任书")
            return
        }
        uploadUserOrderInfos()
    }
    fileprivate func showSuccessView(_ successInfo:DSApplySuccessInfo){
        let amountModel = dataSource.cellMode(indexPath: IndexPath(row: 1, section: 0))
        let produceModel = dataSource.cellMode(indexPath: IndexPath(row: 2, section: 0))
        var sucInfo = successInfo
        sucInfo.account = amountModel.content
        sucInfo.product_name = produceModel.content
        let successView = DSApplySuccessController()
        successView.successInfo = sucInfo
        pushToNextViewController(successView)
    }
    func footViewShowTrainAgreement() {
        DSRouter.openURL(url: agreementURL)
    }
    func footViewShowDutyAgreement() {
        DSRouter.openURL(url: dutyURL)
    }
}
