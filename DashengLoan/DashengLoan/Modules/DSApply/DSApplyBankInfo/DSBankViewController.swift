//
//  DSBankViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSBankViewController: DSApplyTableViewController {
    var userName:String?
    fileprivate var bankPicker:DSBanksPicker?
    fileprivate var serialnumber:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "银行卡"
        dataSource = DSBankLocalService()
        loadFooterView(title: "下一步")
        bankPicker = DSBanksPicker()
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    override func configTableView()  {
        super.configTableView()
    }
}
extension DSBankViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerSectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "bankViewHeader")
        if headerSectionView == nil {
            headerSectionView = UITableViewHeaderFooterView(reuseIdentifier: "bankViewHeader")
            let titleLabel = UILabel()
            headerSectionView?.contentView.addSubview(titleLabel)
            titleLabel.tag = 10
            titleLabel.font = UIFont.ds_font(ptSize: 12)

            titleLabel.snp.makeConstraints { (maker) in
                maker.top.bottom.equalTo(0)
                maker.left.equalTo(15)
            }
        }
        let titlelabel = headerSectionView?.contentView.viewWithTag(10) as! UILabel
        let title = NSMutableAttributedString(string: "请绑定与\(userName ?? "")同名的储蓄卡", attributes: [.font:UIFont.ds_font(ptSize: 12),.foregroundColor:UIColor.ds_blackText])
        let length:Int = userName?.count ?? 0
        
        title.setAttributes([.foregroundColor:UIColor.ds_redText], range: NSMakeRange(4, length))
        titlelabel.attributedText = title
        return headerSectionView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 30.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var headerSectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "bankViewfooter")
        if headerSectionView == nil {
            headerSectionView = UITableViewHeaderFooterView(reuseIdentifier: "bankViewfooter")
            let titleLabel = UILabel()
            headerSectionView?.contentView.addSubview(titleLabel)
            titleLabel.tag = 10
            titleLabel.font = UIFont.ds_font(ptSize: 12)
            titleLabel.textColor = UIColor.ds_redText
            titleLabel.snp.makeConstraints { (maker) in
                maker.top.bottom.equalTo(0)
                maker.left.equalTo(15)
            }
        }
        let titlelabel = headerSectionView?.contentView.viewWithTag(10) as! UILabel
        titlelabel.text = "注：短信验证码由各支付机构单独发送，请注意查收"
        return headerSectionView
    }
    override func configCell(_ cell: DSInputTableViewCell, model: DSInputModel, indexPath: IndexPath) {
        super.configCell(cell, model: model, indexPath: indexPath)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataSource.cellMode(indexPath: indexPath)
        if model.title == "发卡行" {
            bankPicker?.showAlertController(from: self)
            bankPicker?.selectBankFinish = {[weak self] (bankInfo) in
                model.content = bankInfo.bankname
                model.subContent = bankInfo.bank_code
                self?.tableView?.reloadData()
            }
        }
    }
}
// MARK: - cell 代理
extension DSBankViewController {
    func inputCell(inputCell: DSInputTableViewCell, rightButtonClick rightBtn: UIButton) {
        let banCell = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as! DSInputTableViewCell
        if banCell.contentTextField.validateText().enable == false {
            XJToast.showToastAction(message: banCell.contentTextField.placeholder!)
            return
        }
        
        let bankNumCell = tableView?.cellForRow(at: IndexPath(row: 1, section: 0)) as! DSInputTableViewCell
        if bankNumCell.contentTextField.validateText().enable == false {
            XJToast.showToastAction(message: bankNumCell.contentTextField.placeholder!)
            return
        }
        
        let phoneCell = tableView?.cellForRow(at: IndexPath(row: 2, section: 0)) as! DSInputTableViewCell
        
        if phoneCell.contentTextField.validateText().enable == false {
            XJToast.showToastAction(message: "请输入正确的手机号")
            return
        }
        rightBtn.isEnabled = false
        rightBtn.setTitle("获取中...", for: .disabled)
        
        getPhoneCodeFromService()

    }
    func getPhoneCodeFromService() {
        let paramDic = (dataSource as! DSBankLocalService).getPhoneCodeParaDic()
        DSApplyDataService.getBankPhoneCode(cardInfo: paramDic) {[weak self] (serialnumber, success) in
            self?.serialnumber = serialnumber
            self?.updateCodeButton(success: success)
        }
    }
    func updateCodeButton(success:Bool)  {
        let codeCell = tableView?.cellForRow(at: IndexPath(row: 3, section: 0)) as! DSRightButtonCell
        if success {
            codeCell.rightButton.isEnabled = false
            var count = 60
            XJGCDTimer.shared.scheduledDispatchTimer(WithTimerName: "bankCodeTimer", timeInterval: 1, queue: .main, repeats: true) { [weak codeCell] in
                count -= 1
                codeCell?.rightButton.setTitle("重新发送(\(count))", for: .disabled)
                if count == 0 {
                    codeCell?.rightButton.isEnabled = true
                    XJGCDTimer.shared.cancleTimer(WithTimerName: "bankCodeTimer")
                }
            }
        }else{
            codeCell.rightButton.isEnabled = true
        }
    }
}

// MARK: - footView代理
extension DSBankViewController {
    func bindCardToService()  {
        var paramDic = (dataSource as! DSBankLocalService).getBindCardParaDic()
        paramDic["serialnumber"] = serialnumber ?? ""
        DSApplyDataService.bindBankCard(cardInfo: paramDic) {
            DSApply.default.showNextStep()
        }
    }
    override func footViewClick(footBtn: UIButton) {
        bindCardToService()
//        DSApply.default.showNextStep()
    }
}
