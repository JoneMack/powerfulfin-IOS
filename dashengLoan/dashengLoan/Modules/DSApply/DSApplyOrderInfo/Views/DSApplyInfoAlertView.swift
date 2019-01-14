//
//  DSApplyInfoAlertView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/7.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyInfoAlertView: KZAlertController {

    var applyInfo:DSApplyInfo! {
        didSet {
            if applyInfo.content_two?.money != nil && applyInfo.content_two?.money?.count ?? 0 > 0 {
                 contentSize = CGSize(width: XJDeviceInfo.screenWidth * 0.75, height:230)
            }else{
                  contentSize = CGSize(width: XJDeviceInfo.screenWidth * 0.75, height:194)
            }
        
        }
    }
    
    fileprivate var contentSize = CGSize(width: XJDeviceInfo.screenWidth * 0.75, height:194)
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
 
        let tipsLabel = UILabel()
        tipsLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
        contentView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(13)
            maker.centerX.equalToSuperview()
        }
        
        
        let leftTitleLabel = UILabel()
        leftTitleLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
        contentView.addSubview(leftTitleLabel)
        leftTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(18)
            maker.top.equalTo(tipsLabel.snp.bottom).offset(30)
        }
        let rightTitleLabel = UILabel()
        rightTitleLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
        contentView.addSubview(rightTitleLabel)
        rightTitleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-18)
            maker.centerY.equalTo(leftTitleLabel.snp.centerY)
        }
        
        leftTitleLabel.text = applyInfo.content_one?.content
        rightTitleLabel.text = applyInfo.content_one?.money
        
        var tempView :UILabel = leftTitleLabel
        
        if applyInfo.content_two?.money != nil && applyInfo.content_two?.money?.count ?? 0 > 0 {
            
            let yMonthLabel = UILabel()
            yMonthLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
            contentView.addSubview(yMonthLabel)
            yMonthLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(18)
                maker.top.equalTo(leftTitleLabel.snp.bottom).offset(18)
            }
            
            let yAmountLabel = UILabel()
            yAmountLabel.configLabel(color: .ds_gray8fText, font: .ds_boldFont(ptSize: 14))
            contentView.addSubview(yAmountLabel)
            yAmountLabel.snp.makeConstraints { (maker) in
                maker.right.equalTo(-18)
                maker.centerY.equalTo(yMonthLabel.snp.centerY)
            }
            tempView = yMonthLabel
            
            yMonthLabel.text = applyInfo.content_two?.content
            yAmountLabel.text = applyInfo.content_two?.money
        }
        titleLabel.text = applyInfo.title
        tipsLabel.text = "以下为试算金额，实际还款以通知为准"
        
        
        let lineView = UIView.lineView()
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tempView.snp.bottom).offset(16)
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
    }

}
