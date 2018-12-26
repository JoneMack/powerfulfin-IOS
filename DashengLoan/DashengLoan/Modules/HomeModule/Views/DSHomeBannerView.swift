//
//  DSHomeBannerView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/22.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeBannerView: UIView {
    var loopView:CLLoopView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.green
        loopView = CLLoopView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth-18, height: 150))
        addSubview(loopView!)
        
        loopView?.autoShow = true
        loopView?.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension DSHomeBannerView:CLLoopViewDelegate {
    func selectLoopViewPage(idx: Int) {
        print("选中了index=\(idx)")
    }
}
