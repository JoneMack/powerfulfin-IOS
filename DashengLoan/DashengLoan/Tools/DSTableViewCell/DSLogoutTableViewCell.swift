//
//  DSLogoutTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSLogoutTableViewCell: DSTableViewCell {
    public let titleLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.ds_boldFont(ptSize: 14)
        titleLabel.textColor = UIColor.ds_blackText
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
