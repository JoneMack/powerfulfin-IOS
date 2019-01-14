//
//  DSDatePicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let pickerViewHeight :CGFloat = 256.0
private let barViewHeight :CGFloat = 45.0
class DSDatePicker: KZAlertController {
    var minDate:Date? {
        didSet {
            datePicker.minimumDate = minDate
        }
    }
    var maxDate:Date? {
        didSet {
            datePicker.maximumDate = maxDate
        }
    }
    
    var beginDate:Date? {
        didSet {
            datePicker.date = beginDate ?? Date()
        }
    }
    var datePickerMode:UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = datePickerMode
        }
    }
    var selectDateFinish:((String) -> Void)?
    
    
    fileprivate var datePicker = UIDatePicker()
    
    fileprivate var contentSizie :CGSize {
        return CGSize(width: XJDeviceInfo.screenWidth, height: pickerViewHeight+barViewHeight+XJDeviceInfo.tabbarSpaceInX)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
    }
    override func configContentView() {
        contentView.alertAnimation = KZAlertStyleActionSheet(contentView: contentView)
        contentView.alertAnimation.targetSize = contentSizie
        contentView.viewWillDisappear(false)
    }
    func loadSubViews()  {
        let toolView = UIView()
        toolView.backgroundColor = UIColor(R: 240, G: 240, B: 240)
        contentView.addSubview(toolView)
        toolView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
            maker.height.equalTo(barViewHeight)
        }
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.addTarget(self, action: #selector(DSDatePicker.cancelAction), for: .touchUpInside)
        cancelBtn.setTitleColor(UIColor.ds_blackText, for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.ds_font(ptSize: 14)
        toolView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(0)
            maker.width.equalTo(60)
        }
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.addTarget(self, action: #selector(DSDatePicker.makeSureDate), for: .touchUpInside)
        sureBtn.setTitleColor(UIColor.ds_blackText, for: .normal)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.titleLabel?.font = UIFont.ds_font(ptSize: 14)
        toolView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalTo(0)
            maker.width.equalTo(60)
        }
        let lineView = UIView.lineView()
        toolView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(toolView.snp.bottom).offset(0)
            maker.height.equalTo(pickerViewHeight)
        }
    }
}
extension DSDatePicker {
    @objc func makeSureDate() {
        let pickerDate = datePicker.date
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: pickerDate)
        let month = calendar.component(.month, from: pickerDate)
        let day = calendar.component(.day, from: pickerDate)
        var monthStr = month.description
        if month < 10 {
            monthStr = "0\(month)"
        }
        var dayStr = day.description
        if day < 10 {
            dayStr = "0\(day)"
        }
        let dateString = "\(year)-\(monthStr)-\(dayStr)"
        selectDateFinish?(dateString)
        dismissViewController()
        
    }
    @objc func cancelAction()  {
        dismissViewController()
    }
}
