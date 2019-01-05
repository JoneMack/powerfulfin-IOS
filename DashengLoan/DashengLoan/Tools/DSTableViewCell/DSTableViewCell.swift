//
//  DSTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/23.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSTableViewCell: UITableViewCell {
    var indexPath:IndexPath!

    fileprivate var separatorView = UIView.lineView()
    open var showSpearator:Bool = false {
        didSet {
            separatorView.isHidden = !showSpearator
        }
    }
    open var leftSpearatorSpace:CGFloat = 15.0 {
        didSet {
            if contentView.subviews.contains(separatorView) == false {
                return
            }
            separatorView.snp.remakeConstraints({ (maker) in
                maker.left.equalTo(leftSpearatorSpace)
                maker.right.bottom.equalTo(0)
                maker.height.equalTo(0.5)
            })
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont.ds_font(ptSize: 14)
        textLabel?.textColor = UIColor.ds_blackText
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftSpearatorSpace)
            maker.bottom.equalTo(0)
            maker.right.equalTo(30)
            maker.height.equalTo(0.5)
        }
        
        selectedBackgroundView?.backgroundColor = UIColor.ds_lightGrayText

        separatorView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   
   

}
