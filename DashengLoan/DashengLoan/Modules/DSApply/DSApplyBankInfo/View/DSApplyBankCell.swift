//
//  DSApplyBankCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/3.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyBankCell: DSTableViewCell {

    var logo:UIImageView!
    var nameLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        logo = UIImageView()
        nameLabel = UILabel()
        nameLabel.configLabel(color: .ds_blackText, font: UIFont.ds_font(ptSize: 16))
        contentView.addSubview(logo)
        contentView.addSubview(nameLabel)
        logo.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.width.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logo.snp.right).offset(10)
            maker.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
