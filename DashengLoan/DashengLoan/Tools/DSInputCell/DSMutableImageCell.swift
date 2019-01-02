//
//  DSMutableImageCell.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/26.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

let placeholderImage = "1"

private let space :CGFloat = 10;
private let rightSpace :CGFloat = 15

class DSMutableImageCell: DSInputTableViewCell {
    
    var tipsLabel :UILabel?
    var maxCount :Int = 9
    
    
    fileprivate var imagesView : UIView!
    fileprivate var imageWidth:CGFloat = 0
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 0
        contentTextField.isEnabled = false
        contentTextField.isHidden = true
        
        imageWidth = (XJDeviceInfo.screenWidth -  rightSpace*2 - inputCellTitleWidth - space*3)/3

        tipsLabel = UILabel()
        tipsLabel?.configLabel(color: UIColor.ds_redText, font: UIFont.ds_font(ptSize: 14))
        contentView.addSubview(tipsLabel!)
        
        let imagesViewHeight = DSMutableImageCell.heightOfRow(count: 1) - 30

        tipsLabel?.frame = CGRect(x: rightSpace, y: imagesViewHeight, width: XJDeviceInfo.screenWidth - rightSpace*2, height: 30)

        imagesView = UIView ()
        contentView.addSubview(imagesView)
        
    }
    override func configCellData(model: DSInputModel) {
        super.configCellData(model: model)
        tipsLabel?.text = model.placeholder
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DSMutableImageCell {
   
    static func heightOfRow(count:Int) -> CGFloat {
        let rowHeight = (XJDeviceInfo.screenWidth -  rightSpace*2 - inputCellTitleWidth - space*3)/3

        if count <= 3 {
            let rowHeight = space*3 + rowHeight  + 30
            return rowHeight
        }else if count <= 6 {
            let rowHeight = space*4 + rowHeight*2 + 30
            return rowHeight
        }else{
            let rowHeight = space*5 + rowHeight*3 + 30
            return rowHeight
        }
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
        let imagesViewWidth = XJDeviceInfo.screenWidth - orX
        let imagesViewHeight = DSMutableImageCell.heightOfRow(count: count) - 30
        
        imagesView.frame = CGRect(x: orX, y: 0, width: imagesViewWidth, height: imagesViewHeight)
        tipsLabel?.frame = CGRect(x: rightSpace, y: imagesViewHeight, width: XJDeviceInfo.screenWidth - rightSpace*2, height: 30)
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

            if imageInfo.type == placeholderImage {
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
