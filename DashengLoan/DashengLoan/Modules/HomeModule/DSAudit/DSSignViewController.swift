//
//  DSSignViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/9.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSSignViewController: DSApplyTableViewController {
    var orgin:DSOrgation?
    fileprivate var classesArray = [DSAuditClassInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = DSSignLocalService()
        navigationItem.title = "报名学习"
        loadFooterView(title: "提交")
        getClassListFromService()
    }
}
extension DSSignViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 40))
            view.backgroundColor = UIColor.white
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 2
            view.addSubview(titleLabel)
            let name = self.orgin?.name ?? ""
            
            let attributedText = NSMutableAttributedString(string: "您正在申请加入\(name)进行学习,请填写信息", attributes: [NSAttributedString.Key.font:UIFont.ds_font(ptSize: 12),NSAttributedString.Key.foregroundColor:UIColor(hex: "777777")])
            attributedText.addAttributes([NSAttributedString.Key.font:UIFont.ds_font(ptSize: 12),NSAttributedString.Key.foregroundColor:UIColor.ds_blueText], range: NSMakeRange(7, name.count))
            
            titleLabel.attributedText = attributedText
            titleLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(15)
                maker.right.equalTo(-15)
                maker.centerY.equalToSuperview()
            }
            return view
            
        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource.cellMode(indexPath: indexPath)
        
        if  model.title == "课程" {
            if classesArray.count > 0 {
                var titleArray = [String]()
                
                for classInfo in classesArray {
                    titleArray.append(classInfo.class_name ?? "")
                }
                 let picker = XJDataPicker()
                picker.dataArray = titleArray
                picker.showAlertController(from: self)
                picker.selectData = {[weak self] (name) in
                    model.content = name
                    for index in 0..<titleArray.count {
                        if let classInfo = self?.classesArray[index] {
                            if classInfo.class_name == name {
                                model.subContent = classInfo.cid
                                break;
                            }
                        }
                    }
                    self?.tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

// MARK: - 网络请求
extension DSSignViewController {
    func getClassListFromService()  {
        classesArray.removeAll()
        DSAuditDataService.getClassesInfo(orgId: self.orgin?.id ?? "") {[weak self] (list) in
            self?.classesArray += list
        }
    }
    func uploadSignInfoToService()  {
        var paraDic = dataSource.getDataInfo()
        paraDic["org_name"] = self.orgin?.name
        paraDic["org_id"] = self.orgin?.id
        DSAuditDataService.signClass(paraDic: paraDic) {[weak self] in
            self?.showAlertView()
        }
    }
    func showAlertView()  {
        let alertView = UIAlertController(title: "提示", message: "您已经报名课程学习，机构稍后会联系您确认报名信息", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
            self.popViewController()
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    override func footViewClick(footBtn: UIButton) {
        let nameModel = dataSource.cellMode(indexPath: IndexPath(row: 0, section: 0))
        let phoneModel = dataSource.cellMode(indexPath: IndexPath(row: 1, section: 0))
        let classModel = dataSource.cellMode(indexPath: IndexPath(row: 2, section: 0))
        if nameModel.content?.isEmpty == true {
            XJToast.showToastAction(message: nameModel.placeholder!)
            return
        }
        if phoneModel.content?.isEmpty == true {
            XJToast.showToastAction(message: phoneModel.placeholder!)
            return
        }
        if classModel.content?.isEmpty == true {
            XJToast.showToastAction(message: classModel.placeholder!)
            return
        }
        uploadSignInfoToService()
    }
}
