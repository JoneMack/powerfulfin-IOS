//
//  DSUseBankTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/5.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUseBankTableViewCell: DSApplyBankCell {

    var selectedImageView:UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedImageView = UIImageView(image: UIImage(named: "user_bank_select")?.withRenderingMode(.alwaysTemplate))
        selectedImageView.tintColor = UIColor.ds_redText
        contentView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
