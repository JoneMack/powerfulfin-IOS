//
//  DSUserIdTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/5.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUserIdTableViewCell: DSTableViewCell {
    var logoImageView :UIImageView!
    var titleLabel:UILabel!
    var detailLabel:UILabel!
    var isComplete:Bool = false {
        didSet{
            if isComplete {
                statusLabel.text = "已完成"
                statusLabel.textColor = .ds_darkText
            }else{
                statusLabel.text = "待完成"
                statusLabel.textColor = .ds_redText
            }
        }
    }
    fileprivate var statusLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        logoImageView = UIImageView()
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 16))
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logoImageView.snp.right).offset(12)
            maker.centerY.equalToSuperview().offset(-13)
        }
        
        detailLabel = UILabel()
        detailLabel.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 12))
        contentView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logoImageView.snp.right).offset(12)
            maker.centerY.equalToSuperview().offset(13)
        }
        accessoryView = UIImageView(image: UIImage(named: "arrow_right"))
        
        statusLabel = UILabel()
        statusLabel.configLabel(color: .ds_darkText, font: .ds_font(ptSize: 15))
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    

}
