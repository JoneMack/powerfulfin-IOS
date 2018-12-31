//
//  DSApplyTableViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSApplyTableViewController: DSTableViewController {
    var schooId:String = ""
    
    
    var dataSource:DSApplyLocalService!
    var footView:DSApplyFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
    }
    func configTableView()  {
    
        tableView?.separatorStyle = .none
        tableView?.rowHeight = 57
    }
    func loadFooterView(title:String)  {
        footView = DSApplyFooterView(title: title)
        footView?.delegate = self
        tableView?.tableFooterView = footView
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    func uploadImageSuccess(_ imageInfo:DSImageInfo)  {
        
    }
}
extension DSApplyTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRow(section: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource.cellMode(indexPath: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: model.type) as? DSInputTableViewCell
        if cell == nil {
            cell = mallocCell(name: model.type, reuseIdentifier: model.type)
        }
        configCell(cell!, model: model, indexPath: indexPath)
        return cell!
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }

   @objc func configCell(_ cell:DSInputTableViewCell,model:DSInputModel, indexPath:IndexPath)  {
        cell.indexPath = indexPath
        cell.inputModel = model
        cell.delegate = self
        cell.showSpearator = dataSource.isLastRow(indexPath) ? false : true
    }
  
}
extension DSApplyTableViewController:DSInputTableViewCellDelegate {
    
}
extension DSApplyTableViewController {
    func uploadImageToService(imageData:Data,name:String) {
        DSCommonDataService.uploadImage(imageData: imageData, name: name) {[weak self] (imageInfo) in
            self?.uploadImageSuccess(imageInfo)
        }
    }

 
}
extension DSApplyTableViewController:DSApplyFooterViewDelegate {
    func footViewClick(footBtn: UIButton) {
        print("下一步点击了")
    }
}
