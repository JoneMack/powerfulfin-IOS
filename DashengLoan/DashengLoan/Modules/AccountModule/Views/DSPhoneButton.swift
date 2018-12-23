//
//  DSPhoneButton.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/20.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSPhoneButton: UIControl {
    let titleLabel = UILabel()
    fileprivate let logoImageView = UIImageView(image: UIImage(named: "login_down_icon"));
    
    convenience init(title:String){
        
        self.init()
        addSubview(titleLabel)
        addSubview(logoImageView)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(0)
        }
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(7)
            maker.top.bottom.right.equalTo(0)
            maker.width.equalTo(8)
        }
        
        titleLabel.text = title
        titleLabel.textColor = UIColor.ds_grayColor
        titleLabel.font = UIFont.ds_boldFont(ptSize: 17)
    }
    
    
    
}
