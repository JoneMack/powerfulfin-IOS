//
//  DSHomeLoanView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
enum DSLoanStatus : String {
    case locationUnknown = "DSHome"
    
}
class DSHomeLoanView: UIView {
    let titleLabel = UILabel()
    let descLabbel = UILabel()
    var bottomBtnView: DSHomeLoanButtonView?
    
    var loanStatusInfo:DSUserLoanStatusInfo?
    
    class func loanView(loanStatus:DSUserLoanStatusInfo) -> DSHomeLoanView {
        if loanStatus.status == 0 {
            return DSHomeLoanLogoView(loanStatus)
        }else{
            return DSHomeLoanTitleView(loanStatus)
        }
    }
    convenience init(_ loanStatus:DSUserLoanStatusInfo)  {
        self.init(frame: .zero)
        self.loanStatusInfo = loanStatus
        loadSubView()
    }
    fileprivate func loadSubView()  {
        addSubview(titleLabel)
        titleLabel.font = UIFont.ds_boldFont(ptSize: 15)
        titleLabel.textColor = UIColor.ds_blackText
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(19)
        }
        addSubview(descLabbel)
        descLabbel.font = UIFont.ds_font(ptSize: 13)
        descLabbel.textColor = UIColor.ds_darkText
        
        let lineView = UIView.lineView()
        addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.bottom.right.left.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class DSHomeLoanLogoView: DSHomeLoanView {
    override func loadSubView() {
        super.loadSubView()
    }
}
class DSHomeLoanTitleView: DSHomeLoanView {
    override func loadSubView() {
        super.loadSubView()
    }
}
