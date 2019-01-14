//
//  DSDisplayViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/10.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSDisplayViewCell: DSInputTableViewCell {
    var contentLabel:UILabel!
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.ds_font(ptSize: 14)
        titleLabel.textColor = UIColor.ds_grayColor
        
        contentTextField.isHidden = true
        
        contentLabel = UILabel()
        contentLabel.numberOfLines = 2
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 15))
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.top.equalTo(8)
            maker.bottom.equalTo(-8)
            maker.right.equalTo(-15)
        }
    }
    override func configCellData(model: DSInputModel) {
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
