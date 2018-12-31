//
//  DSImagePickerActionSheet.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/27.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let rowHeight:CGFloat = 57
@objc protocol DSImagePickerActionSheetDelegate {
    func showTakePhotoView()
    func showPhotoLibrary()
}
class DSImagePickerActionSheet: KZAlertController {
    
    var placeholderImage:String? {
        didSet {
            imageView.setImage(placeholderImage)
        }
    }
   weak var delegate:DSImagePickerActionSheetDelegate?
    
    fileprivate var imageView = UIImageView()
    
    fileprivate var contentSizie :CGSize {
        return CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.screenHeight)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
    }
    override func configContentView() {
        contentView.alertAnimation = KZAlertStyleActionSheet(contentView: contentView)
        contentView.alertAnimation.targetSize = contentSizie
        
        contentView.backgroundColor = .clear
        contentView.viewWillDisappear(false)
        
   
    }
    func loadSubViews()  {
        //UIColor(white: 0, alpha: 0.3)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.ds_boldFont(ptSize: 17)
        cancelButton.layer.cornerRadius = 11
        cancelButton.backgroundColor = UIColor.white
        cancelButton.layer.masksToBounds = true
        
        cancelButton.setBackgroundImage(UIImage.ds_image(color: UIColor.white), for: .normal)
        cancelButton.addTarget(self, action: #selector(DSImagePickerActionSheet.cancelSelectImageAction), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.bottom.equalTo(-10-XJDeviceInfo.tabbarSpaceInX)
            maker.height.equalTo(rowHeight)
        }
        
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.white
        sectionView.layer.cornerRadius = 11
        sectionView.layer.masksToBounds = true
        contentView.addSubview(sectionView)
        sectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(rowHeight*2+0.5)
            maker.bottom.equalTo(cancelButton.snp.top).offset(-8)
        }
        
        let takePhotoBtn = UIButton(type: .system)
        takePhotoBtn.setTitle("拍照", for: .normal)
        takePhotoBtn.setBackgroundImage(UIImage.ds_image(color: UIColor.white), for: .normal)
        takePhotoBtn.titleLabel?.font = UIFont.ds_font(ptSize: 17)
        takePhotoBtn.addTarget(self, action: #selector(DSImagePickerActionSheet.takePhotoButtonAction), for: .touchUpInside)
        sectionView.addSubview(takePhotoBtn)
        takePhotoBtn.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(0)
            maker.height.equalTo(rowHeight)
        }
        let lineView = UIView.lineView()
        sectionView.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(takePhotoBtn.snp.bottom).offset(0)
            maker.height.equalTo(0.5)
        }
        
        let takeLibrary = UIButton(type: .system)
        takeLibrary.setTitle("从相机中选择", for: .normal)
        takeLibrary.setBackgroundImage(UIImage.ds_image(color: UIColor.white), for: .normal)
        takeLibrary.titleLabel?.font = UIFont.ds_font(ptSize: 17)

        takeLibrary.addTarget(self, action: #selector(DSImagePickerActionSheet.showPhotoLibraryAction), for: .touchUpInside)
        sectionView.addSubview(takeLibrary)
        takeLibrary.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(lineView.snp.bottom).offset(0)
            maker.height.equalTo(rowHeight)
        }
        
        contentView.addSubview(imageView)
        imageView.image = UIImage(named: placeholderImage ?? "")
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints({ (maker) in
            
            maker.left.equalTo(25)
            maker.right.equalTo(-25)
            maker.height.equalTo(imageView.snp.width).multipliedBy(0.84)
            maker.centerY.equalToSuperview().offset(-40)
        })
        
    }
}
extension DSImagePickerActionSheet {
    @objc func cancelSelectImageAction(){
        dismissViewController()
    }
    @objc func takePhotoButtonAction(){
        dismiss(animated: true) {[weak self] in
            self?.delegate?.showTakePhotoView()
        }
    }
    @objc func showPhotoLibraryAction(){
        dismiss(animated: true) {[weak self] in
            self?.delegate?.showPhotoLibrary()
        }
    }
}
