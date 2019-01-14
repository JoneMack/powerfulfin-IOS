//
//  DSSelectorCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSSelectorCell: DSInputTableViewCell {

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentTextField.isEnabled = false
        accessoryView = UIImageView(image: UIImage(named: "arrow_right"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
        contentTextField.textAlignment =  NSTextAlignment(rawValue: model.alignment?.intValue ?? 0) ?? .left
    }

}
