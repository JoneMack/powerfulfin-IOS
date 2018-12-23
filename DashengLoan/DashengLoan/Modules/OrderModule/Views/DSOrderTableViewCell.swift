//
//  DSOrderTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderTableViewCell: DSTableViewCell {
    var orderNumLabel : UILabel?
    var statusLabel:UILabel?
    
    var organizationNameLabel : UILabel?
    var moenyLabel:UILabel?
    
    fileprivate var backView:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(R: 239, G: 239, B: 239)
        selectionStyle = .none
        backView = UIView()
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 10
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(0)
            maker.right.equalTo(-15)
            maker.left.equalTo(15)
        }
        
        orderNumLabel = UILabel()
        configLabel(orderNumLabel, textColor: .ds_blackText, font: .ds_font(ptSize: 13))
        backView.addSubview(orderNumLabel!)
        
        statusLabel = UILabel()
        configLabel(statusLabel, textColor: .ds_redText, font: .ds_font(ptSize: 13))
        backView.addSubview(statusLabel!)
        
        organizationNameLabel = UILabel()
        configLabel(organizationNameLabel, textColor: .ds_blackText, font: .ds_font(ptSize: 14))
        backView.addSubview(organizationNameLabel!)
        
        moenyLabel = UILabel()
        configLabel(moenyLabel, textColor: .ds_blackText, font: .ds_boldFont(ptSize: 14))
        backView.addSubview(moenyLabel!)
        
        orderNumLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(17)
        })
        statusLabel?.snp.makeConstraints({ (maker) in
            maker.right.equalTo(-12)
            maker.top.equalTo(17)
        })
        organizationNameLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalToSuperview()
        })
        moenyLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(12)
            maker.bottom.equalTo(-20)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - configLabel
extension DSOrderTableViewCell {
    fileprivate func configLabel(_ label:UILabel?,textColor:UIColor,font:UIFont) {
        label?.textColor = textColor
        label?.font = font
    }
}
