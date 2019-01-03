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
    
    lazy var imagePicker: XJImagePicker = {
        return XJImagePicker();
    }()
    
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
    func uploadImageSuccess(_ imageInfo: DSUploaderImageInfo)  {
        let indexPath = imageInfo.indexPath!
        let image = imageInfo.imageInfo!
        if imageInfo.isReplace {
            let index = imageInfo.index
            dataSource.replaceImageInfo(imageInfo: image, atIndex: index, atIndexPath: indexPath)
        }else{
            dataSource.addImageInfo(imageInfo: image, atIndexPath: indexPath)
        }
        tableView?.reloadRows(at: [indexPath], with: .automatic)
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
    
    func inputCell(inputCell: DSInputTableViewCell, uploadImageClick index: Int) {
        let indexPath = inputCell.indexPath
        
        let model = dataSource.cellMode(indexPath: indexPath!)
        let placeholder = model.tipimage ?? ""
        var imageInfo = DSUploaderImageInfo()
        
        imageInfo.servicename = model.servicename
        imageInfo.index = index
        imageInfo.indexPath = indexPath
        if  index > 0 {
            imageInfo.isReplace = true
        }else{
            imageInfo.isReplace = false
        }
        
        imagePicker.ds_showImagePicker(placeholder: placeholder, complete: {[weak self] (images, datas) in
            if let data = datas.first {
                imageInfo.data = data
                self?.uploadImageToService(imageInfo: imageInfo)
            }
        })
    }
}
extension DSApplyTableViewController {
    
    func uploadImageToService(imageInfo:DSUploaderImageInfo) {
    
        DSCommonDataService.uploadImage(imageData: imageInfo.data!, name: imageInfo.servicename!) {[weak self] (info) in
            var image = imageInfo
            image.data = nil
            image.imageInfo = info
            self?.uploadImageSuccess(image)
        }
    }

 
}
extension DSApplyTableViewController:DSApplyFooterViewDelegate {
    func footViewClick(footBtn: UIButton) {
        print("下一步点击了")
    }
}
