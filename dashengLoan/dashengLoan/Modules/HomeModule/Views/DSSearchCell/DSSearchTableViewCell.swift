
//
//  DSSearchTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSSearchTableViewCell: DSTableViewCell {
    var titleLabel :UILabel?
    var detailLabel:UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel = UILabel()
        titleLabel?.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 14))
        contentView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(20)
            maker.centerY.equalToSuperview().offset(-12.5)
        })
        detailLabel = UILabel()
        detailLabel?.configLabel(color: UIColor(hex: "777777"), font: .ds_font(ptSize: 12))
        contentView.addSubview(detailLabel!)
        detailLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(20)
            maker.centerY.equalToSuperview().offset(12.5)
            maker.right.equalTo(-15)
        })
        self.showSpearator = true
        self.leftSpearatorSpace = 0
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
