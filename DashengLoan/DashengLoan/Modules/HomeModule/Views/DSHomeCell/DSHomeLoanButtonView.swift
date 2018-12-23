//
//  DSHomeLoanButtonView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeLoanButtonView: UIView {
    fileprivate var leftButton :DSButton? = nil
    fileprivate var rightButton :DSButton? = nil
    
    convenience init(_ leftTitle:String?,rightTitle:String?) {
        self.init()
        loadLeftButton(title: leftTitle)
        loadRightButton(title: rightTitle)
        
        if (leftTitle != nil) && (rightTitle == nil) {
            leftButton?.snp.makeConstraints({ (maker) in
                maker.center.equalTo(self)
                maker.height.equalTo(32)
                maker.width.equalTo(81)
            })
        }
        if (leftTitle == nil) && (rightTitle != nil) {
            rightButton?.snp.makeConstraints({ (maker) in
                maker.center.equalTo(self)
                maker.height.equalTo(32)
                maker.width.equalTo(81)
            })
        }
        if (leftTitle != nil) && (rightTitle != nil) {
            leftButton?.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(self)
                maker.height.equalTo(32)
                maker.width.equalTo(81)
                maker.centerX.equalTo(self).offset(-15)
            })
            rightButton?.snp.makeConstraints({ (maker) in
                maker.centerY.equalTo(self)
                maker.height.equalTo(32)
                maker.width.equalTo(81)
                maker.centerX.equalTo(self).offset(15)
            })
        }
    }
    func loadLeftButton(title:String?)  {
        if let title = title {
            leftButton = DSButton(type: .custom)
            configButtn(btn: leftButton!, title: title, borderType: .red)
            leftButton?.tag = 1
        }
    }
    func loadRightButton(title:String?) {
        if let title = title {
            rightButton = DSButton(type: .custom)
            configButtn(btn: rightButton!, title: title, borderType: .back)
            rightButton?.tag = 2
        }
    }
    func configButtn(btn:DSButton,title:String,borderType:DSButtonType)  {
        btn.setTitle(title, for: .normal)
        btn.borderType = borderType
        btn.titleLabel?.font = UIFont.ds_font(ptSize: 13)
        btn.addTarget(self, action: #selector(DSHomeLoanButtonView.buttonClick(_:)), for: .touchUpInside)
    }
    @objc func buttonClick(_ button:DSButton) {
        print(button.tag)
    }
}
