//
//  DSSelectorRightButtonCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/7.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSSelectorRightButtonCell: DSSelectorCell {
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
            maker.right.equalTo(0)
            maker.top.bottom.equalTo(0)
            maker.width.greaterThanOrEqualTo(60)
        }
    }
    @objc func rightButtonClickAction() {
        if delegate?.responds(to: #selector(delegate?.inputCell(inputCell:rightButtonClick:))) ?? false {
            delegate?.inputCell!(inputCell: self, rightButtonClick: rightButton)
        }
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
        rightButton.setTitle(model.rightTitle, for: .normal)
        if let imageName = model.rightImage {
            rightButton.setImage(UIImage(named: imageName), for: .normal)
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
