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
    fileprivate let applyInfo = DSApplyInfo()
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
            showDatePicker(minDate: nil, maxDate: nil, indexPath: indexPath)
        }
        
    }
}

// MARK: - 数据和日期选择
extension DSApplyOrderViewController {
    func inputCell(inputCell: DSInputTableViewCell, rightButtonClick rightBtn: UIButton) {
        
        let amountModel = dataSource.cellMode(indexPath: IndexPath(row: 1, section: 0))
        if amountModel.content?.count == 0 {
            XJToast.showToastAction(message: amountModel.placeholder!)
            return
        }
        let model = dataSource.cellMode(indexPath: inputCell.indexPath)
        if model.content?.count == 0 {
            XJToast.showToastAction(message: model.placeholder!)
            return
        }
        applyInfo.loanAmount = amountModel.content
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
                model.subContent = productInfo.loan_product
                 applyInfo.productInfo = productInfo
                break
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
        self.schooId = "1"
        DSApplyDataService.getOrderConfiger(oid: self.schooId) {[weak self] (configer) in
            self?.configer = configer
            if let localDataSource = self?.dataSource as? DSOrderLocalService {
                localDataSource.updateOrderConfig((self?.configer)!)
                self?.tableView?.reloadData()
            }
        }
    }
    func uploadUserOrderInfos()  {
        XJToast.showToastAction()

        var paraDic = (dataSource as! DSOrderLocalService).getOrderDataInfo()
        paraDic["oid"] = self.schooId
        DSApplyDataService.uploadUserOrderInfo(paramDic: paraDic) {
            DSApply.default.showNextStep()
        }
    }
}
extension DSApplyOrderViewController {
    override func footViewClick(footBtn: UIButton) {
        uploadUserOrderInfos()
    }
    func footViewShowTrainAgreement() {
        DSRouter.openURL(url: agreementURL)
    }
    func footViewShowDutyAgreement() {
        DSRouter.openURL(url: dutyURL)
    }
}
