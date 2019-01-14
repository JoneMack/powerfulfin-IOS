//
//  DSBanksPicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier:String = "cellidentifeir"
class DSBanksPicker: KZAlertController {
    var selectBankFinish:((DSBank)->Void)?
    
    
    fileprivate var bank_list = [DSBank]()
    
    fileprivate var tableView:UITableView!
    fileprivate var indicatorView:UIActivityIndicatorView?
    fileprivate var contentSizie :CGSize {
        return CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.screenHeight*0.66+XJDeviceInfo.tabbarSpaceInX)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
    }
    override func configContentView() {
        contentView.alertAnimation = KZAlertStyleActionSheet(contentView: contentView)
        contentView.alertAnimation.targetSize = contentSizie
        contentView.viewWillDisappear(false)
    }
    func loadSubViews()  {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 55.0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.register(DSBankCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(0)
            maker.bottom.equalTo(XJDeviceInfo.tabbarSpaceInX)
        }
        tableView.backgroundColor = UIColor.white
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView?.color = UIColor.ds_darkText
        contentView.addSubview(indicatorView!)
        indicatorView?.hidesWhenStopped = true
        indicatorView?.startAnimating()
        indicatorView?.center = CGPoint(x: XJDeviceInfo.screenWidth*0.5, y: contentSizie.height*0.4)
    }

}
extension DSBanksPicker {
    override func showAlertController(from controller: UIViewController!) {
        loadBansData()
        super.showAlertController(from: controller)
    }
    func loadBansData()  {
        if bank_list.count > 0 {
            return
        }
        indicatorView?.startAnimating()
        bank_list.removeAll()
    
        DSApplyDataService.getApplyConifer(part: 2) {[weak self] (conifger) in
            if conifger.bank_list?.count ?? 0 > 0 {
                self?.bank_list += conifger.bank_list ?? []
                self?.indicatorView?.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }
}
extension DSBanksPicker :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let clostBtn = UIButton(type: .custom)
        clostBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        clostBtn.addTarget(self, action: #selector(DSBanksPicker.dismissViewController), for: .touchUpInside)
        headerView.addSubview(clostBtn)
        clostBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.bottom.equalTo(0)
            maker.width.equalTo(60)
        }
        let titleLabel = UILabel()
        titleLabel.configLabel(color: UIColor.ds_blackText, font: .ds_font(ptSize: 16))
        titleLabel.text = "请选择发卡行"
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bank_list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSBankCell
        let bankInfo = bank_list[indexPath.row]
        cell.logo.setImage(bankInfo.logo)
        cell.nameLabel.text = bankInfo.bankname
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let bankInfo = bank_list[indexPath.row]
        selectBankFinish?(bankInfo)
        dismissViewController()
        
    }
}
class DSBankCell: DSTableViewCell {
    var logo:UIImageView!
    var nameLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        logo = UIImageView()
        nameLabel = UILabel()
        nameLabel.configLabel(color: .ds_blackText, font: UIFont.ds_font(ptSize: 14))
        contentView.addSubview(logo)
        contentView.addSubview(nameLabel)
        logo.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.width.height.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(logo.snp.right).offset(15)
            maker.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
