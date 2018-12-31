//
//  DSDataPickerCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/29.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSDataPickerCell: UITableViewCell {
    var title:String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            let attributedText = NSMutableAttributedString(string: title ?? "", attributes: [.font : UIFont.ds_font(ptSize: 16),.foregroundColor:UIColor(R: 10, G: 171, B: 246)])
            let attachment = NSTextAttachment()
            let icon = UIImage(named: "data_selected_icon")
            attachment.image = icon
            attachment.bounds = CGRect(x: 5, y: 1, width: icon?.size.width ?? 0, height: icon?.size.height ?? 0)
            attributedText.append(NSAttributedString(attachment: attachment))
            textLabel?.attributedText = attributedText
        }else{
            let attributedText = NSMutableAttributedString(string: title ?? "", attributes: [.font : UIFont.ds_font(ptSize: 16),.foregroundColor:UIColor.ds_blackText])
            textLabel?.attributedText = attributedText
        }
    }

}
