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
    @objc optional func footViewShowTrainAgreement()
    @objc optional func footViewShowDutyAgreement()
}
class DSApplyFooterView: UIView {

    var title:String? {
        didSet {
            footBtn?.setTitle(title, for: .normal)
        }
    }
    weak var delegate:DSApplyFooterViewDelegate?
    
    var trainButton:UIButton?
    var dutyButton:UIButton?
    
    
    var footBtn:DSButton?
    
    convenience init(title:String) {
        self.init(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 120))
//        translatesAutoresizingMaskIntoConstraints = false
        
        loadButton(title: title)
        self.title = title
    }
    @objc func footButtonClick() {
        delegate?.footViewClick!(footBtn: footBtn!)
    }
}
extension DSApplyFooterView {
     func loadButton(title:String) {
        
        footBtn = DSButton(type: .custom)
        footBtn?.borderType = .back
        footBtn?.titleLabel?.font = UIFont.ds_font(ptSize: 17)
        footBtn?.layer.cornerRadius = 10
        footBtn?.layer.masksToBounds = true
        footBtn?.setTitle(title, for: .normal)
        
        footBtn?.addTarget(self, action: #selector(DSApplyFooterView.footButtonClick), for: .touchUpInside)
        addSubview(footBtn!)
        footBtn?.frame = CGRect(x: 15, y: 27, width: XJDeviceInfo.screenWidth-30, height: 50)
    }
    func showAgreement() {
//        var orgFrame = frame
//        orgFrame.size.height += 150
//        frame = orgFrame
//        snp.remakeConstraints { (maker) in
//            maker.top.equalTo(orgFrame.minY)
//            maker.left.equalTo(0)
//            maker.width.equalTo(XJDeviceInfo.screenWidth)
//            maker.height.equalTo(orgFrame.height)
//        }
        
        trainButton = UIButton(type: .custom)
        configAgreementButton(btn: trainButton!)
        addSubview(trainButton!)
        let trainLabel = UILabel()
        trainLabel.numberOfLines = 0
        let trainTap = UITapGestureRecognizer(target: self, action: #selector(DSApplyFooterView.showAgreementView(tap:)))
        trainLabel.tag = 1
        trainLabel.isUserInteractionEnabled = true
        trainLabel.addGestureRecognizer(trainTap)
        let trainText = NSMutableAttributedString(string: "我已阅读《分期贷款培训协议》并自愿提交分期贷款申请书", attributes: [.font:UIFont.ds_font(ptSize: 13),.foregroundColor:UIColor.ds_grayColor])
            trainText.setAttributes([.font:UIFont.ds_font(ptSize: 13),.foregroundColor:UIColor.ds_blackText], range: NSMakeRange(4, 10))
        trainLabel.attributedText = trainText
        addSubview(trainLabel)
        trainLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(footBtn!.snp.bottom).offset(30)
            maker.left.equalTo(15+16+15)
            maker.right.equalTo(-15)
        }
        
        trainButton?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(trainLabel.snp.left).offset(0)
            maker.top.bottom.equalTo(trainLabel)
        })
        
        dutyButton = UIButton(type: .custom)
        configAgreementButton(btn: dutyButton!)
        addSubview(dutyButton!)
        let dutyLabel = UILabel()
        dutyLabel.numberOfLines = 0
        let dutyTap = UITapGestureRecognizer(target: self, action: #selector(DSApplyFooterView.showAgreementView(tap:)))
        dutyLabel.tag = 2
        dutyLabel.isUserInteractionEnabled = true
        dutyLabel.addGestureRecognizer(dutyTap)
        
        let dutyText = NSMutableAttributedString(string: "我已阅读《数字证书申请及使用责任书》并愿意接受其条款内容", attributes: [.font:UIFont.ds_font(ptSize: 13),.foregroundColor:UIColor.ds_grayColor])
        dutyText.setAttributes([.font:UIFont.ds_font(ptSize: 13),.foregroundColor:UIColor.ds_blackText], range: NSMakeRange(4, 14))
        dutyLabel.attributedText = dutyText
        addSubview(dutyLabel)
        dutyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(trainLabel.snp.bottom).offset(20)
            maker.left.equalTo(15+16+15)
            maker.right.equalTo(-15)
        }
        
        dutyButton?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(dutyLabel.snp.left).offset(0)
            maker.top.bottom.equalTo(dutyLabel)
        })
    }
    func configAgreementButton(btn:UIButton) {
        btn.setImage(UIImage(named: "apply_agreement_unselected"), for: .normal)
        btn.setImage(UIImage(named: "apply_agreement_selected"), for: .selected)
        btn.addTarget(self, action: #selector(DSApplyFooterView.agreementButtonAction(btn:)), for: .touchUpInside)
    }
    @objc func agreementButtonAction(btn:UIButton){
        btn.isSelected = !btn.isSelected
    }
    @objc func showAgreementView(tap:UITapGestureRecognizer) {
        if tap.view?.tag == 1 {
            delegate?.footViewShowTrainAgreement?()
        }else if tap.view?.tag == 2{
            delegate?.footViewShowDutyAgreement?()
        }
    }
}
