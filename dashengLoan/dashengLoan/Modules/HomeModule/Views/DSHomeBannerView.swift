//
//  DSHomeBannerView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeBannerView: UIView {
    var loopView:XJLoopView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.green

        loopView = XJLoopView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth-18, height: 150))
        addSubview(loopView!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

