//
//  DSIdImageCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSIdImageCell: DSInputTableViewCell {

    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentTextField.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
