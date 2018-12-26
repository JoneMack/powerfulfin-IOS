//
//  DSHomeSearchControl.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeSearchControl: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 0.2)
        layer.cornerRadius = 15
        let iconImageView = UIImageView(image: UIImage(named: "home_icon_search"))
        iconImageView.contentMode = .scaleAspectFill
        addSubview(iconImageView)
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(white: 1, alpha: 0.44)
        titleLabel.text = "请输入机构名称或编码"
        titleLabel.font = UIFont.ds_font(ptSize: 14)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp_centerYWithinMargins)
            maker.centerX.equalTo(self.snp_centerXWithinMargins).offset(10)
        }
        iconImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel.snp_centerYWithinMargins)
            maker.right.equalTo(titleLabel.snp_leftMargin).offset(-17)
            maker.top.equalTo(titleLabel).offset(3)
            maker.bottom.equalTo(titleLabel).offset(-3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
