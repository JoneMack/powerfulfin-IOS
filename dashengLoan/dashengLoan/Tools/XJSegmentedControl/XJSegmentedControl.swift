//
//  XJSegmentedControl.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

@objc protocol XJSegmentedControlDelegate {
    @objc optional func segmentedControl(_ segmentedControl:XJSegmentedControl, didSelected index:Int)
}
private let baseTag = 10
struct XJSegmentItemConfig {
    var itemWidth:CGFloat = 0
    var itemFont:UIFont = UIFont.ds_font(ptSize: 14)
    var itemColor = UIColor.ds_blackText
    var itemSelectedColor = UIColor.ds_redText
    
    var linePercent:CGFloat = 1 // 与itemWidth 的比 默认是1：1
    var lineHeight:CGFloat = 2
    
}

class XJSegmentedControl: UIScrollView {
    
    
    var configer = XJSegmentItemConfig()
    fileprivate(set) var currentIndex:Int = 0
    var titles:[String]? {
        didSet{
            reloadSegmentedItems()
        }
    }
    
    var isLinkScrollView:Bool = true
    
    weak var controlDelegate:XJSegmentedControlDelegate?
    var showBottmSep:Bool = true
    
    
    fileprivate var lineView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        backgroundColor = UIColor.white
        lineView = UIView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

// MARK: - open
extension XJSegmentedControl {
    func moveTo(index:Int) {
        updateLineFrame(index: index)
//        let tempIndex = changeProgress(index: index)
        if index != currentIndex {
            updateItemColor(selectedIndex: index)
        }
        currentIndex = index
    }
    func endMoveTo(index:Int)  {
        updateLineFrame(index: index)
        updateItemColor(selectedIndex: index)
        currentIndex = index
        changeScrollOfSet(index: index)
    }
}

// MARK: - 加载Items
extension XJSegmentedControl {
   fileprivate func reloadSegmentedItems()  {
        for subView in subviews {
            subView.removeFromSuperview()
        }
        var x:CGFloat = 0
        let y:CGFloat = 0
    
        let width = configer.itemWidth
        let height = frame.size.height
        let lineWidth = width * configer.linePercent
        let lineHeight = configer.lineHeight
    
        let lineY = height - configer.lineHeight
    
        let count = titles?.count ?? 0
    
        for index in 0..<count {
            x = width * CGFloat(index)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: y, width: width, height: height)
            button.tag = baseTag + index
            button.setTitle(titles?[index], for: .normal)
            button.titleLabel?.font = configer.itemFont
            button.setTitleColor(configer.itemColor, for: .normal)
            button.setTitleColor(configer.itemSelectedColor, for: .selected)
            button.addTarget(self, action: #selector(XJSegmentedControl.buttonClickAction(btn:)), for: .touchUpInside)
            addSubview(button)
            if index == 0 {
                button.isSelected = true
                lineView.backgroundColor = configer.itemSelectedColor
                lineView.frame = CGRect(x:(width-lineWidth)/2, y: lineY, width: lineWidth, height: lineHeight)
                
            }
            currentIndex = 0
        }
        if showBottmSep {
            let line = UIView.lineView()
            addSubview(line)
            line.frame = CGRect(x: 0, y: height-0.5, width: frame.width, height: 0.5)
        }
        addSubview(lineView)
        bringSubviewToFront(lineView)
        contentSize = CGSize(width: width * CGFloat(count), height: height)
    
    }
    @objc fileprivate func buttonClickAction(btn:UIButton){
        currentIndex = btn.tag - baseTag
        if isLinkScrollView == false {
            updateItemColor(selectedIndex: currentIndex)
            updateLineFrame(index: currentIndex)
        }
        changeScrollOfSet(index: currentIndex)
        
        
        controlDelegate?.segmentedControl!(self, didSelected: currentIndex)
    }
}
extension XJSegmentedControl {
    fileprivate func updateItemColor(selectedIndex:Int)  {
        let count = titles?.count ?? 0
        for index in 0..<count {
            let btn = viewWithTag(index+baseTag) as! UIButton
            btn.isSelected = false
        }
        if let selectedBtn = viewWithTag(selectedIndex + baseTag) as? UIButton {
            selectedBtn.isSelected = true
        }
    }
    fileprivate func updateLineFrame(index:Int)  {
        var rect = lineView.frame
        let width = configer.itemWidth
        let lineWidth = width * configer.linePercent
        
        rect.origin.x = CGFloat(index) * width + (width - lineWidth)/2
        lineView.frame = rect
    }
    fileprivate func changeScrollOfSet(index:Int)  {
        let halfWidth = frame.width/2
        let contentWidth = contentSize.width
        var leftSpace = configer.itemWidth * CGFloat(index) - halfWidth + configer.itemWidth/2
        if leftSpace > contentWidth - frame.width {
            leftSpace = contentWidth - frame.width
        }
        if leftSpace < 0 {
            leftSpace = 0
        }
        setContentOffset(CGPoint(x: leftSpace, y: 0), animated: true)
    }
}
extension XJSegmentedControl {
    
    fileprivate func changeProgress(index:Int) -> Int {
        let count = titles?.count ?? 0
        let min :Double = 0
        let indexO = Double(index)
        
        var indexP:Double = 0
        
        if indexO < min + 0.5 {
            indexP = min
        }else if (indexO >= min - 0.5) {
            indexP = Double(count)
        }else{
            indexP = (indexO + 0.5)
        }
        return Int(indexP)
    }
}
