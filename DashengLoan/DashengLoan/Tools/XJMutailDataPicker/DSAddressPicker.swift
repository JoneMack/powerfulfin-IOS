//
//  DSAddressPicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/29.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSAddressPickerDelegate {
    @objc optional func addressPicker(_ addressPicker:DSAddressPicker,didSelectedAddress province:DSAddress,city:DSAddress,area:DSAddress)
}
fileprivate let barHeigt :CGFloat  = 44
fileprivate let dataPickerHeight:CGFloat = 444
class DSAddressPicker: KZAlertController {
    var tipsTitle:String?

    weak var delegate:DSAddressPickerDelegate?
    
    fileprivate var dataPicer : XJMutailDataPicker?
    fileprivate var titleLabel:UILabel?

    fileprivate var provinceArray = [DSAddress]()
    fileprivate var cityArray = [DSAddress]()
    fileprivate var areaArray = [DSAddress]()
    
    fileprivate var selectedProvince:DSAddress?
    fileprivate var selectedCity:DSAddress?
    fileprivate var selectedArea:DSAddress?
    fileprivate var indicatorView:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHeaderView()
        loadDataPickerView()
        
        loadAddressDataFromService()

    }
    fileprivate var contentSizie :CGSize {
        return CGSize(width: XJDeviceInfo.screenWidth, height: barHeigt+dataPickerHeight+XJDeviceInfo.tabbarSpaceInX)
    }
    override func configContentView() {
        contentView.alertAnimation = KZAlertStyleActionSheet(contentView: contentView)
        contentView.alertAnimation.targetSize = contentSizie
        contentView.viewWillDisappear(false)
        
    }
    fileprivate func loadHeaderView() {
        let headView = UIView()
        contentView.addSubview(headView)
        headView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
            maker.height.equalTo(44)
        }
        titleLabel = UILabel()
        titleLabel?.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 13))
        titleLabel?.text = tipsTitle
        headView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (maker) in
            maker.center.equalToSuperview()
        })
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(DSAddressPicker.dismissViewController), for: .touchUpInside)
        headView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalToSuperview()
        }
    }
    fileprivate func loadDataPickerView() {
        
        dataPicer = XJMutailDataPicker()
        
        dataPicer?.delegate = self
        dataPicer?.dataSource = self
        contentView.addSubview(dataPicer!)
        dataPicer?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(44)
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(XJDeviceInfo.tabbarSpaceInX)
        })
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView?.color = UIColor.ds_darkText
        indicatorView?.hidesWhenStopped = true
        contentView.addSubview(indicatorView!)
        indicatorView?.startAnimating()
        indicatorView?.center = CGPoint(x: XJDeviceInfo.screenWidth/2, y: 244)
    }
}

// MARK: - 网络请求
extension DSAddressPicker {
    func loadAddressDataFromService(province:String? = nil,city:String? = nil)  {
        indicatorView?.startAnimating()
        dataPicer?.isUserInteractionEnabled = false
        var index = 0
        if (province != nil) { index = 1}
        if (city != nil) { index = 2}
        DSApplyDataService.getAddressList(province: province, city: city) {[weak self] (addresses, success) in
            self?.indicatorView?.stopAnimating()
            self?.dataPicer?.isUserInteractionEnabled = true
            if success {
                if index == 0 {
                    self?.provinceArray.removeAll()
                    self?.provinceArray += addresses!
                }else if index == 1 {
                    self?.cityArray += addresses!
                }else if index == 2 {
                    self?.areaArray += addresses!
                }
                DispatchQueue.main.async {
                    self?.dataPicer?.reloadColumnData(index)
                }
            }
        }
    }
}

// MARK: - 数据配置
extension DSAddressPicker : XJMutailDataPickerDelegate,XJMutailDataPickerDataSource {
    func dataPicker(_ dataPicker: XJMutailDataPicker, numberOfRowsInColumn column: Int) -> Int {
        if column == 0 {
            return provinceArray.count
        }else if column == 1 {
            return cityArray.count
        }else if column == 2 {
            return areaArray.count
        }
        return 0
    }
    func dataPicker(_ dataPicker: XJMutailDataPicker, titleForIndexPath indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return provinceArray[indexPath.row].joinname ?? ""
        }else if indexPath.section == 1 {
            return cityArray[indexPath.row].name ?? ""
        }else if indexPath.section == 2 {
            return areaArray[indexPath.row].name ?? ""
        }
        return ""
    }
    func dataPicker(_ dataPicker: XJMutailDataPicker, hasNextColumnForSelectedIndexPath indexPath: IndexPath) -> Bool {
        if indexPath.section < 2 {
            return true
        }
        return false
    }
  
    func dataPicker(_ dataPicker: XJMutailDataPicker, didSelectedIndexPath indexPath: IndexPath) {
        if indexPath.section == 0 {
            let province = provinceArray[indexPath.row]
            selectedProvince = province
            cityArray.removeAll()
            areaArray.removeAll()
            dataPicer?.reloadColumnData(1)
            loadAddressDataFromService(province: province.areaid?.description)
        }else if indexPath.section == 1 {
            let city = cityArray[indexPath.row]
            selectedCity = city
            areaArray.removeAll()
            dataPicer?.reloadColumnData(2)
            loadAddressDataFromService(city: city.areaid?.description)
        }else if indexPath.section == 2 {
            let area = areaArray[indexPath.row]
            
            delegate?.addressPicker?(self, didSelectedAddress: selectedProvince!, city: selectedCity!, area: area)
        }
    }
    
}
