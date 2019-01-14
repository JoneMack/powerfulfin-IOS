//
//  DSPhoneViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSPhoneViewController: DSViewController {
    
    var titleLabel:UILabel?
    var backView:UIView?
    var addressBool:[[String:AnyObject]]?
    var hasNext:Bool = true
    
    var conanctManager = DSContacts()
    
    fileprivate var footerView : DSApplyFooterView?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "设备信息"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "重新获取", style: .plain, target: self, action: #selector(DSPhoneViewController.reloadUserPhoneBooks))
        view.backgroundColor = UIColor.ds_backgroundColor

        addSubViews()
        if hasNext {
            loadFooterView("下一步")
        }else{
            loadFooterView("提交")
        }
        conanctManager.delegate = self
        reloadUserPhoneBooks()
    }
    func addSubViews()  {
        backView = UIView()
        backView?.backgroundColor = UIColor.white
        view.addSubview(backView!)
        let blueImageView = UIImageView(image: UIImage(named: "apply_location_blue"))
        backView?.addSubview(blueImageView)
        blueImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        titleLabel = UILabel()
        titleLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 14))
        titleLabel?.numberOfLines = 0
        titleLabel?.text = "无法获取您的设备信息，请确认已打开允许读取通信录的权限"
        backView?.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(20)
            maker.left.equalTo(33)
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-20)
        })
        backView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.equalTo(0)
        })
        let tipsLabel = UILabel()
        tipsLabel.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 12))
        tipsLabel.text = "您的个人信息将被平台严格保密"
        view.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(100+XJDeviceInfo.tabbarSpaceInX)
        }
    }
    func loadFooterView(_ title:String)  {
        footerView = DSApplyFooterView(title: title)
        footerView?.delegate = self
        footerView?.footBtn?.isEnabled = false
        view.addSubview(footerView!)
        footerView?.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo((backView?.snp.bottom)!).offset(0)
            maker.height.equalTo(120)
        }
    }

}

// MARK: - 重新获取数据
extension DSPhoneViewController {
    @objc fileprivate func reloadUserPhoneBooks()  {
        
        conanctManager.checkContactStoreAuthorization {[weak self] (status) in
            if status == .denied {
                self?.showAuthDenidedAlert()
                self?.titleLabel?.text = "无法获取您的设备信息，请确认已打开允许读取通信录的权限"
            }else{
                self?.titleLabel?.text = "读取中···"
                self?.conanctManager.readContactsFromContactStore()
            }
        }
    }
    fileprivate func showAuthDenidedAlert() {
        let alertController = UIAlertController(title: "权限不足", message: "请在系统隐私设置中，允许本APP对您通信录的访问", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "前往", style: .default, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }                }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - 本地数据读取成功回调
extension DSPhoneViewController:DSContactsDelegate {
    func contacts(_ contacts: DSContacts, readContactsStoreFinish contatcsArray: [[String : AnyObject]]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: contatcsArray, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                uploadUserPhoneBooks(booInfo: ["phonebook":jsonString])
            }else{
                XJToast.hiddenToastAction()
            }
        } catch {
            XJToast.hiddenToastAction()
        }
    }
}

// MARK: - 网络请求，下一步点击
extension DSPhoneViewController:DSApplyFooterViewDelegate {
    
    fileprivate func uploadUserPhoneBooks(booInfo:[String:String]) {
        XJToast.showToastAction()
        DSApplyDataService.uploadUserPhoneInfo(phoneInfo: booInfo) {[weak self] in
            self?.titleLabel?.text = "已成功获取您的设备信息"
            self?.footerView?.footBtn?.isEnabled = true
            XJToast.hiddenToastAction()

        }
    }
    func footViewClick(footBtn: UIButton) {
        if hasNext {
            DSApply.default.showNextStep()
        }else{
            popViewController()
        }
    }
}
