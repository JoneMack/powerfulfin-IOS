//
//  DSInputTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

@objc protocol DSInputTableViewCellDelegate :NSObjectProtocol {
 @objc optional func addImage()
}


class DSInputTableViewCell: DSTableViewCell {

    var indexPath:IndexPath!
    var inputModel:DSInputModel! {
        didSet {
            configCellData(model: inputModel)
        }
    }
    weak var delegate:DSInputTableViewCellDelegate?
    
    var titleLabel:UILabel!
    var contentTextField:XJTextFiled!
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 15))
        contentView.addSubview(titleLabel)
        contentTextField = XJTextFiled()
        contentTextField.font = UIFont.ds_font(ptSize: 15)
        contentTextField.tintColor = .ds_blackText
        contentTextField.textColor = .ds_blackText
        contentView.addSubview(contentTextField)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.bottom.equalTo(0)
            maker.width.equalTo(70)
        }
        contentTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.top.bottom.equalTo(0)
            maker.right.equalTo(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configCellData(model:DSInputModel)  {
        titleLabel.text = model.title
        contentTextField.validater = model.validater
        contentTextField.placeholder = model.placeholder
        contentTextField.text = model.content
    }
}
class DSInputCell: DSInputTableViewCell {
    
}

func InputCell<T:DSInputTableViewCell>(_ cellClass:T.Type) -> DSInputTableViewCell {
    return cellClass.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: NSStringFromClass(cellClass))
}

