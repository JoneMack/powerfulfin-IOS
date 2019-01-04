//
//  DSOrderDetailHeadView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/3.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSOrderDetailHeadView: UIView {
    fileprivate var backgroundView:UIImageView!
    var titleLabel:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = UIImageView()
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(0)
        }
        backgroundView.image = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 200))
        titleLabel = UILabel()
        titleLabel?.configLabel(color: UIColor.white, font: .ds_boldFont(ptSize: 17))
        addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(20)
            maker.bottom.equalTo(-24)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
