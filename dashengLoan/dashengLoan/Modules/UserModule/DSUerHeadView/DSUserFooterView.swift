//
//  DSUserFooterView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/22.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSUserFooterView: UIView {
    
    fileprivate var versionLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame:frame)
        versionLabel.configLabel(color: UIColor.ds_grayColor, font: .ds_font(ptSize: 12))
        versionLabel.textAlignment = .center
        addSubview(versionLabel)
        
        let topX = DSUserCenter.default.hasLogin ? 32 : 104
        versionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topX)
            maker.centerX.equalToSuperview()
        }
        versionLabel.text = "V\(XJDeviceInfo.appVersion)(\(XJDeviceInfo.appBuildVersion))"
    }
    func remakeVersonLabelConstraints()  {
        let topX = DSUserCenter.default.hasLogin ? 32 : 104
        versionLabel.snp.remakeConstraints { (maker) in
            maker.top.equalTo(topX)
            maker.centerX.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
