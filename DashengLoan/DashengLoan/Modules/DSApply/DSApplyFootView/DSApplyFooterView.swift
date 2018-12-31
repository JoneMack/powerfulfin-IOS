//
//  DSApplyFooterView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSApplyFooterViewDelegate {
   @objc optional func footViewClick(footBtn:UIButton)
   
}
class DSApplyFooterView: UIView {

    var title:String? {
        didSet {
            footBtn?.setTitle(title, for: .normal)
        }
    }
    weak var delegate:DSApplyFooterViewDelegate?
    
    var footBtn:DSButton?
    
    convenience init(title:String) {
        self.init(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 120))
        footBtn = DSButton(type: .custom)
        footBtn?.borderType = .back
        footBtn?.titleLabel?.font = UIFont.ds_font(ptSize: 17)
        footBtn?.layer.cornerRadius = 10
        footBtn?.layer.masksToBounds = true
        footBtn?.setTitle(title, for: .normal)

        footBtn?.addTarget(self, action: #selector(DSApplyFooterView.footButtonClick), for: .touchUpInside)
        addSubview(footBtn!)
        footBtn?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(27)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(50)
        })
        
        self.title = title
        
    }
    @objc func footButtonClick() {
        delegate?.footViewClick!(footBtn: footBtn!)
    }
    

}
