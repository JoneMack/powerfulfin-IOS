//
//  DSMutableImageCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit


private let space :CGFloat = 10;
private let rightSpace :CGFloat = 15

class DSMutableImageCell: DSInputTableViewCell {
    
    var tipsLabel :UILabel?
    
    
    fileprivate var imagesView : UIView!
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 0
        contentTextField.isEnabled = false
        contentTextField.isHidden = true
        

        tipsLabel = UILabel()
        tipsLabel?.configLabel(color: UIColor.ds_redText, font: UIFont.ds_font(ptSize: 14))
        tipsLabel?.numberOfLines = 0
        contentView.addSubview(tipsLabel!)
        
        tipsLabel?.snp.makeConstraints({ (maker) in
            maker.bottom.equalTo(-10)
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
        })

        imagesView = UIView ()
        contentView.addSubview(imagesView)
        
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
        tipsLabel?.text = model.tips
        if let images = model.images {
            reloadImageViews(images: images)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DSMutableImageCell {
     func reloadImageViews(images:[DSImageInfo])  {
        for subView in imagesView.subviews {
            subView.removeFromSuperview()
        }
        var orX  = rightSpace + inputCellTitleWidth + space
        var orY = space
        let count = images.count
        let imageWidth = (XJDeviceInfo.screenWidth -  rightSpace*2 - inputCellTitleWidth - space*3)/3

        let imagesViewWidth = XJDeviceInfo.screenWidth - orX
        
        var imageRowCount = count/3
        if count%3 > 0 {
            imageRowCount += 1
        }
        let imagesViewHeight = CGFloat(imageRowCount) * (space + imageWidth) + space
        imagesView.frame = CGRect(x: orX, y: 0, width: imagesViewWidth, height: imagesViewHeight)
        for index in 0..<count {
            if index%3 == 0 {
                orX  = 0
            }else if index%3 == 1 {
                orX  = imageWidth + space
            }else if index%3 == 2 {
                orX  = (imageWidth + space)*2
            }
            if index < 3 {
                orY = space
            }else if index < 6 {
                orY = space + (imageWidth + space)
            }else{
                orY = space + (imageWidth + space)*2
            }
            let imageInfo = images[index]
            let image = UIImageView()
            imagesView.addSubview(image)
            imagesView.contentMode = .scaleAspectFill
            if imageInfo.type == defaultImageType {
                image.image = UIImage(named: "apply_add_image")
            }else{
                image.setImage(imageInfo.url)
                image.backgroundColor = UIColor.ds_lightGrayText
            }
            image.frame = CGRect(x: orX, y: orY, width: imageWidth, height: imageWidth)
            image.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DSMutableImageCell.imageClick(gesture:)))
            image.tag = index
            image.addGestureRecognizer(tapGesture)
        }
        
    }
    @objc fileprivate func imageClick(gesture:UITapGestureRecognizer) {
        delegate?.inputCell?(inputCell: self, uploadImageClick: gesture.view?.tag ?? 0)
    }
}
