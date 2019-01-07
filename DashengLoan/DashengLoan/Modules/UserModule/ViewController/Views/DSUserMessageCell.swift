//
//  DSUserMessageCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/5.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUserMessageCell: DSTableViewCell {
    var timeLabel : UILabel!
    var contentLabel:UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        timeLabel = UILabel()
        timeLabel.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 13))
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(15)
            maker.left.equalTo(15)
        }
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 14))
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(timeLabel.snp.bottom).offset(10)
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
