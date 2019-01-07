//
//  DSMessageViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "DSUserMessageCell"
class DSMessageViewController: DSTableViewController {

//    var messageArray:Array!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "消息"
        configTableView()
    }

    func configTableView()  {
        tableView?.estimatedRowHeight = 44
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.register(DSUserMessageCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        addRefreshControl(#selector(DSMessageViewController.reloadMessageData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
}
extension DSMessageViewController {
    @objc func reloadMessageData() {
        
        refreshControl?.endRefreshing()
        return
        
        if refreshControl?.isRefreshing == false {
            XJToast.showToastAction()
        }
        DSAccountDataService.getUserMessageList {[weak self] (messgesInfo, success) in
            if success {
                
            }
            self?.refreshControl?.endRefreshing()
        }
    }
}
extension DSMessageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSUserMessageCell
        cell.timeLabel.text = "2019-01-12"
        if indexPath.row%3 == 0 {
            cell.contentLabel.text = "这个只是一个普通的cell"
        }else if indexPath.row%3 == 1 {
            cell.contentLabel.text = "这个只是一个普通的cell,这个只是一个普通的cell,这个只是一个普通的cell"
        }else if indexPath.row%3 == 2 {
            cell.contentLabel.text = "这个只是一个普通的cell,这个只是一个普通的cell,这个只是一个普通的cell这个只是一个普通的cell,这个只是一个普通的cell,这个只是一个普通的cell这个只是一个普通的cell,这个只是一个普通的cell,这个只是一个普通的cell"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
    }
}

