//
//  DSContactViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSContactViewController: DSApplyTableViewController {

    lazy var addressBookPicker = DSAddressBookPicker()
    
    fileprivate var applyConfiger :DSApplyConfiger?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联络信息"
        dataSource = DSContactLocalService()
        if hasNext {
            loadFooterView(title: "下一步")
        }else{
            loadFooterView(title: "提交")
        }
        loadConfiger()
        loadUserContactInfoFromService()
    }
}
extension DSContactViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "住房情况" {
         showDataPicker(dataArray: applyConfiger?.housing_situation ?? [], mode: model, indexPath: indexPath)
        }else if model.title == "婚姻状况" {
            showDataPicker(dataArray: applyConfiger?.marital_status ?? [], mode: model, indexPath: indexPath)
        }else if model.title == "关系" {
            let marrageModel = dataSource.cellMode(indexPath: IndexPath(row: 0, section: 2))
            if marrageModel.content?.contains("已婚") == true {
                XJToast.showToastAction(message: "已婚情况下，只能填写配偶信息")
                return
            }else{
                showDataPicker(dataArray: applyConfiger?.relations ?? [], mode: model, indexPath: indexPath)
            }
        }else if model.title == "现居地址" {
            let addressPicker = DSAddressPicker()
            addressPicker.delegate = self
            addressPicker.tipsTitle = "请选择省市区"
            addressPicker.showAlertController(from: self)
        }
    }
}

// MARK: - DataPicker,AddressPicker
extension DSContactViewController:DSAddressPickerDelegate {
    func inputCell(inputCell: DSInputTableViewCell, rightButtonClick rightBtn: UIButton) {
        let indexPath = inputCell.indexPath!
        let model = dataSource.cellMode(indexPath: indexPath)
        let nameIndexPath = IndexPath(row: 1, section: 2)
        
        let nameModel = dataSource.cellMode(indexPath: nameIndexPath)
        
        if model.title == "手机号码" {
            addressBookPicker.presentPage(onTarget: self) {[weak self] (contact) in
                model.content = contact.phone
                nameModel.content = contact.name
                self?.tableView?.reloadRows(at: [indexPath,nameIndexPath], with: .automatic)
            }

        }
        
    }
    func showDataPicker(dataArray:[String],mode:DSInputModel,indexPath:IndexPath)  {
        DispatchQueue.main.async {
            let dataPicker = XJDataPicker()

            dataPicker.dataArray = dataArray
            dataPicker.selectIndex = dataArray.index(of:mode.content ?? "")
            dataPicker.showAlertController(from: self)
            dataPicker.selectData = { [weak self] (data) in
                mode.content = data
                self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
                if mode.title == "婚姻状况" && data.contains("已婚") {
                    let relationIndex = IndexPath(row: 2, section: 2)
                    let relationModel = self?.dataSource.cellMode(indexPath:relationIndex )
                    relationModel?.content = "配偶"
                    self?.tableView?.reloadRows(at: [relationIndex], with: .automatic)

                }
            }
        }
    }
    func addressPicker(_ addressPicker: DSAddressPicker, didSelectedAddress province: DSAddress, city: DSAddress, area: DSAddress) {
        (dataSource as! DSContactLocalService).addressInfo.province = province.areaid?.description ?? ""
        (dataSource as! DSContactLocalService).addressInfo.city = city.areaid?.description ?? ""
        (dataSource as! DSContactLocalService).addressInfo.area = area.areaid?.description ?? ""
        
        var name = area.joinname
        name = name?.replacingOccurrences(of: ",", with: "-")
        (dataSource as! DSContactLocalService).addressInfo.address = name ?? ""
        (dataSource as! DSContactLocalService).updateHomeAddress()
        self.tableView?.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        
    }
}

// MARK: - 网络请求
extension DSContactViewController {
    
    /// 获取配置信息
    func loadConfiger()  {
        XJToast.showToastAction()
        DSApplyDataService.getApplyConifer(part: 3) {[weak self] (configer) in
            self?.applyConfiger = configer
        }
    }
    /// 获取联系人信息
    func loadUserContactInfoFromService()  {
        XJToast.showToastAction()
        DSApplyDataService.getUserContact {[weak self] (userContactInfo) in
            self?.dataSource.reloadData(info: userContactInfo)
            self?.tableView?.reloadData()
            
        }
    }
    func uploadUserContactInfoToService()  {
        let checker = dataSource.checkUploadParameters(true)
        if checker.canUpload == false {
            return
        }
        XJToast.showToastAction()
        let paraDic = checker.paramters as! [String:String]
        DSApplyDataService.uploadUserContact(contactInfo: paraDic) {[weak self] in
            if self?.hasNext == true {
                DSApply.default.showNextStep()
            }else{
                self?.popViewController()
            }
        }
    }
    
}
extension DSContactViewController {
    override func footViewClick(footBtn: UIButton) {
        uploadUserContactInfoToService()
    }
}

