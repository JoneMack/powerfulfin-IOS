//
//  DSWorkViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSWorkViewController: DSApplyTableViewController {
    
    fileprivate var applyConfiger :DSApplyConfiger?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSWorkLocalService()
        navigationItem.title = "学历及职业"
        if hasNext {
            loadFooterView(title: "下一步")
        }else{
            loadFooterView(title: "提交")
        }
        loadConfiger()
        loadUserWorkInfo()
    }
    override func configTableView() {
        super.configTableView()
        tableView?.register(DSWorkHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "headerId")
    }
}
extension DSWorkViewController {
    override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
       if model.title == "月收入" || model.title == "家庭月收入" || model.title == "机构电话" {
            cell.showSpearator = true
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! DSWorkHeaderView
           headerView.delegate = self
            let index = (dataSource as! DSWorkLocalService).cuttentIndex - 1
            headerView.segmentControl?.endMoveTo(index: index)
            return headerView
        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 1 {
            return 128.0
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 0{
            return 140
        }
        return 57
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "学历" {
            showDataPicker(dataArray: applyConfiger?.highest_education ?? [], mode: model, indexPath: indexPath)

        }else if model.title == "职业" {
            showDataPicker(dataArray: applyConfiger?.profession ?? [], mode: model, indexPath: indexPath)
        }else if model.title == "职位名称" {
            showDataPicker(dataArray: applyConfiger?.work_profession ?? [], mode: model, indexPath: indexPath)
        }else if model.title == "所在地" {
            let addressPicker = DSAddressPicker()
            addressPicker.delegate = self
            addressPicker.tipsTitle = "请选择省市区"
            addressPicker.showAlertController(from: self)
        }else if model.title == "入职日期" {
            let years:Double = 70
            let yearSecond:Double = 24*60*60*365
            let totle :Double = -years * yearSecond            
            let minDate = Date(timeIntervalSinceNow: TimeInterval(totle))
            showDatePicker(minDate: minDate, maxDate: Date(), indexPath: indexPath)
        }
    }
}


// MARK: - 日期选择
extension DSWorkViewController {
    func showDataPicker(dataArray:[String],mode:DSInputModel,indexPath:IndexPath)  {
        DispatchQueue.main.async {
            let dataPicker = XJDataPicker()
            
            dataPicker.dataArray = dataArray
            dataPicker.selectIndex = dataArray.index(of:mode.content ?? "")
            dataPicker.showAlertController(from: self)
            dataPicker.selectData = { [weak self] (data) in
                mode.content = data
                self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
                if mode.title == "职业" && data == "学生" {
                    (self?.dataSource as! DSWorkLocalService).changeItem(index: 1)
                    self?.tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            }
        }
    }
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

// MARK: -  状态切换以及地址选择
extension DSWorkViewController:DSWorkHeaderViewDelegate,DSAddressPickerDelegate {
   
    func headerView(_ headerView: DSWorkHeaderView, selectedInex index: Int) {
        
        (dataSource as! DSWorkLocalService).changeItem(index: index)
        tableView?.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    func addressPicker(_ addressPicker: DSAddressPicker, didSelectedAddress province: DSAddress, city: DSAddress, area: DSAddress) {
        if let localDataSource = dataSource as? DSWorkLocalService {
            localDataSource.workAddress.province = province.areaid?.description ?? ""
            localDataSource.workAddress.city = city.areaid?.description ?? ""
            localDataSource.workAddress.area = area.areaid?.description ?? ""
            localDataSource.workAddress.address = area.joinname ?? ""
            localDataSource.updateWordAddress()
            tableView?.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        }
    }
}

// MARK: - 网络请求
extension DSWorkViewController {
    /// 获取配置信息
    func loadConfiger()  {
        XJToast.showToastAction()
        DSApplyDataService.getApplyConifer(part: 4) {[weak self] (configer) in
            self?.applyConfiger = configer
        }
    }
    func loadUserWorkInfo()  {
        XJToast.showToastAction()
        DSApplyDataService.getUserWork {[weak self] (workInfo) in
            self?.dataSource.reloadData(info: workInfo)
            self?.tableView?.reloadData()
        }
    }
    func uploadUserWorkInfo()  {
        XJToast.showToastAction()
        let paraDic = dataSource.getDataInfo()
        DSApplyDataService.uploadUserWork(workInfo: paraDic) {[weak self] in
            if self?.hasNext == true {
                DSApply.default.showNextStep()
            }else{
                self?.popViewController()
            }
        }
    }
}
extension DSWorkViewController {
    override func footViewClick(footBtn: UIButton) {
        uploadUserWorkInfo()
    }
}
