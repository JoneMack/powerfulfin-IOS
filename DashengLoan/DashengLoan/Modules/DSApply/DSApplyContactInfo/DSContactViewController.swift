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
    fileprivate var addressPicker :DSAddressPicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "联络信息"
        dataSource = DSContactLocalService()
        loadFooterView(title: "下一步")
        
        addressPicker = DSAddressPicker()
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
            addressPicker?.tipsTitle = "请选择省市区"
            addressPicker?.showAlertController(from: self)
        }
    }
}

// MARK: - DataPicker,AddressPicker
extension DSContactViewController {
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
}
extension DSContactViewController {
    
    /// 获取配置信息
    func loadConfiger()  {
        
        DSApplyDataService.getApplyConifer(part: 3) {[weak self] (configer) in
            self?.applyConfiger = configer
        }
    }
    func loadUserContactInfoFromService()  {
        
    }
}
extension DSContactViewController {
    override func footViewClick(footBtn: UIButton) {
        let workVC = DSWorkViewController()
        pushToNextViewController(workVC)
        
    }
}

