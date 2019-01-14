//
//  DSApplySuccessController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/10.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSApplySuccessController: DSApplyTableViewController {
    var successInfo:DSApplySuccessInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "申请结果"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "apply_close_icon"), style: .plain, target: self, action: #selector(DSApplySuccessController.showHomeViewController))
        dataSource = DSSuccessLocalService()
        dataSource.reloadData(info: successInfo!)
        
        rt_disableInteractivePop = true
        loadTableViewHeaderView()
        loadTableViewFooterView()
    }
    override func configTableView() {
        super.configTableView()
        tableView?.estimatedRowHeight = 40

        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.backgroundColor = UIColor.white
    }

}
extension DSApplySuccessController {
    override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
        
        if let displayCell = cell as? DSDisplayViewCell {
            if (indexPath.row == 1) {
                displayCell.contentLabel.textColor = UIColor.ds_grayColor
                displayCell.contentLabel.font = UIFont.ds_font(ptSize: 13)
            }else{
                displayCell.contentLabel.textColor = UIColor.ds_blackText
                displayCell.contentLabel.font = UIFont.ds_font(ptSize: 15)
            }
        }
        cell.showSpearator = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
extension DSApplySuccessController {
    fileprivate func loadTableViewHeaderView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 150))
        
        var currentHeight:CGFloat = 0
        
        headView.backgroundColor = UIColor.white
        let image = UIImage(named: "apply_finish_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        let size:CGSize = (image?.size)!
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.ds_redText
        imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        headView.addSubview(imageView)
        imageView.center = CGPoint(x: XJDeviceInfo.screenWidth/2, y: 15+size.height/2)
        
        currentHeight = imageView.frame.maxY + 15
        let titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_redText, font: .ds_boldFont(ptSize: 16))
        titleLabel.text = "申请成功"
        headView.addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: XJDeviceInfo.screenWidth/2, y: currentHeight+titleLabel.bounds.height/2)
        
        currentHeight = titleLabel.frame.maxY + 15
        let tipsLabel = UILabel()
        tipsLabel.configLabel(color: .ds_grayColor, font: .ds_font(ptSize: 14))
        tipsLabel.text = "正在加速审核中..."
        headView.addSubview(tipsLabel)
        tipsLabel.sizeToFit()
        tipsLabel.center = CGPoint(x: XJDeviceInfo.screenWidth/2, y: currentHeight+tipsLabel.bounds.height/2)
        
        currentHeight = tipsLabel.frame.maxY + 15
        
        let lineLabel = UILabel()
        lineLabel.textColor = UIColor.ds_grayColor
        lineLabel.text = "-------------------------------------------------------------------------------"
        lineLabel.lineBreakMode = .byCharWrapping
        headView.addSubview(lineLabel)
        lineLabel.frame = CGRect(x: 15, y: currentHeight, width: XJDeviceInfo.screenWidth - 30, height: 2)
        currentHeight += 12
        headView.frame = CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: currentHeight)
        tableView?.tableHeaderView = headView
    }
    fileprivate func loadTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        let lineView = UIView.lineView()
        footerView.addSubview(lineView)
        lineView.frame = CGRect(x: 15, y: 10, width: XJDeviceInfo.screenWidth-30, height: 1)
        
        let  btnWidth = (XJDeviceInfo.screenWidth - 40*2 - 35)/2
        
        let homeBtn = DSButton(type: .custom)
        homeBtn.borderType = .red
        homeBtn.setTitle("返回首页", for: .normal)
        homeBtn.frame = CGRect(x: 40, y: 40, width: btnWidth, height: 40)
        homeBtn.titleLabel?.font = UIFont.ds_font(ptSize: 15)
        homeBtn.addTarget(self, action: #selector(DSApplySuccessController.showHomeViewController), for: .touchUpInside)

        footerView.addSubview(homeBtn)
        
        let detailBtn = DSButton(type: .custom)
        detailBtn.borderType = .back
        detailBtn.setTitle("查看详情", for: .normal)
        detailBtn.frame = CGRect(x: XJDeviceInfo.screenWidth-btnWidth-40, y: 40, width: btnWidth, height: 40)
        detailBtn.titleLabel?.font = UIFont.ds_font(ptSize: 15)
        detailBtn.addTarget(self, action: #selector(DSApplySuccessController.showOrderDetailView), for: .touchUpInside)
        footerView.addSubview(detailBtn)
        footerView.frame = CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 100)
        tableView?.tableFooterView = footerView
    }
}
extension DSApplySuccessController {
    @objc fileprivate func showHomeViewController(){
        popViewController(true)
    }
    @objc fileprivate func showOrderDetailView() {
        let orderDetailVC = DSOrderDetailViewController()
        orderDetailVC.orderId = self.successInfo?.lid?.description ?? ""
        pushToNextViewController(orderDetailVC)
        
        var controllers = rt_navigationController?.viewControllers
        let count = (controllers?.count)!-1
        controllers?.removeSubrange(1..<count)
        rt_navigationController?.viewControllers = controllers!

    }
}
