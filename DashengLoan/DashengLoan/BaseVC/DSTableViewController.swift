//
//  DSTableViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSTableViewController: DSViewController {
    var tableView:UITableView?
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
    }
    open func tableViewType() -> UITableView.Style {
        return .plain
    }
   fileprivate func loadTableView()  {
        tableView = UITableView(frame: CGRect.zero, style: tableViewType())
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 0
        tableView?.estimatedSectionFooterHeight = 0
        tableView?.estimatedSectionHeaderHeight = 0
        tableView?.backgroundColor = UIColor(R: 239, G: 239, B: 239)
        tableView?.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.bottom.equalToSuperview().offset(0)
        })
    }
    open func addRefreshControl(_ action:Selector) {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action:action, for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView?.refreshControl = refreshControl
        }else{
            tableView?.addSubview(refreshControl!)
        }
    }

}
extension DSTableViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

