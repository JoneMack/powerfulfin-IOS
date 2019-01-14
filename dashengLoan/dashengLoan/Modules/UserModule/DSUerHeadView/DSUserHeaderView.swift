//
//  DSUserHeaderView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSUserHeaderView: UIView {
    fileprivate let backView = UIImageView()
    fileprivate let headerView = UIView()
    fileprivate let headerImageView = UIImageView()
    fileprivate let loginBtn = DSButton(type: .custom)
    fileprivate let nameLabel = UILabel()
    var loginAction:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        
        backView.image = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 119))
        backView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
            maker.height.equalTo(119)
        }
        addSubview(headerView)
        headerView.backgroundColor = UIColor.white
        headerView.layer.cornerRadius = 10
        headerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(97)
            maker.top.equalTo(70)
        }
        addSubview(headerImageView)
        headerImageView.backgroundColor = UIColor.white
        headerImageView.layer.cornerRadius = 28
        headerImageView.layer.borderColor = UIColor.white.cgColor
        headerImageView.layer.borderWidth = 4
        headerImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.centerY.equalTo(headerView.snp_topMargin)
            maker.width.height.equalTo(60)
        }
        headerImageView.image = UIImage(named: "user_icon_header")
        DSUserCenter.default.addListener(self)
        
        nameLabel.textColor = UIColor.ds_blackText
        nameLabel.font = UIFont.ds_boldFont(ptSize: 14)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.bottom.equalTo(-29)
        }
        loginBtn.borderType = .back
        loginBtn.titleLabel?.font = UIFont.ds_font(ptSize: 14)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action:#selector(DSUserHeaderView.loginBtnClick), for: .touchUpInside)
        addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(67)
            maker.height.equalTo(32)
            maker.centerX.equalTo(self)
            maker.top.equalTo(headerImageView.snp_bottomMargin).offset(15)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension DSUserHeaderView :DSUserStatusListener {
    @objc fileprivate func loginBtnClick() {
        loginAction?()
    }
    internal func userLoginSuccess() {
        userInfoChanged()
    }
    internal func userLogoutSuccess() {
        loginBtn.isHidden = false
        nameLabel.isHidden = true
    }
    fileprivate func userInfoChanged() {
        loginBtn.isHidden = true
        nameLabel.isHidden = false
        let name = DSUserCenter.`default`.userInfo?.name
        nameLabel.text = "您好，\(name ?? "")同学"
    }
}
