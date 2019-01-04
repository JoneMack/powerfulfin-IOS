//
//  DSLoginViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/19.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import SnapKit
class DSLoginViewController: DSViewController {
    fileprivate let loginTypeBtn = UIButton(type: .custom)
    fileprivate let titleLabel = UILabel()
    fileprivate let userNameTF = XJTextFiled()
    fileprivate let passwordTF = XJTextFiled()
    fileprivate let codeBtn = UIButton(type: .custom)
    fileprivate let loginBtn = DSButton(type: .custom)
    
    var loginSuccess:(()->Void)?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        loadTopButtons()
        loadTextFields()
        loadLoginAndAgreementView()
    }
    
   /// 添加顶部按钮
   fileprivate func loadTopButtons()  {
        let closebtn = UIButton(type: .custom)
        closebtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closebtn.addTarget(self, action: #selector(cancelLoginAction), for: .touchUpInside)
        view.addSubview(closebtn)
        closebtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.top.equalTo(XJDeviceInfo.statusBarHeight+10)
        }
        view.addSubview(loginTypeBtn)
        loginTypeBtn.setTitle("账号密码登录", for: .normal)
        loginTypeBtn.setTitle("手机验证码登录", for: .selected)
        loginTypeBtn.setTitleColor(UIColor.ds_grayColor, for: .normal)
        loginTypeBtn.titleLabel?.font = UIFont.ds_font(ptSize: 14)
        loginTypeBtn.addTarget(self, action: #selector(exchangeLoginType(_:)), for: .touchUpInside)
        loginTypeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(XJDeviceInfo.statusBarHeight+10)
            maker.right.equalTo(-28)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    /// 添加输入框
    fileprivate func loadTextFields() {
        titleLabel.textColor = UIColor.ds_blackText
        titleLabel.text = "手机号验证码登录"
        titleLabel.font = UIFont.ds_boldFont(ptSize: 20)
        
        view.addSubview(titleLabel)
        view.addSubview(userNameTF)
        view.addSubview(passwordTF)
        view.addSubview(codeBtn)
        
        userNameTF.placeholder = "请输入手机号"
        userNameTF.keyboardType = .phonePad
        userNameTF.font = UIFont.ds_font(ptSize: 18)
        userNameTF.tintColor = UIColor.ds_blackText
        userNameTF.textColor = UIColor.ds_blackText
        userNameTF.validater = DSPhoneValidater()
        userNameTF.valitateTextStatusChanged {[weak self] enable in
            if self?.loginTypeBtn.isSelected == false {
                self?.codeBtn.isHidden = !enable
            }else{
                self?.codeBtn.isHidden = true
            }
            self?.updateLoginBtnStatus()
        }
       
        passwordTF.tintColor = UIColor.ds_blackText
        passwordTF.textColor = UIColor.ds_blackText
        passwordTF.font = UIFont.ds_font(ptSize: 18)
        passwordTF.validater = DSCodeValidater()
        passwordTF.valitateTextStatusChanged {[weak self] enable in
            self?.updateLoginBtnStatus()
        }
        passwordTF.placeholder = "请输入验证码"
        passwordTF.keyboardType = .numberPad
        
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.setTitleColor(UIColor.ds_blueText, for: .normal)
        codeBtn.setTitleColor(UIColor.ds_lightGrayText, for: .disabled)
        codeBtn.titleLabel?.font = UIFont.ds_boldFont(ptSize: 15)
        codeBtn.addTarget(self, action: #selector(getMsgCode), for: .touchUpInside)
        codeBtn.isHidden = true
        
        let phoneBtn = DSPhoneButton(title: "+86")
        view.addSubview(phoneBtn)
       
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(XJDeviceInfo.naivgaitonBarHeight+40)
            maker.centerX.equalTo(XJDeviceInfo.screenWidth/2)
        }
        phoneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.height.equalTo(59)
            maker.width.equalTo(53)
            maker.top.equalTo(titleLabel.snp_bottomMargin).offset(49)
        }
        userNameTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneBtn.snp_rightMargin).offset(21)
            maker.right.equalTo(-28)
            maker.height.equalTo(59)
            maker.top.equalTo(titleLabel.snp_bottomMargin).offset(49)
        }
        
        passwordTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.right.equalTo(-28)
            maker.height.equalTo(59)
            maker.top.equalTo(userNameTF.snp_bottomMargin).offset(10)
        }
        
        codeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-28)
            maker.height.equalTo(59)
            maker.top.equalTo(userNameTF.snp_bottomMargin).offset(10)
        }
        let line1 = UIView.lineView()
        view.addSubview(line1)
        let line2 = UIView.lineView()
        view.addSubview(line2)
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.right.equalTo(-28)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(userNameTF.snp_bottomMargin).offset(0)
        }
        line2.snp.makeConstraints { (maker) in
            maker.left.equalTo(28)
            maker.right.equalTo(-28)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(passwordTF.snp_bottomMargin).offset(0)
        }
    }
    fileprivate func loadLoginAndAgreementView() {
        loginBtn.setTitle("登录/注册", for: .normal)
        loginBtn.borderType = .back
        loginBtn.titleLabel?.font = UIFont.ds_font(ptSize: 17)
        loginBtn.layer.cornerRadius = 10
        loginBtn.layer.masksToBounds = true
        loginBtn.addTarget(self, action: #selector(DSLoginViewController.loginAction), for: .touchUpInside)
        loginBtn.isEnabled = false
        
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(passwordTF.snp_bottomMargin).offset(50)
            maker.left.equalTo(16)
            maker.right.equalTo(-16)
            maker.height.equalTo(50)
        }
        
       let agreeView =  DSAgreementView()
        
        agreeView.showAgreeView = { [weak self] in
            let webView = DSWebViewController()
            webView.urlString = "https://www.baidu.com"
            self?.pushToNextViewController(webView)
        }
        view.addSubview(agreeView)
        agreeView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(XJDeviceInfo.screenWidth/2)
            maker.bottom.equalTo(-XJDeviceInfo.tabbarSpaceInX-46)
        }
    }
    
    /// 取消登录
    @objc func cancelLoginAction(){
//        dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async {
        navigationController?.dismiss(animated: true, completion: {[weak self] in
             self?.loginSuccess?()
        })
//            self.navigationController?.dismiss(animated: true, completion: )
//        }
    }
}

// MARK: - 切换登录方式
extension DSLoginViewController {
    /// 切换登录方式
    ///
    /// - Parameter button: 切换按钮
    @objc fileprivate func exchangeLoginType(_ button:UIButton) {
        button.isSelected = !button.isSelected
        passwordTF.text = ""
        if button.isSelected {
            titleLabel.text = "账号密码登录"
            passwordTF.placeholder = "请输入密码(8-20个字符组合)"
            codeBtn.isHidden = true
            passwordTF.keyboardType = .default
            passwordTF.isSecureTextEntry = true
            passwordTF.validater = DSPasswordValidater()
            loginBtn.setTitle("登录", for: .normal)
        }else{
            titleLabel.text = "手机号验证码登录"
            loginBtn.setTitle("登录/注册", for: .normal)
            passwordTF.placeholder = "请输入验证码"
            passwordTF.keyboardType = .numberPad
            passwordTF.isSecureTextEntry = false
            passwordTF.validater = DSCodeValidater()    
            if codeBtn.isHidden == true && userNameTF.validateText().enable == true {
                codeBtn.isHidden = false
            }
        }
    }
}

// MARK: - 更新按钮状态
extension DSLoginViewController {
    func updateLoginBtnStatus()  {
        if userNameTF.validateText().enable == true && passwordTF.validateText().enable == true {
            loginBtn.isEnabled = true
        }else{
            loginBtn.isEnabled = false
        }
    }
}
// MARK: - 登录
extension DSLoginViewController {
    func validateLoginEnable() -> Bool {
        let phoneValidate = userNameTF.validateText()
        if phoneValidate.enable == false {
            XJToast.showToastAction(message: phoneValidate.tips)
            return false
        }
        let codeValidate = passwordTF.validateText()
        if codeValidate.enable == false {
            XJToast.showToastAction(message: codeValidate.tips)
            return false
        }
        return true
    }
    
    /// mark - 登录请求
    @objc func loginAction()  {
        
        if validateLoginEnable() == false {
            return
        }
        view.resignFirstResponder()
    
        let type:NSInteger = loginTypeBtn.isSelected == false ? 1 : 2
        
        DSAccountDataService.login(userName: userNameTF.text!, password: passwordTF.text!, type: type) { (userInfo) in
            DSUserCenter.`default`.login(userInfo: userInfo)
            self.cancelLoginAction()
          
        }
 
    }
}


// MARK: - 获取手机号验证码
extension DSLoginViewController {
    @objc func getMsgCode()  {
        
        let phoneValidate = userNameTF.validateText()
        if phoneValidate.enable == false {
            XJToast.showToastAction(message: phoneValidate.tips)
            return
        }
        let phone = userNameTF.text!
        DSAccountDataService.getPhoneCode(phone: phone) {
            self.codeBtnCountDown()
        }
    }
    
    func codeBtnCountDown()  {
        codeBtn.isEnabled = false
        var count = 60
        XJGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "codeTimer", timeInterval: 1, queue: .main, repeats: true) { [weak self] in
            count -= 1
            self?.codeBtn.setTitle("重新发送(\(count))", for: .disabled)
            if count == 0 {
                self?.codeBtn.isEnabled = true
                XJGCDTimer.shared.cancleTimer(WithTimerName: "codeTimer")
            }
        }
    }
}
