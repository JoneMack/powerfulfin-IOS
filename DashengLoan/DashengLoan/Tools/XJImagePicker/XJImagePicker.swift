//
//  XJImagePicker.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/27.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import MobileCoreServices
import TZImagePickerController
class XJImagePicker: NSObject {
    var allowsEditing:Bool = true
    
    fileprivate var selectorHandler:(([UIImage],[Data])->Void)?
    fileprivate var cameraPicker :UIImagePickerController {
        get{
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.modalTransitionStyle = .flipHorizontal
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.modalPresentationStyle = .overCurrentContext
//            picker.mediaTypes = [kUTTypeImage as String]
            picker.navigationBar.tintColor = UIColor.ds_redText
            picker.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            return picker
        }
    }
    fileprivate var imagePicker:TZImagePickerController {
        get{
            let picker = TZImagePickerController(maxImagesCount: 1, delegate: self)
            picker?.allowTakePicture = true
            picker?.allowTakeVideo = false
            picker?.naviBgColor = UIColor.ds_redText
            picker?.allowPickingVideo = false
            picker?.allowCrop = false
//            let height = 3*XJDeviceInfo.screenWidth/4
//            picker?.cropRect = CGRect(x: 0, y: (XJDeviceInfo.screenHeight-height)/2, width: XJDeviceInfo.screenWidth, height: height)
            return picker!
        }
    }
    /// 选择或拍照
    ///
    /// - Parameter complete: 图片,是否是原图
    func showImagePicker(complete:(([UIImage],[Data])->Void)?) {
        selectorHandler = complete
        showActionSheet()
    }
    func ds_showImagePicker(placeholder:String, complete:(([UIImage],[Data])->Void)?) {
        selectorHandler = complete
        ds_showActionSheet(placeholder: placeholder)
    }
    func ds_showPhotoLibraryPicker( complete:(([UIImage],[Data])->Void)?) {
        selectorHandler = complete
        showPhotoLibraryController()
    }
}

// MARK: - 选择提示相关
extension XJImagePicker:DSImagePickerActionSheetDelegate {
   fileprivate func ds_showActionSheet(placeholder:String)  {
        let actionSheet = DSImagePickerActionSheet()
        actionSheet.placeholderImage = placeholder
        actionSheet.delegate = self
        actionSheet.showAlertController(from: UIApplication.shared.topViewController)    
    }
   internal func showPhotoLibrary() {
        showPhotoLibraryController()
    }
    internal func showTakePhotoView() {
        showTakePhotoController()
    }
    fileprivate func showActionSheet()  {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: {[weak self] (action) in
            self?.showTakePhotoController()
        }))
        actionSheet.addAction(UIAlertAction(title: "从相册选", style: .default, handler: {[weak self] (action) in
            self?.showPhotoLibraryController()
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        UIApplication.shared.present(controller: actionSheet)
    }
}

// MARK: - 拍照相关
extension XJImagePicker:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func showTakePhotoController()  {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraPicker.allowsEditing = self.allowsEditing
            UIApplication.shared.present(controller: cameraPicker)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let sourceType = info[.mediaType] as? String
        if sourceType == (kUTTypeImage as String) {
            var image = info[.editedImage] as? UIImage
            var imageData = image?.jpegData(compressionQuality: 1)
            if imageData == nil {
                imageData = image?.pngData()
            }
            if image == nil {
                image = info[.originalImage] as? UIImage
                imageData = image?.jpegData(compressionQuality: 1)
                if imageData == nil {
                    imageData = image?.pngData()
                }
                image = image?.compressImageQuality(0.7)
            }
            picker.dismiss(animated: true) {[weak self] in
                self?.selectorHandler?([image!],[imageData!])
            }
        }
        
    }
}

// MARK: - 相册选择相关
extension XJImagePicker:TZImagePickerControllerDelegate {
    func showPhotoLibraryController() {
        imagePicker.allowCrop = self.allowsEditing
        UIApplication.shared.present(controller: imagePicker)
    }
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        
        if assets.count > 0 {
            let image = photos.first
            if let asset = assets.first as? PHAsset {
                TZImageManager.default()?.getOriginalPhotoData(with: asset, completion: {[weak self] (origainalData, info, isDegraded) in
                    print((origainalData! as NSData).length/1000)
                    self?.selectorHandler?([image!],[origainalData!])
                })
            }
        }
//        if photos.count > 0 {
//            let image = photos.first
////            if isSelectOriginalPhoto {
////                image = image?.compressImageQuality(0.7)
////            }
//        }
    }
    
}
