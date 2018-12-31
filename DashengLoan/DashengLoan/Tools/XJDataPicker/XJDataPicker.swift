//
//  XJDataPicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let pickerViewHeight :CGFloat = 256.0
private let barViewHeight :CGFloat = 45.0
class XJDataPicker: KZAlertController {

    fileprivate var dataPicker = UIPickerView()
    var dataArray:[String]? 
    var  selectData:((String)->Void)?
    
    fileprivate var currentSelectIndex:Int?
    
    var selectIndex:Int? {
        didSet{
            if dataPicker.numberOfRows(inComponent: 0) > 0 {
                dataPicker.selectedRow(inComponent: selectIndex ?? 0)
            }
        }
    }
    
    
    
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
        let dataPicker = UIPickerView()
        dataPicker.delegate = self
        dataPicker.dataSource = self
        dataPicker.tintColor = UIColor(R: 80, G: 80, B: 80)
        contentView.addSubview(dataPicker)
        dataPicker.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(toolView.snp.bottom).offset(0)
            maker.height.equalTo(pickerViewHeight)
        }
        if dataPicker.numberOfRows(inComponent: 0) > selectIndex ?? 0 {
            dataPicker.selectRow(selectIndex ?? 0, inComponent: 0, animated: false)
        }
    }

}
extension XJDataPicker :UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        clearLine()
        return dataArray?[row] ?? ""
    }
//    func clearLine()  {
//        for view in dataPicker.subviews {
//            if view.tz_height < 1 {
//                view.backgroundColor = UIColor.white
//            }
//        }
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectIndex = row
    }
}
extension XJDataPicker {
    @objc func makeSureDate() {
        let data = dataArray?[currentSelectIndex ?? 0] ?? ""
        selectData?(data)
        dismissViewController()
        
    }
    @objc func cancelAction()  {
        dismissViewController()
    }
}
