//
//  DSOrderPlanCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderPlanCell: UITableViewCell {
    
    var planLable:UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryView = UIImageView(image: UIImage(named: "arrow_right"))
        let titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_blackText, font: .ds_boldFont(ptSize: 15))
        titleLabel.text = "还款计划"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        planLable = UILabel()
        planLable?.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 13))
        contentView.addSubview(planLable!)
        planLable?.snp.makeConstraints({ (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalToSuperview()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
