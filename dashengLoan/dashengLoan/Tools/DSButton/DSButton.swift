//
//  DSButton.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
enum DSButtonType {
    case red
    case gray
    case back
}
class DSButton: UIButton {
    var borderType :DSButtonType {
        didSet {
            switch borderType {
            case .back:
                setBackgroundImage(UIImage.ds_backgroundImage(CGSize(width: 100, height: 50)), for: .normal)
                setBackgroundImage(UIImage.ds_image(color: UIColor.init(hex: "d9d9d9")), for: .disabled)
                setTitleColor(UIColor.white, for: .normal)
                layer.borderColor = UIColor.ds_redBorder.cgColor
            case .red:
                layer.borderColor = UIColor.ds_redBorder.cgColor
                setTitleColor(UIColor.ds_tintColor, for: .normal)
            case.gray:
                layer.borderColor = UIColor.ds_garyBorder.cgColor
                setTitleColor(UIColor.ds_darkText, for: .normal)
            }
        }
    }
    override var isEnabled: Bool {
        didSet {
            if self.borderType == .back && isEnabled == false {
                layer.borderWidth = 0.0
            }else{
                layer.borderWidth = 1.0
            }
        }
    }
    override init(frame: CGRect) {
        self.borderType = .red
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        self.borderType = .red
        super.init(coder: aDecoder)
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    
    

}
