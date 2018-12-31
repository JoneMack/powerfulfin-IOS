//
//  DSWorkHeaderView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/29.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSWorkHeaderViewDelegate :NSObjectProtocol {
    func headerView(_ headerView:DSWorkHeaderView,selectedInex index:Int)
}
class DSWorkHeaderView: UITableViewHeaderFooterView {
    
    weak var delegate:DSWorkHeaderViewDelegate?
    
    var segmentControl:XJSegmentedControl?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadTipsView()
        loadNameInfoView()
        var configer = XJSegmentItemConfig()
        configer.itemWidth = XJDeviceInfo.screenWidth/3
        
        segmentControl = XJSegmentedControl(frame: CGRect(x: 0, y: 84, width: XJDeviceInfo.screenWidth, height: 44))
        segmentControl?.configer = configer
        segmentControl?.isLinkScrollView = false
        segmentControl?.titles = ["在职","学生","待业"]
        segmentControl?.controlDelegate = self
        contentView.addSubview(segmentControl!)
    }
    func loadTipsView()  {
        let tipView = UIView()
        tipView.backgroundColor = UIColor.ds_lightOrangeBack
        contentView.addSubview(tipView)
        tipView.snp.makeConstraints { (maker) in
            maker.top.equalTo(10)
            maker.left.right.equalTo(0)
            maker.height.equalTo(30)
        }
        let tipsLabel = UILabel()
        tipsLabel.configLabel(color: UIColor.ds_orangeText, font: .ds_font(ptSize: 13))
        tipsLabel.text = "注：请选择您目前的状态，并选择其中一项进行填写！"
        tipView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { (maker) in
            maker.top.right.bottom.equalTo(0)
            maker.left.equalTo(15)
        }
    }
    func loadNameInfoView()  {
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (maker) in
            maker.top.equalTo(40)
            maker.left.right.equalTo(0)
            maker.height.equalTo(44)
        }
        
        let nameLabel = UILabel()
        nameLabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 15))
        nameLabel.text = "个人信息"
        backView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        let lineView = UIView.lineView()
        backView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension DSWorkHeaderView:XJSegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: XJSegmentedControl, didSelected index: Int) {
        if delegate?.responds(to: #selector(delegate?.headerView(_:selectedInex:))) ?? false {
            delegate?.headerView(self, selectedInex: index)
        }
    }
}
