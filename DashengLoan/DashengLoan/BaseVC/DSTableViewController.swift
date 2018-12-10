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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
    }
    open func tableViewType() -> UITableView.Style {
        return .plain
    }
    func loadTableView()  {
        tableView = UITableView(frame: CGRect.zero, style: tableViewType())
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        tableView?.snp.makeConstraints({ (maker) in
            maker.top.left.right.bottom.equalToSuperview().offset(0)
        })
    }

}
extension DSTableViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
