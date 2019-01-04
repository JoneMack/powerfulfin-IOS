//
//  DSSearchResultView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSSearchResultViewDelegate {
    @objc optional func showSearchViewController()
}
class DSSearchResultView: UIView {
    weak var delegate:DSSearchResultViewDelegate?
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        let logoImageView = UIImageView(image: UIImage(named: "search_result_icon"))
        addSubview(logoImageView)
        
        titleLabel = UILabel()
        titleLabel.textColor = .ds_darkText
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(logoImageView.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
            maker.left.equalTo(20)
            maker.right.equalTo(-20)
            maker.bottom.equalTo(-30)
        }
        logoImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(20)
            maker.centerX.equalToSuperview()
        }
        let titleText = NSMutableAttributedString(string: "您尚未产生订单，快去搜搜看吧", attributes: [NSAttributedString.Key.font:UIFont.ds_font(ptSize: 13),NSAttributedString.Key.foregroundColor:UIColor.ds_darkText])
        titleText.addAttributes([.font:UIFont.ds_boldFont(ptSize: 13),.foregroundColor:UIColor.ds_darkText,.underlineStyle:NSUnderlineStyle.single.rawValue], range: NSMakeRange(10, 3))
        titleLabel.attributedText = titleText
        
        titleLabel.isUserInteractionEnabled = true
        let tapgestury = UITapGestureRecognizer(target: self, action: #selector(DSSearchResultView.showSearchView))
        titleLabel.addGestureRecognizer(tapgestury)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func showSearchView() {
        delegate?.showSearchViewController?()
    }
}
