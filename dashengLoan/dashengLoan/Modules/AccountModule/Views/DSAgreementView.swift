//
//  DSAgreementView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSAgreementView: UIView {
    
    var showAgreeView:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tipsLabel = UILabel()
        tipsLabel.text = "登录注册代表同意"
        tipsLabel.textColor = UIColor.ds_grayColor
        tipsLabel.font = UIFont.ds_boldFont(ptSize: 11)
        addSubview(tipsLabel);
        
        let agreementBtn = UIButton(type: .custom)
        agreementBtn.setTitle("用户协议、隐私政策", for: .normal)
        agreementBtn.titleLabel?.font = UIFont.ds_boldFont(ptSize: 11)
        agreementBtn.setTitleColor(UIColor.ds_blueText, for: .normal)
        agreementBtn.addTarget(self, action: #selector(DSAgreementView.showAgreementView), for: .touchUpInside)
        addSubview(agreementBtn)
        tipsLabel.snp.makeConstraints { (maker) in
            maker.top.left.bottom.equalTo(0)
        }
        agreementBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(tipsLabel.snp_rightMargin).offset(8)
            maker.top.right.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   @objc fileprivate func showAgreementView()  {
       showAgreeView?()
    }
    
}
