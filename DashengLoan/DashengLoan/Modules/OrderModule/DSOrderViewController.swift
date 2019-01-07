//
//  DSOrderViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
fileprivate let cellIdentifier = "cellIdentifier"

class DSOrderViewController: DSTableViewController {
    
    fileprivate var resultView: DSSearchResultView?
    fileprivate var orderListArray:[DSSimpleOrderInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        DSUserCenter.default.addListener(self)
        if DSUserCenter.default.hasLogin {
            loadOrederListData()
        }else{
            showNoResultView()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(DSOrderViewController.loadOrederListData), name: DSApply.applyFinished, object: nil)

    }
    func configTableView() {
        tableView?.register(DSOrderTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.rowHeight = 112
        tableView?.separatorStyle = .none
        
        tableView?.snp.remakeConstraints({ (maker) in
            maker.top.left.right.equalTo(0)
            maker.bottom.equalTo(-XJDeviceInfo.tabBarHeight)
        })
        addRefreshControl(#selector(DSOrderViewController.loadOrederListData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
}
extension DSOrderViewController {
    @objc func loadOrederListData()  {
        if refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSOrderDataService.getUserOrderList {[weak self] (orderListInfo, success) in
            if success {
                self?.orderListArray.removeAll()
                self?.orderListArray += orderListInfo?.list ?? []
                self?.tableView?.reloadData()
                if self?.orderListArray.count ?? 0 > 0 {
                    self?.hiddenNoResultView()
                }else{
                    self?.showNoResultView()
                }
            }
            self?.refreshControl?.endRefreshing()
        }
    }
}
extension DSOrderViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderListArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSOrderTableViewCell
        let orderInfo = orderListArray[indexPath.section]
        
        cell.orderNumLabel?.text = "订单编号：\(orderInfo.lid ?? "")"
        cell.statusLabel?.text = orderInfo.status_desp
        cell.organizationNameLabel?.text = orderInfo.org_name
        cell.moenyLabel?.text = "￥\(orderInfo.borrow_money ?? "0.00")"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 15
        }
        return 0.01
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = DSOrderDetailViewController()
        let orderInfo = orderListArray[indexPath.section]
        orderDetailVC.orderId = orderInfo.lid ?? ""
        pushToNextViewController(orderDetailVC)
    }
}
extension DSOrderViewController :DSUserStatusListener{
    func userLoginSuccess() {
        loadOrederListData()
    }
    
    func userLogoutSuccess() {
        orderListArray.removeAll()
        showNoResultView()
        tableView?.reloadData()
    }
}

// MARK: - 无结果页面
extension DSOrderViewController:DSSearchResultViewDelegate {
    func showNoResultView()  {
        if resultView == nil {
            resultView = DSSearchResultView()
            resultView?.delegate = self
        }
//        tableView?.isHidden = true
        resultView?.isHidden = false
        tableView?.addSubview(resultView!)
        resultView?.snp.makeConstraints({ (maker) in
            maker.top.equalTo(150)
            maker.centerX.equalToSuperview()
        })
    }
    func hiddenNoResultView()  {
//        tableView?.isHidden = false
        resultView?.isHidden = true
        resultView?.removeFromSuperview()
    }
    func showSearchViewController()  {
        let searchVC = DSSearchViewController()
        pushToNextViewController(searchVC)
    }
}
