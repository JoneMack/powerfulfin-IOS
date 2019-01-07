//
//  DSHomeLoanButtonView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSHomeLoanButtonViewDelegate:NSObjectProtocol {
    func bottomBttonClicl(index:Int,action:String?)
    @objc optional func searchButtonClick() 
}

class DSHomeLoanButtonView: UIView {
    weak var delegate:DSHomeLoanButtonViewDelegate?
    fileprivate var buttonsInfo:[DSLoanButtonInfo]?
    convenience init(_ buttons:[DSLoanButtonInfo]?) {
        self.init()
       self.buttonsInfo = buttons
        if buttons?.count == 1 {
            if  let btnInfo = buttons?[0] {
                let type :DSButtonType = btnInfo.style == "1" ? .red :.back
                let btn = loadButton(title: btnInfo.name, borderType: type)
                btn.tag = 0
                btn.snp.makeConstraints({ (maker) in
                    maker.bottom.equalTo(-19)
                    maker.centerX.equalToSuperview()
                    maker.height.equalTo(32)
                    maker.width.equalTo(81)
                })
            }
        }else if buttons?.count == 2 {
            let width = 81.0
            let height = 32.0
            
            if let leftInfo = buttons?[0] {
                let type :DSButtonType = leftInfo.style == "1" ? .red :.back
                let btn = loadButton(title: leftInfo.name, borderType: type)
                btn.tag = 0
                btn.snp.makeConstraints({ (maker) in
                    maker.bottom.equalTo(-19)
                    maker.height.equalTo(height)
                    maker.width.equalTo(width)
                    maker.centerX.equalTo(self).offset(-15-width/2)
                })
            }
            if let rightInfo = buttons?[1] {
                let type :DSButtonType = rightInfo.style == "1" ? .red :.back
                let btn = loadButton(title: rightInfo.name, borderType: type)
                btn.tag = 1
                btn.snp.makeConstraints({ (maker) in
                    maker.bottom.equalTo(-19)
                    maker.height.equalTo(height)
                    maker.width.equalTo(width)
                    maker.centerX.equalTo(self).offset(15+width/2)
                })
            }
        }
    }
  
    func loadButton(title:String?,borderType:DSButtonType) -> DSButton {
        let btn = DSButton(type: .custom)
        addSubview(btn)
        btn.setTitle(title, for: .normal)
        btn.borderType = borderType
        btn.titleLabel?.font = UIFont.ds_font(ptSize: 13)
        btn.addTarget(self, action: #selector(DSHomeLoanButtonView.buttonClick(_:)), for: .touchUpInside)
        return btn
    }
    func configButtn(btn:DSButton,title:String?,borderType:DSButtonType)  {
        btn.setTitle(title, for: .normal)
        btn.borderType = borderType
        btn.titleLabel?.font = UIFont.ds_font(ptSize: 13)
        btn.addTarget(self, action: #selector(DSHomeLoanButtonView.buttonClick(_:)), for: .touchUpInside)
    }
    @objc func buttonClick(_ button:DSButton) {
        let index = button.tag
        
        if  let btnInfo = buttonsInfo?[index] {
            delegate?.bottomBttonClicl(index: button.tag, action: btnInfo.url)

        }
    }
}
