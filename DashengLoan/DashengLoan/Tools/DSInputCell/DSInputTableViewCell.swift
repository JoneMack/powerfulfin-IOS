//
//  DSInputTableViewCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

@objc protocol DSInputTableViewCellDelegate :NSObjectProtocol {
    @objc optional func uploadIdCardImage(isFace:Bool,indexPath:IndexPath)
    @objc optional func inputCell(inputCell:DSInputTableViewCell,rightButtonClick rightBtn:UIButton)
    @objc optional func inputCell(inputCell:DSInputTableViewCell,uploadImageClick index:Int)
}


protocol MallocCellProtocol {
    static func mallocCell(reuseIdentifier: String?) -> Self
    
}
extension UITableViewCell:MallocCellProtocol{
    static func mallocCell(reuseIdentifier: String?) -> Self {
       return self.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
    }
}

let inputCellTitleWidth:CGFloat = 80

class DSInputTableViewCell: DSTableViewCell {

    var indexPath:IndexPath!
    var inputModel:DSInputModel! {
        didSet {
            configCellData(model: inputModel)
        }
    }
    weak var delegate:DSInputTableViewCellDelegate?
    
    var titleLabel:UILabel!
    var contentTextField:XJTextFiled!
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        titleLabel = UILabel()
        titleLabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 15))
        contentView.addSubview(titleLabel)
        contentTextField = XJTextFiled()
        contentTextField.font = UIFont.ds_font(ptSize: 15)
        contentTextField.tintColor = .ds_blackText
        contentTextField.textColor = .ds_blackText
        NotificationCenter.default.addObserver(self, selector: #selector(DSInputTableViewCell.textFiledTextDidChanged), name: UITextField.textDidChangeNotification, object: contentTextField)
        contentView.addSubview(contentTextField)
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.bottom.equalTo(0)
            maker.width.equalTo(inputCellTitleWidth)
        }
        contentTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.top.bottom.equalTo(0)
            maker.right.equalTo(-15)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configCellData(model:DSInputModel)  {
        titleLabel.text = model.title
        contentTextField.validater = model.validater
        contentTextField.placeholder = model.placeholder
        contentTextField.text = model.content
    }
}
extension DSInputTableViewCell {
    @objc func textFiledTextDidChanged()  {
        inputModel.content = contentTextField.text
    }
}
class DSInputCell: DSInputTableViewCell {
    
}

func InputCell<T:DSInputTableViewCell>(_ cellClass:T.Type) -> DSInputTableViewCell {
    return cellClass.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: NSStringFromClass(cellClass))
}


func mallocCell(name:String, reuseIdentifier:String) -> DSInputTableViewCell? {
    let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String

    return (NSClassFromString(namespace+"."+name) as? MallocCellProtocol.Type)?.mallocCell(reuseIdentifier:reuseIdentifier) as? DSInputTableViewCell
}
