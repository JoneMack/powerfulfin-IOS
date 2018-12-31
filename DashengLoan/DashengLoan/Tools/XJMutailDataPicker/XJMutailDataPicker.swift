//
//  XJMutailDataPicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/29.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

@objc protocol XJMutailDataPickerDataSource:NSObjectProtocol {
    @objc func dataPicker(_ dataPicker:XJMutailDataPicker,numberOfRowsInColumn column:Int) -> Int
    @objc func dataPicker(_ dataPicker:XJMutailDataPicker,titleForIndexPath indexPath:IndexPath) -> String
    @objc func dataPicker(_ dataPicker:XJMutailDataPicker,hasNextColumnForSelectedIndexPath indexPath:IndexPath)->Bool
}

@objc protocol XJMutailDataPickerDelegate:NSObjectProtocol {
    @objc optional func dataPicker(_ dataPicker:XJMutailDataPicker,didSelectedIndexPath indexPath:IndexPath)
    @objc optional func dataPicker(_ dataPicker:XJMutailDataPicker,didSelectedColumn column:Int)
}
private let defaultHeight:CGFloat = 444
private let segmentHeight:CGFloat = 44
private let contentHeight:CGFloat = 400
class XJMutailDataPicker: UIView {
    
    weak var delegate:XJMutailDataPickerDelegate?
    weak var dataSource:XJMutailDataPickerDataSource?
    
    func reloadColumnData(_ column:Int)  {
        let tag = column + 1
        if let tableView = contentView?.viewWithTag(tag) as? UITableView {
            tableView.reloadData()
        }
    }
    
    fileprivate var segmentControl : XJSegmentedControl?
    fileprivate var contentView:UIScrollView?//存放TableView的。上面只能有tableView
    
    /// 最后一个tableView的tag。 从1 开始。。tableView的个数就是maxIndex
    fileprivate var maxIndex:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSegmentControl()
        loadContentView()
        loadNewTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadSegmentControl(){
        var configer = XJSegmentItemConfig()
        configer.itemWidth = XJDeviceInfo.screenWidth/4
        
        segmentControl = XJSegmentedControl()
        segmentControl?.frame = CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 44)
        segmentControl?.configer = configer
        segmentControl?.isLinkScrollView = true
        segmentControl?.titles = ["请选择"]
        segmentControl?.controlDelegate = self
        addSubview(segmentControl!)
    }
    fileprivate func loadContentView(){
        contentView = UIScrollView()
        contentView?.showsVerticalScrollIndicator = false
        contentView?.showsHorizontalScrollIndicator = false
        contentView?.isPagingEnabled = true
        contentView?.delegate = self
        addSubview(contentView!)
        contentView?.frame = CGRect(x: 0, y: segmentHeight, width: XJDeviceInfo.screenWidth, height: contentHeight)
    }
    
    
}
extension XJMutailDataPicker:UITableViewDelegate,UITableViewDataSource {
    func loadNewTableView() {
        maxIndex += 1
        let x = CGFloat(maxIndex-1) * XJDeviceInfo.screenWidth
        let width = XJDeviceInfo.screenWidth
        
        let tableView = UITableView(frame: CGRect(x: x, y: 0, width: width, height: contentHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.separatorStyle = .none
        tableView.register(DSDataPickerCell.classForCoder(), forCellReuseIdentifier: "pickerCellIdentifier")
        
        tableView.tag = maxIndex
        
        contentView?.addSubview(tableView)
        contentView?.contentSize = CGSize(width: x + width, height: contentHeight)
        
    }
    func removeTableViewFrom(_ index:Int) {
        while index <= maxIndex {
            let subView = contentView?.viewWithTag(maxIndex)
            subView?.removeFromSuperview()
            maxIndex -= 1
            contentView?.contentSize = CGSize(width: CGFloat(maxIndex) * XJDeviceInfo.screenWidth, height: contentHeight)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource?.responds(to: #selector(dataSource?.dataPicker(_:numberOfRowsInColumn:))) ?? false {
            return dataSource?.dataPicker(self, numberOfRowsInColumn: tableView.tag - 1) ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCellIdentifier", for: indexPath) as! DSDataPickerCell
        if dataSource?.responds(to: #selector(dataSource?.dataPicker(_:titleForIndexPath:))) ?? false {
            let title = dataSource?.dataPicker(self, titleForIndexPath: IndexPath(row: indexPath.row, section: tableView.tag - 1))
            cell.title = title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var hasNext = false
        if dataSource?.responds(to: #selector(dataSource?.dataPicker(_:hasNextColumnForSelectedIndexPath:))) ?? false {
            hasNext = dataSource?.dataPicker(self, hasNextColumnForSelectedIndexPath: IndexPath(row: indexPath.row, section: tableView.tag - 1)) ?? false
        }
        
        //当前展示的title们
        var titleArray = segmentControl?.titles
        
        //当前选中的的内容
        let cell = tableView.cellForRow(at: indexPath) as! DSDataPickerCell
        let text = cell.title
        
        let currentIndex = tableView.tag
        
        if hasNext {//如果还有下一项
            if currentIndex == maxIndex {//如果当前点击项是最后一项
                loadNewTableView()
                titleArray?[currentIndex-1] = text ?? ""
                titleArray?.append("请选择")
            }else{//如果已经存在的项，则删除下一项的后面的内容. 即：使得currentIndex + 1 = maxIndex
                titleArray?.removeToLastFrom(currentIndex + 1)
                removeTableViewFrom(currentIndex + 2)
                titleArray?[currentIndex - 1] = text ?? ""
                titleArray?[currentIndex] = "请选择"
            }
        }else{
            titleArray?[currentIndex-1] = text ?? ""
        }
        
        segmentControl?.titles = titleArray
        
        contentView?.setContentOffset(CGPoint(x: CGFloat(maxIndex-1) * XJDeviceInfo.screenWidth, y: 0), animated: true)

        if delegate?.responds(to: #selector(delegate?.dataPicker(_:didSelectedIndexPath:))) ?? false {
            delegate?.dataPicker!(self, didSelectedIndexPath: IndexPath(row: indexPath.row, section: tableView.tag-1))
        }
        
    }
}
extension XJMutailDataPicker:XJSegmentedControlDelegate,UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentView {
            let offX = scrollView.contentOffset.x
            let index = offX/scrollView.frame.width
            let indexInt = Int(index)
            segmentControl?.moveTo(index: indexInt)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == contentView {
            let offX = scrollView.contentOffset.x
            let index = offX/scrollView.frame.width
            segmentControl?.endMoveTo(index: Int(index))
        }
    }
    func segmentedControl(_ segmentedControl: XJSegmentedControl, didSelected index: Int) {
        
        var titleArray = segmentControl?.titles
        titleArray?.removeToLastFrom(index+1)
        removeTableViewFrom(index+2)
        segmentControl?.titles = titleArray
        contentView?.setContentOffset(CGPoint(x: CGFloat(index) * XJDeviceInfo.screenWidth, y: 0), animated: true)

    }
}
