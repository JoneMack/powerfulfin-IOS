//
//  DSLocationViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSLocationViewController: DSViewController {
    var schooId:String = "0"
    var hasNext = true
    
    fileprivate var locationInfo:DSUserLocationInfo?
    fileprivate var coordinateLabel:UILabel?
    fileprivate var addressLabel:UILabel?
    fileprivate var addressDistanceLable:UILabel?
    fileprivate var locationView:UIView?
    fileprivate var footerView:DSApplyFooterView?
    fileprivate var yellowImageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "当前位置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "重新获取", style: .plain, target: self, action: #selector(DSLocationViewController.reloadUserLocation))
        view.backgroundColor = UIColor.ds_backgroundColor
        loadSubViews()
        DSLocationManager.manager.addListener(listen: self)
        reloadUserLocation()
        if hasNext {
            loadFooterView("下一步")
        }else{
            loadFooterView("提交")
        }
        updateUserLocationViewInfo(false)
    }
    fileprivate func loadSubViews()  {
        locationView = UIView()
        locationView?.backgroundColor = UIColor.white
        view.addSubview(locationView!)
        locationView?.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
        }
       
        coordinateLabel = UILabel()
        coordinateLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 14))
        coordinateLabel?.numberOfLines = 0
        locationView?.addSubview(coordinateLabel!)
        coordinateLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(33)
            maker.top.equalTo(20)
            maker.right.equalTo(-15)
        })
        
        let blueImageView = UIImageView(image: UIImage(named: "apply_location_blue"))
        locationView?.addSubview(blueImageView)
        blueImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalTo((coordinateLabel?.snp.centerY)!)
        }
        
        let lineView = UIView.lineView()
        locationView?.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo((coordinateLabel?.snp.bottom)!).offset(20)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        addressLabel = UILabel()
        addressLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 14))
        locationView?.addSubview(addressLabel!)
        addressLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(33)
            maker.top.equalTo(lineView.snp.bottom).offset(10)
            maker.right.equalTo(-15)
            
        })
        addressDistanceLable = UILabel()
        addressDistanceLable?.configLabel(color: .ds_grayColor, font: .ds_font(ptSize: 12))
        locationView?.addSubview(addressDistanceLable!)
        addressDistanceLable?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(33)
            maker.top.equalTo((addressLabel?.snp.bottom)!).offset(5)
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-10)
        })
        
        yellowImageView = UIImageView(image: UIImage(named: "apply_location_yellow"))
        locationView?.addSubview(yellowImageView!)
        yellowImageView?.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalTo((addressLabel?.snp.bottom)!).offset(5)
        }
    }
    func loadFooterView(_ title:String)  {
        footerView = DSApplyFooterView(title: title)
        footerView?.delegate = self
        footerView?.footBtn?.isEnabled = false
        view.addSubview(footerView!)
        footerView?.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo((locationView?.snp.bottom)!).offset(0)
            maker.height.equalTo(120)
        }
        
    }
    
}
extension DSLocationViewController {
    /// 网络请求
    func loadUserLocationInfo()  {
        XJToast.showToastAction()
        DSApplyDataService.getUserLocationInfo(organId: self.schooId) {[weak self] (locationInfo) in
            if locationInfo != nil {
                self?.locationInfo = locationInfo
                self?.updateUserLocationViewInfo(true)
            }else{
                self?.updateUserLocationViewInfo(false)
            }
        }
    }
    func updateUserLocationViewInfo(_ success:Bool) {
        if success {
            footerView?.footBtn?.isEnabled = true
            let lat = DSLocationManager.manager.latitude.twoScaleValue()
            let lng = DSLocationManager.manager.longitude.twoScaleValue()
            coordinateLabel?.text = "您当前位置坐标:(\(lat),\(lng))"
            addressLabel?.text = "地址：" + (locationInfo?.address ?? "")
            
            var distanceText:String = ""
            if let name = locationInfo?.org_name {
                distanceText = "据您报名的\(name)\(locationInfo?.distance ?? "")km"
            }else{
                distanceText = "距离您报名的机构0km"
            }
            addressDistanceLable?.text = distanceText
            
            yellowImageView?.snp.remakeConstraints { (maker) in
                maker.left.equalTo(15)
                maker.centerY.equalTo((addressLabel?.snp.bottom)!).offset(5)
            }
            if locationInfo == nil {
                footerView?.footBtn?.isEnabled = false
            }
        }else{
            coordinateLabel?.text = "请在系统隐私设置中，允许本APP对您当前位置的访问"
            addressLabel?.text = "地址："
            footerView?.footBtn?.isEnabled = false
            yellowImageView?.snp.remakeConstraints { (maker) in
                maker.left.equalTo(15)
                maker.centerY.equalTo((addressLabel?.snp.centerY)!).offset(0)
            }
        }
    }
}
extension DSLocationViewController:DSLocationDelegate,DSApplyFooterViewDelegate {
    @objc fileprivate func reloadUserLocation(){
        DSLocationManager.manager.updateUserLoaction()
    }
    func userLocationDidUpdate(_ success: Bool, error: Error?) {
        if success {
            loadUserLocationInfo()
        }else{
            if DSLocationManager.manager.authStatus == .denied {
                let alertController = UIAlertController(title: "权限不足", message: "请在系统隐私设置中，允许本APP对您当前位置的访问", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "前往", style: .default, handler: { (action) in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url)
                        }
                    }                }))
                alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
                
                updateUserLocationViewInfo(false)
            }else{
                updateUserLocationViewInfo(false)
            }
        }
    }
    func footViewClick(footBtn: UIButton) {
        if hasNext == true {
            DSApply.default.showNextStep()
        }else{
            self.popViewController()
        }
    }
}
