//
//  DSApplyOrderViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyOrderViewController: DSApplyTableViewController {
    
    fileprivate var configer:DSUserOrderInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSOrderLocalService()
        navigationItem.title = "订单资料"
        loadFooterView(title: "完成")
        loadConfiger()
    }

}
extension DSApplyOrderViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row > 0 {
//            let count = (dataSource as! DSOrderLocalService).imagesArray.count
            return DSMutableImageCell.heightOfRow(count: 2)
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
extension DSApplyOrderViewController {
    func showDataPicker(dataArray:[String],mode:DSInputModel,indexPath:IndexPath)  {
        let dataPicker = XJDataPicker()
        dataPicker.dataArray = dataArray
        dataPicker.selectIndex = dataArray.index(of:mode.content ?? "")
        dataPicker.showAlertController(from: self)
        dataPicker.selectData = { [weak self] (data) in
            mode.content = data
            self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
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
// MARK: - 网络请求
extension DSApplyOrderViewController {
    /// 获取配置信息
    func loadConfiger()  {
        self.schooId = "1"
        DSApplyDataService.getOrderConfiger(oid: self.schooId) {[weak self] (configer) in
            self?.configer = configer
        }
    }
}
