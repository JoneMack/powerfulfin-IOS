//
//  DSRightButtonCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSRightButtonCell: DSInputTableViewCell {
    var rightButton:UIButton!
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rightButton = UIButton(type: .custom)
        rightButton.setTitleColor(UIColor.ds_blueText, for: .normal)
        rightButton.setTitleColor(UIColor.ds_lightGrayText, for: .disabled)
        rightButton.titleLabel?.font = UIFont.ds_boldFont(ptSize: 15)
        rightButton.addTarget(self, action: #selector(rightButtonClickAction), for: .touchUpInside)
        contentView.addSubview(rightButton)
        rightButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(-15)
            maker.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func rightButtonClickAction() {
        if delegate?.responds(to: #selector(delegate?.inputCell(inputCell:rightButtonClick:))) ?? false {
            delegate?.inputCell!(inputCell: self, rightButtonClick: rightButton)
        }
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
        rightButton.setTitle(model.rightTitle, for: .normal)
    }

}
