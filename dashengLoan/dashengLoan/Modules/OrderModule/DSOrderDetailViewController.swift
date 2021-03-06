//
//  DSOrderDetailViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let orderTitleIdentifier = "DSOrderTitleCell"
private let orderPlanIdentifier = "DSOrderPlanCell"
private let orderInfoIdentifier = "DSOrderInfoCell"
class DSOrderDetailViewController: DSTableViewController {
    open var orderId:String!
    fileprivate var orderInfo:DSOrderInfo?
    fileprivate let headerTopView = UIImageView()
    
    fileprivate var headerView: DSOrderDetailHeadView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "订单详情"
        configTableView()
        reloadOrderDetailInfo()
    }
    func configTableView() {
        headerView = DSOrderDetailHeadView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 70))
        tableView?.tableHeaderView = headerView
        headerView?.titleLabel?.text = ""
        
        headerTopView.image = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 150))
        headerTopView.frame = CGRect(x: 0, y: -150, width: XJDeviceInfo.screenWidth, height: 151)
        tableView?.addSubview(headerTopView)
        addRefreshControl(#selector(DSOrderDetailViewController.reloadOrderDetailInfo))
        tableView?.sendSubviewToBack(headerTopView)

        tableView?.estimatedRowHeight  = 50
        tableView?.register(DSOrderTitleCell.classForCoder(), forCellReuseIdentifier: orderTitleIdentifier)
        tableView?.register(DSOrderPlanCell.classForCoder(), forCellReuseIdentifier: orderPlanIdentifier)
        tableView?.register(UINib(nibName: "DSOrderInfoCell", bundle: nil), forCellReuseIdentifier: orderInfoIdentifier)
        
    }

}
extension DSOrderDetailViewController {
    @objc fileprivate func reloadOrderDetailInfo() {
        if self.refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSOrderDataService.getOrderDetailInfo(lid: self.orderId) {[weak self] (orderInfo, success) in
            if success {
                self?.orderInfo = orderInfo
                self?.headerView?.titleLabel?.text = self?.orderInfo?.status_desp
                self?.tableView?.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
}
extension DSOrderDetailViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: orderTitleIdentifier, for: indexPath) as! DSOrderTitleCell
            cell.orderIdLabel?.text = "订单编号：\(orderInfo?.lid ?? "")"
            cell.schoolNameLabel?.text = orderInfo?.org_name
            cell.moneyLabel?.text = "￥\(orderInfo?.borrow_money ?? "")"
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: orderPlanIdentifier, for: indexPath) as! DSOrderPlanCell
            cell.planLable?.text = orderInfo?.loan_product
            return cell
        }else if indexPath.section == 2 {
           let cell = tableView.dequeueReusableCell(withIdentifier: orderInfoIdentifier, for: indexPath) as! DSOrderInfoCell
            cell.delegate = self
            cell.schoolNameLabel.text = orderInfo?.org_name
            cell.moneyLabel?.text = "￥\(orderInfo?.borrow_money ?? "")"
            var installment = "\(orderInfo?.installment ?? "")期"
            if orderInfo?.repay_need ?? 0 > 0 {
                installment += "(\(orderInfo?.repay_now ?? ""))"
            }
            cell.installmentLabel.text = installment
            cell.nameLabel.text = orderInfo?.full_name
            cell.phoneLabel.text = orderInfo?.phone
            
            var codeNum = ""
            if let account = orderInfo?.bank_account {
                if account.count > 8 {
                    let count  = account.count - 1
                    codeNum = account[0...3]
                    codeNum = codeNum + "****"
                    codeNum += account[count-3...count]
                }
            }
            cell.bankLabel.text = "\(codeNum) \(orderInfo?.bank_name ?? "")"
            
            cell.applyTimeLabel.text = orderInfo?.create_time
            cell.sourceNameLabel.text = orderInfo?.resource_company
            if orderInfo?.contract?.count ?? 0 > 0 {
                cell.leftSpceConstraint.constant = 110
                cell.contactBtn.isHidden = false
            }else{
                cell.leftSpceConstraint.constant = 15
                cell.contactBtn.isHidden = true
            }
            if (orderInfo?.audit_opinion) != nil && orderInfo?.audit_opinion?.isEmpty == false {
                cell.reasonLabel.text = orderInfo?.audit_opinion
                cell.reasonTitleLabel.text = "拒绝原因"
            }else{
                cell.reasonLabel.text = ""
                cell.reasonTitleLabel.text = ""
            }
            return cell
        }
       
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 107
        }else if indexPath.section == 1 {
            return 46
        }else if indexPath.section == 2 {
            return UITableView.automaticDimension
//            return 390
        }
        return 0
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < -150 {
            var frame = headerTopView.frame
            frame.size.height = -offsetY+1
            frame.origin.y = offsetY
            headerTopView.frame = frame
        }
        if offsetY > 40 {
            navigationItem.title = headerView?.titleLabel?.text
        }else{
            navigationItem.title = "订单详情"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let planVC = DSOrderPlanViewController()
            planVC.lid = self.orderId
            pushToNextViewController(planVC)
        }
    }
}
extension DSOrderDetailViewController:DSOrderInfoCellDelegate {
    func showContactViewAction() {
        let webVC = DSWebViewController()
        webVC.urlString = orderInfo?.contract ?? ""
        pushToNextViewController(webVC)
    }
}
