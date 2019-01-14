//
//  DSBillDetailAlertView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/5.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSBillDetailAlertView: KZAlertController {

    var billInfo :DSPlanInfo? {
        didSet{
            var height:CGFloat = 276
            hasRepayedLabel = true
            if billInfo?.repay_date == nil || billInfo?.repay_date?.isEmpty == true {
                height -= 127
                hasRepayedLabel = false
            }
           
            contentSize = CGSize(width: 272, height:height)
        }
    }
    fileprivate var hasRepayedLabel = true
    
    fileprivate var contentSize:CGSize = CGSize(width: 272, height:276)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        loadSubViews()
    }
    override func configContentView() {
        contentView.alertAnimation = KZAlertStyleAlert(contentView: contentView)
        contentView.alertAnimation.targetSize = contentSize
        contentView.viewWillDisappear(false)
        contentView.layer.cornerRadius = 10
    
    }
    func loadSubViews()  {
        let titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 16))
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(21)
            maker.centerX.equalToSuperview()
        }
        
        let shouldRepayMoneyLabel = UILabel()
        shouldRepayMoneyLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
        contentView.addSubview(shouldRepayMoneyLabel)
        shouldRepayMoneyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(18)
            maker.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        let shouldRepayDateLabel = UILabel()
        shouldRepayDateLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
        contentView.addSubview(shouldRepayDateLabel)
        shouldRepayDateLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-18)
            maker.centerY.equalTo(shouldRepayMoneyLabel.snp.centerY)
        }
        
        var maxY = shouldRepayDateLabel.snp.bottom
        
        if hasRepayedLabel {
        
            let repayMoneyLabel = UILabel()
            repayMoneyLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
            contentView.addSubview(repayMoneyLabel)
            repayMoneyLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(18)
                maker.top.equalTo(maxY).offset(17)
            }
            
            let repayDateLabel = UILabel()
            repayDateLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
            contentView.addSubview(repayDateLabel)
            repayDateLabel.snp.makeConstraints { (maker) in
                maker.right.equalTo(-18)
                maker.centerY.equalTo(repayMoneyLabel.snp.centerY)
            }
            
            
            
            maxY = repayMoneyLabel.snp.bottom
            
            let systemLabel = UILabel()
            systemLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 16))
            contentView.addSubview(systemLabel)
            systemLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(18)
                maker.top.equalTo(maxY).offset(29)
            }
            let bankLabel = UILabel()
            bankLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
            contentView.addSubview(bankLabel)
            bankLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(18)
                maker.top.equalTo(systemLabel.snp.bottom).offset(17)
            }
            
            repayMoneyLabel.text = "已还 \(billInfo?.repaid ?? "")"
            repayDateLabel.text = billInfo?.repay_date
            
            systemLabel.text = billInfo?.repay_way
            bankLabel.text = "\(billInfo?.repay_bank_account ?? "") \(billInfo?.repay_bank_name ?? "")"
            maxY = bankLabel.snp.bottom
        }
    
        let lineView = UIView.lineView()
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(maxY).offset(16)
            maker.left.right.equalTo(0)
            maker.height.equalTo(0.5)
        }
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.ds_blackText, for: .normal)
        sureBtn.titleLabel?.font = .ds_font(ptSize: 18)
        
        sureBtn.addTarget(self, action: #selector(DSBillDetailAlertView.dismissViewController), for: .touchUpInside)
        contentView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.bottom).offset(0)
            maker.left.right.equalTo(0)
            maker.height.equalTo(55)
        }
        
        titleLabel.text = billInfo?.installment
        shouldRepayMoneyLabel.text = "应还 \(billInfo?.repay_need ?? "")"
        shouldRepayDateLabel.text = billInfo?.should_repay_date
        
    }


}
