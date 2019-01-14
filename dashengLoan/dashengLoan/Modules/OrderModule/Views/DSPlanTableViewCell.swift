//
//  DSPlanTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

@objc protocol DSPlanTableViewCellDelegate {
    @objc optional func repayButtonAction(_ indexPath:IndexPath)
}
class DSPlanTableViewCell: DSTableViewCell {
    
    var timeLabel :UILabel!
    var moneyLabel:UILabel!
    var statusLabel:UILabel!
    var repayBtn:DSButton!
    weak var delegate:DSPlanTableViewCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        timeLabel = UILabel()
        timeLabel.configLabel(color: UIColor.ds_darkText, font: .ds_font(ptSize: 13))
        contentView.addSubview(timeLabel)
        statusLabel = UILabel()
        statusLabel.configLabel(color: UIColor.ds_blackText, font: .ds_font(ptSize: 14))
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints({ (maker) in
            maker.right.equalTo(-15)
            maker.top.equalTo(13)
        })
        timeLabel.snp.makeConstraints({ (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalTo(statusLabel.snp.centerY)
        })
        moneyLabel = UILabel()
        moneyLabel.configLabel(color: UIColor.ds_blackText, font: UIFont.ds_boldFont(ptSize: 18))
        contentView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(14)
            maker.bottom.equalTo(-10)
        }
        repayBtn = DSButton(type: .custom)
        repayBtn.borderType = .back
        repayBtn.setTitle("还款", for: .normal)
        repayBtn.titleLabel?.font = UIFont.ds_font(ptSize: 14)
        repayBtn.addTarget(self, action: #selector(DSPlanTableViewCell.repayButtonClick), for: .touchUpInside)
        contentView.addSubview(repayBtn)
        repayBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.bottom.equalTo(-10)
            maker.height.equalTo(28)
            maker.width.equalTo(51)
        }
        self.showSpearator = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func repayButtonClick(){
        delegate?.repayButtonAction?(self.indexPath)
    }
}
