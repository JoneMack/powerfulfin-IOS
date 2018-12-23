//
//  DSHomeNewsView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeNewsView: UIView {
    fileprivate let logoImageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        logoImageView.image = UIImage(named: "home_icon_news")
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.width.equalTo(59)
            maker.centerY.equalTo(self)
        }
        
        addSubview(titleLabel)
        titleLabel.text = "这是个假消息"
        titleLabel.textColor = UIColor.ds_blackText
        titleLabel.font = UIFont.ds_font(ptSize: 13)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logoImageView.snp_rightMargin).offset(15)
            maker.top.bottom.equalTo(0)
        }
        let moreBtn = UIButton(type: .custom)
        moreBtn.setTitle("更多", for: .normal)
        moreBtn.setTitleColor(UIColor.ds_blackText, for: .normal)
        moreBtn.titleLabel?.font = UIFont.ds_font(ptSize: 13)
        moreBtn.setImage(UIImage.ds_image(color: UIColor.ds_grayColor, size: CGSize(width: 2, height: 15)), for: .normal)
        moreBtn.setImage(UIImage.ds_image(color: UIColor.ds_lineGrayColor, size: CGSize(width: 2, height: 15)), for: .highlighted)
        moreBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        moreBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        moreBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        moreBtn.contentMode = .left
        addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(0)
            maker.right.equalTo(-15)
            maker.width.equalTo(49)
            maker.left.equalTo(titleLabel.snp_rightMargin).offset(10)
        }
        let lineView = UIView.lineView()
        addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
