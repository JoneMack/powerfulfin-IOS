//
//  DSIdImageCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSIdImageCell: DSInputTableViewCell {
    var idUpImageView:UIImageView?
    var idDownImageView:UIImageView?
    
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentTextField.isEnabled = false
        contentTextField.isHidden = true
        titleLabel.numberOfLines = 0
        
        idUpImageView = UIImageView()
        idUpImageView?.isUserInteractionEnabled = true
        idDownImageView = UIImageView()
        idDownImageView?.isUserInteractionEnabled = true
        contentView.addSubview(idUpImageView!)
        contentView.addSubview(idDownImageView!)
        
        idUpImageView?.image = UIImage(named: "loan_idcard_front")
        idDownImageView?.image = UIImage(named: "loan_idcard_back")
       
        
        idUpImageView?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(10)
            maker.top.equalTo(30)
            maker.bottom.equalTo(-32)
        })
        idDownImageView?.snp.makeConstraints({ (maker) in
            maker.left.equalTo(idUpImageView!.snp.right).offset(17)
            maker.top.equalTo(30)
            maker.bottom.equalTo(-32)
            maker.right.equalTo(-15)
            maker.width.equalTo(idUpImageView!.snp.width)
        })
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(DSIdImageCell.upImageUploadAction))
        idUpImageView?.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(DSIdImageCell.downImageUploadAction))
        idDownImageView?.addGestureRecognizer(tapGesture2)
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DSIdImageCell {
    @objc func upImageUploadAction()  {
        if delegate?.responds(to: #selector(delegate?.uploadIdCardImage(isFace:indexPath:))) ?? false {
            delegate?.uploadIdCardImage!(isFace: true, indexPath: indexPath)
        }
    }
    
    @objc func downImageUploadAction()  {
        if delegate?.responds(to: #selector(delegate?.uploadIdCardImage(isFace:indexPath:))) ?? false {
            
            delegate?.uploadIdCardImage!(isFace: false, indexPath: indexPath)
        }

    }
}
