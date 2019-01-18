//
//  DSOrderInfoCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSOrderInfoCellDelegate {
   @objc optional func showContactViewAction()
}
class DSOrderInfoCell: UITableViewCell {
    
    weak var delegate:DSOrderInfoCellDelegate?
    @IBOutlet weak var schoolNameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var installmentLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var bankLabel: UILabel!
    
    @IBOutlet weak var applyTimeLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var reasonTitleLabel: UILabel!
    
    @IBOutlet weak var leftSpceConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactBtn: DSButton!
    
    
    @IBAction func showContactView(_ sender: Any) {
        delegate?.showContactViewAction?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        reasonLabel.numberOfLines = 0
        contactBtn.borderType = .gray
    }
}
