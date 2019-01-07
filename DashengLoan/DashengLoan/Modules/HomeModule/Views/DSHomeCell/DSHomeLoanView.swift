//
//  DSHomeLoanView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeLoanView: UIView {
    fileprivate let titleLabel = UILabel()
    fileprivate let descLabbel = UILabel()
    
    fileprivate var bottomBtnView: DSHomeLoanButtonView?
    
    weak var delegate:DSHomeLoanButtonViewDelegate? {
        didSet {
            bottomBtnView?.delegate = delegate
        }
    }
    var loanStatusInfo:DSHomeLoanInfo?
    
    class func loanView(loanStatus:DSHomeLoanInfo?) -> DSHomeLoanView {
        if loanStatus?.status == "0" || loanStatus?.status == "1" {
            return DSHomeLoanLogoView(loanStatus)
        }else{
            return DSHomeLoanTitleView(loanStatus)
        }
    }
    convenience init(_ loanStatus:DSHomeLoanInfo?)  {
        self.init(frame: .zero)
        self.loanStatusInfo = loanStatus
        loadSubView()
        reloadData()
        reloadButtonsView(buttons: loanStatusInfo?.buttons)
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
    fileprivate func reloadButtonsView(buttons:[DSLoanButtonInfo]?) {
        bottomBtnView?.removeFromSuperview()
        bottomBtnView = DSHomeLoanButtonView(buttons)
        bottomBtnView?.delegate = delegate
        addSubview(bottomBtnView!)
        bottomBtnView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(52)
        })
    }
    fileprivate func reloadData() {
        descLabbel.text = loanStatusInfo?.remark
        if loanStatusInfo?.status == "0" {
            titleLabel.text = "推荐机构"
            descLabbel.text = "无法定位？请点击搜索，或其他方式进行申请"
        }else if loanStatusInfo?.status == "1" {
            titleLabel.text = "订单状态"
        }else if loanStatusInfo?.status == "2" {
            titleLabel.text = "还款日" + (loanStatusInfo?.repay_date ?? "")
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
    fileprivate var logoImageView:UIImageView?
    fileprivate var nameLabel:UILabel?
    
    override func loadSubView() {
        super.loadSubView()
        logoImageView = UIImageView()
        addSubview(logoImageView!)
        nameLabel = UILabel()
        nameLabel?.configLabel(color: UIColor.ds_blackText, font: .ds_font(ptSize: 16))
        addSubview(nameLabel!)
        
        logoImageView?.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(43)
        })
        nameLabel?.snp.makeConstraints({ (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(logoImageView!.snp_bottomMargin).offset(24)
        })
        descLabbel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(nameLabel!.snp_bottomMargin).offset(15)
        }
    }
    override func reloadData() {
        super.reloadData()
        if UIScreen.main.scale == 2 {
            logoImageView?.setImage(loanStatusInfo?.status_img_2x)
        }else{
            logoImageView?.setImage(loanStatusInfo?.status_img_3x)
        }
        descLabbel.isUserInteractionEnabled = false
        if loanStatusInfo?.status == "0" {
            titleLabel.text = "推荐机构"
            let titleText = NSMutableAttributedString(string: "无法定位？请点击搜索，或其他方式进行申请", attributes: [NSAttributedString.Key.font:UIFont.ds_font(ptSize: 13),NSAttributedString.Key.foregroundColor:UIColor.ds_darkText])
            titleText.addAttributes([.font:UIFont.ds_boldFont(ptSize: 13),.foregroundColor:UIColor.ds_darkText,.underlineStyle:NSUnderlineStyle.single.rawValue], range: NSMakeRange(8, 2))
            descLabbel.attributedText = titleText
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DSHomeLoanLogoView.showSeachView))
            descLabbel.isUserInteractionEnabled = true
            descLabbel.addGestureRecognizer(tapGesture)
            nameLabel?.text = loanStatusInfo?.school_name
        }else if loanStatusInfo?.status == "1" {
            titleLabel.text = "订单状态"
            nameLabel?.text = loanStatusInfo?.status_desp
            descLabbel.text = loanStatusInfo?.remark
        }
    }
    @objc func showSeachView()  {
        delegate?.searchButtonClick?()
    }
}
class DSHomeLoanTitleView: DSHomeLoanView {
    fileprivate var moneyTipLabel:UILabel?
    fileprivate var moneyLabel:UILabel?
    
    override func loadSubView() {
        super.loadSubView()
        moneyTipLabel = UILabel()
        moneyTipLabel?.text = "待还金额(元)"
        moneyTipLabel?.configLabel(color: UIColor.init(hex: "777777"), font: .ds_font(ptSize: 13))
        addSubview(moneyTipLabel!)
        moneyLabel = UILabel()
        addSubview(moneyLabel!)
        moneyLabel?.configLabel(color: .ds_blackText, font: .ds_boldFont(ptSize: 29))
        
        moneyTipLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(73)
            maker.centerX.equalToSuperview()
        })
        moneyLabel?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(moneyTipLabel!.snp_bottomMargin).offset(24)
            maker.centerX.equalToSuperview()
        })
        descLabbel.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(moneyLabel!.snp_bottomMargin).offset(20)
        }
        
    }
    override func reloadData() {
        super.reloadData()
        moneyLabel?.text = loanStatusInfo?.repay_money
        if loanStatusInfo?.is_overdue == "1" {
            moneyLabel?.textColor = UIColor.ds_redText
            descLabbel.textColor = UIColor.ds_redText
        }
    }
}
