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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "身份信息"
        dataSource = DSUserIdLocalService()
        loadFooterView(title: "下一步")
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    func updateUerInfo()  {
        
    }
}
extension DSUserIdViewController {
   @objc override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
        if model.title == "身份信息" {
            cell.contentTextField.textColor = UIColor.ds_blueText
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
extension DSUserIdViewController  {
    func addImage() {
        
    }
}
extension DSUserIdViewController {
    override func footViewClick(footBtn: UIButton) {
        let bankVC = DSBankViewController()
        pushToNextViewController(bankVC)
    }
}
