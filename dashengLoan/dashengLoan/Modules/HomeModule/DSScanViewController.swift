//
//  DSScanViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/7.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit

class DSScanViewController: DSSacnBaseViewController {
    let imagePicker = XJImagePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        scanBoxView?.layer.borderWidth = 1
        scanBoxView?.layer.borderColor = UIColor.white.cgColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .plain, target: self, action: #selector(DSScanViewController.showImagePicker))
    }
    override func scanSize() -> CGSize {
        let width = XJDeviceInfo.screenWidth * 0.6
        return CGSize(width: width, height: width)
    }
    override func handleResultString(_ result: String) {
        DSRouter.openURL(url: result)
    }
    @objc func showImagePicker()  {
        
        imagePicker.ds_showPhotoLibraryPicker {[weak self] (image, data) in
            self?.authQRImage(data.first!)
        }
    }
}
