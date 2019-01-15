//
//  DSPasswordViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSPasswordViewController: DSViewController {

    fileprivate var oldPasswordTextField:XJTextField?
    fileprivate var newPasswordTextField:XJTextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "修改密码"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(DSPasswordViewController.savePasswordAction))
        loadSubViews()
        
    }
    func loadSubViews() {
        var top:CGFloat = 0
        
        if DSUserCenter.default.userInfo?.has_password == "1" {
            oldPasswordTextField = XJTextField()
            oldPasswordTextField?.config(textColor: UIColor.ds_blackText, font: .ds_font(ptSize: 15))
            oldPasswordTextField?.validater = DSPasswordValidater()
            oldPasswordTextField?.isSecureTextEntry = true

            oldPasswordTextField?.placeholder = "请输入旧密码"
            view.addSubview(oldPasswordTextField!)
            oldPasswordTextField?.snp.makeConstraints({ (maker) in
                maker.left.equalTo(15)
                maker.right.equalTo(-15)
                maker.top.equalTo(top)
                maker.height.equalTo(56)
            })
            let linView = UIView.lineView()
            view.addSubview(linView)
            linView.snp.makeConstraints { (maker) in
                maker.left.equalTo(15)
                maker.right.equalTo(0)
                maker.top.equalTo(oldPasswordTextField!.snp.bottom).offset(0)
                maker.height.equalTo(0.5)
            }
            top = 57
        }
        newPasswordTextField = XJTextField()
        newPasswordTextField?.validater = DSPasswordValidater()
        newPasswordTextField?.placeholder = "请输入新密码(8-20个字符)"
        newPasswordTextField?.config(textColor: UIColor.ds_blackText, font: .ds_font(ptSize: 15))
        newPasswordTextField?.isSecureTextEntry = true
        
        view.addSubview(newPasswordTextField!)
        newPasswordTextField?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-14)
            maker.top.equalTo(top)
            maker.height.equalTo(56)
        })
        let linView = UIView.lineView()
        view.addSubview(linView)
        linView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(0)
            maker.top.equalTo(newPasswordTextField!.snp.bottom).offset(0)
            maker.height.equalTo(0.5)
        }
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 56)
        rightBtn.setImage(UIImage(named: "pwd_show_icon"), for: .normal)
        rightBtn.setImage(UIImage(named: "pwd_hidden_icon"), for: .selected)
        rightBtn.isSelected = true
        rightBtn.addTarget(self, action: #selector(DSPasswordViewController.showPasswordAction(btn:)), for: .touchUpInside)
        newPasswordTextField?.rightView = rightBtn
        newPasswordTextField?.rightViewMode = .always
    }

}
extension DSPasswordViewController {
    @objc func showPasswordAction(btn:UIButton){
        btn.isSelected = !btn.isSelected
        newPasswordTextField?.isSecureTextEntry = btn.isSelected
        newPasswordTextField?.text = newPasswordTextField?.text?.removeWhiteSpace()
    }
    @objc func savePasswordAction()  {
        if DSUserCenter.default.userInfo?.has_password == "1" {
            let result = oldPasswordTextField?.validateText()
            if result?.enable == false {
                XJToast.showToastAction(message:(oldPasswordTextField?.placeholder)!)
                return
            }
        }
        let result = newPasswordTextField?.validateText()
        if result?.enable == false {
            XJToast.showToastAction(message:(newPasswordTextField?.placeholder)!)
            return
        }
        let oldPwd = oldPasswordTextField?.text
        let newPwd = newPasswordTextField?.text ?? ""

        DSAccountDataService.updateUserPassword(oldPwd: oldPwd, newPwd: newPwd) {[weak self] (success) in
            if success {
                self?.showSuccessAlertView()
            }
        }
    }
    fileprivate func showSuccessAlertView(){
        let alertView = UIAlertController(title: "提示", message: "密码修改成功", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "确定", style: .default, handler: {[weak self] (action) in
            self?.popViewController()
        }))
        present(alertView, animated: true, completion: nil)
        
    }
}
