//
//  DSOrderTitleCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderTitleCell: UITableViewCell {
    
    var orderIdLabel:UILabel?
    var schoolNameLabel:UILabel?
    var moneyLabel:UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        orderIdLabel = UILabel()
        orderIdLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 13))
        contentView.addSubview(orderIdLabel!)
        
        schoolNameLabel = UILabel()
        schoolNameLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 15))
        schoolNameLabel?.numberOfLines = 2
        contentView.addSubview(schoolNameLabel!)
        
        moneyLabel = UILabel()
        moneyLabel?.configLabel(color: .ds_blackText, font: .ds_boldFont(ptSize: 15))
        contentView.addSubview(moneyLabel!)
        
        schoolNameLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.centerY.equalToSuperview()
        })
        
        orderIdLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.bottom.equalTo((schoolNameLabel?.snp.top)!).offset(-15)
        })
        moneyLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo((schoolNameLabel?.snp.bottom)!).offset(15)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
