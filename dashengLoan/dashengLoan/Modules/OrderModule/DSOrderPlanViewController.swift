//
//  DSOrderPlanViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/4.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "DSPlanTableViewCell"
class DSOrderPlanViewController: DSTableViewController {
    var lid:String?
    fileprivate var planArray:[DSPlanInfo] = []
    fileprivate var resultView:DSSearchResultView?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "还款计划"
        configTableView()
        reloadPlanData()
    }
    func configTableView() {
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 80
        tableView?.register(DSPlanTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        addRefreshControl(#selector(DSOrderPlanViewController.reloadPlanData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
    
}

// MARK: - 网络请求
extension DSOrderPlanViewController {
   
   @objc fileprivate func reloadPlanData()  {
        if refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSOrderDataService.getOrderPlanInfo(lid: self.lid!) {[weak self] (planInfo, success) in
            if success {
                self?.planArray.removeAll()
                self?.planArray += planInfo?.loan_bill ?? []
                self?.tableView?.reloadData()
            }
            if self?.planArray.count == 0 {
                self?.showNoResultView()
            }else{
                self?.hiddenNoResultView()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
}
extension DSOrderPlanViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSPlanTableViewCell
    
        let planInfo = planArray[indexPath.row]
        cell.timeLabel.text = planInfo.should_repay_date
        cell.statusLabel.text = planInfo.status_desp
        cell.moneyLabel.text = "￥\(planInfo.repay_need ?? "")"
        if planInfo.status == 2 {
            cell.statusLabel.textColor = UIColor.ds_redText
        }else{
            cell.statusLabel.textColor = UIColor.ds_blackText
        }
        cell.repayBtn.isHidden = planInfo.repay_button == 1 ? false : true
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let alert = DSBillDetailAlertView()
        let planInfo = planArray[indexPath.row]
        alert.billInfo = planInfo
        alert.showAlertController(from: self)
        
    }
}
extension DSOrderPlanViewController:DSPlanTableViewCellDelegate {
    func repayButtonAction(_ indexPath: IndexPath) {
        
    }
}

// MARK: - 无结果页面
extension DSOrderPlanViewController:DSSearchResultViewDelegate {
    func showNoResultView()  {
        if resultView == nil {
            resultView = DSSearchResultView()
            resultView?.titleLabel.text = "暂时没有还款计划"
        }
        resultView?.isHidden = false
        tableView?.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(150)
            maker.centerX.equalToSuperview()
        })
    }
    func hiddenNoResultView()  {
        resultView?.isHidden = true
        resultView?.removeFromSuperview()
    }
 
}
