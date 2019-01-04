//
//  DSContactViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSContactViewController: DSApplyTableViewController {

    fileprivate var applyConfiger :DSApplyConfiger?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联络信息"
        dataSource = DSContactLocalService()
        loadFooterView(title: "下一步")
        
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
            showDataPicker(dataArray: applyConfiger?.relations ?? [], mode: model, indexPath: indexPath)
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
    func showDataPicker(dataArray:[String],mode:DSInputModel,indexPath:IndexPath)  {
        DispatchQueue.main.async {
            let dataPicker = XJDataPicker()

            dataPicker.dataArray = dataArray
            dataPicker.selectIndex = dataArray.index(of:mode.content ?? "")
            dataPicker.showAlertController(from: self)
            dataPicker.selectData = { [weak self] (data) in
                mode.content = data
                self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    func addressPicker(_ addressPicker: DSAddressPicker, didSelectedAddress province: DSAddress, city: DSAddress, area: DSAddress) {
        (dataSource as! DSContactLocalService).addressInfo.province = province.areaid?.description ?? ""
        (dataSource as! DSContactLocalService).addressInfo.city = city.areaid?.description ?? ""
        (dataSource as! DSContactLocalService).addressInfo.area = area.areaid?.description ?? ""
        (dataSource as! DSContactLocalService).addressInfo.address = area.joinname ?? ""
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
        XJToast.showToastAction()
        let paraDic = dataSource.getDataInfo()
        DSApplyDataService.uploadUserContact(contactInfo: paraDic) {
            DSApply.default.showNextStep()
        }
    }
    
}
extension DSContactViewController {
    override func footViewClick(footBtn: UIButton) {
        uploadUserContactInfoToService()
    }
}

