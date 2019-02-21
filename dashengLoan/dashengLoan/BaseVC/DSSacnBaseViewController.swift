//
//  DSSacnBaseViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/1/7.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreGraphics
class DSSacnBaseViewController: DSViewController {
    
    fileprivate(set) var captureSession:AVCaptureSession?

    fileprivate(set) var scanBoxView:UIImageView?
    fileprivate(set) var scanLineView:UIImageView?
    fileprivate(set) var scantimer:CADisplayLink?
    fileprivate var isDownAnimate:Bool = true
    fileprivate var setupDeviceSuccess = false
    var lampButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        checkCaptureDeviceAuthorizationStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        if setupDeviceSuccess {
            startScanRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanRunning()
    }
    // 扫描的区域
    func scanSize() -> CGSize {
        return CGSize.zero
    }
    // 是否展示开启灯光按钮
    func showFlashLampButton(_ show:Bool)  {
        
    }
    func handleResultString(_ result:String)  {
        print(result)
    }
    /// 开始扫描
    func startScanRunning()  {
        startScanViewAnimate()
        captureSession?.startRunning()
    }
    /// 结束扫描
    func stopScanRunning()  {
        stopScanViewAnimate()
        captureSession?.stopRunning()
    }
    func authQRImage(_ data:Data) {
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let image = CIImage(data: data)
        let array = detector?.features(in: image!)
        if array?.count == 0 {
            XJToast.showToastAction(message: "无法是被此二维码")
            return
        }
        if let feature = array?[0] as? CIQRCodeFeature {
           handleResultString(feature.messageString ?? "")
        }
    }

}

// MARK: - 初始化页面
extension DSSacnBaseViewController {
    fileprivate func configViews()  {
        configNavigationView()
        configScanViews()
    }
    fileprivate func configNavigationView() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.title = "扫一扫"
    }
    fileprivate func configScanViews() {
        
        let width = scanSize().width
        let height = scanSize().height
        let orX =  (XJDeviceInfo.screenWidth-width)/2
        let orY = (XJDeviceInfo.screenHeight-height)/2
        
        // 添加扫描框
        scanBoxView = UIImageView()
        scanBoxView?.frame = CGRect(x: orX, y: orY, width: width, height: height)
        view.addSubview(scanBoxView!)
        let scanFrameView = CAShapeLayer()
        let path = CGMutablePath()
        path.addRect(CGRect(x: orX, y: orY, width: width, height: height))
        path.addRect(view.bounds)
        
        scanFrameView.fillRule = .evenOdd
        scanFrameView.path = path
        scanFrameView.fillColor = UIColor.black.cgColor
        scanFrameView.opacity = 0.3
        view.layer.addSublayer(scanFrameView)
        
        // 添加扫描的线
        scanLineView = UIImageView(image: UIImage(named: "sacn_line_icon"))
        scanLineView?.frame = CGRect(x: orX, y: orY, width: width, height: 2)
        view.addSubview(scanLineView!)
    }
}
// MARK: - 扫描动画
extension DSSacnBaseViewController {
    fileprivate func startScanViewAnimate() {
        if scantimer == nil {
            scantimer = CADisplayLink(target: self, selector: #selector( DSSacnBaseViewController.beginScanLineAnimate))
            scantimer?.add(to: RunLoop.current, forMode: .common)
        }
    }
    @objc fileprivate func beginScanLineAnimate(){
        
        let count:CGFloat = 2
        
        let height = scanSize().height
        let orY = (XJDeviceInfo.screenHeight-height)/2
        let endY = orY + height - 2
        var frame = scanLineView!.frame
        
        if isDownAnimate == true {
            frame.origin.y += count
            scanLineView?.frame = frame
            if frame.origin.y > endY {
                isDownAnimate = false
            }
        }else {
            frame.origin.y -= count
            scanLineView?.frame = frame
            if frame.origin.y < orY {
                isDownAnimate = true
            }
        }
    }
    fileprivate func stopScanViewAnimate(){
        // 终止定时器
        scantimer?.invalidate()
        scantimer = nil
    }
    
}
// MARK: - 初始化扫描摄像头
extension DSSacnBaseViewController {
    fileprivate func checkCaptureDeviceAuthorizationStatus(){
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .denied || status == .restricted { //如果是拒绝或者受限状态
            showOpenAuthAlert()
        }else if status == .notDetermined {//未设置的时候，发出询问
            AVCaptureDevice.requestAccess(for: .video) {[weak self] (suucess) in
                DispatchQueue.main.async {
                    self?.setupCameraDevice()
                }
            }
        }else if status == .authorized {//已经允许
            setupCameraDevice()
        }
        
    }
    /// 展示被拒绝的提示
    fileprivate func showOpenAuthAlert() {
        let alertControl = UIAlertController(title: "权限不足", message: "扫一扫功能需要您的摄像头权限，是否前往打开?", preferredStyle:.alert)
        alertControl.addAction(UIAlertAction(title: "前往", style: .default, handler: {(action) in
            // 无权限 引导去开启
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        alertControl.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {[weak self] (alertion) in
           self?.popViewController()
        }))
        present(alertControl, animated: true, completion: nil)
    }
    /// 初始化设备状态
    fileprivate func setupCameraDevice() {
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession!.canAddInput(captureDeviceInput) {
                    captureSession?.addInput(captureDeviceInput)
                }
            } catch {
                
            }
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        if captureSession!.canAddOutput(captureMetadataOutput) {
            captureSession!.addOutput(captureMetadataOutput)
        }
        let tempOutput = AVCaptureVideoDataOutput()
        tempOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        if captureSession!.canAddOutput(tempOutput) {
            captureSession?.addOutput(tempOutput)
        }
        
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let prviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        prviewLayer.videoGravity = .resizeAspectFill
        prviewLayer.frame = CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.screenHeight)
        view.layer.insertSublayer(prviewLayer, at: 0)
        setupDeviceSuccess = true
        startScanRunning()
        
        captureMetadataOutput.rectOfInterest = coverToMetadataOutputRectOfInterest(rect: scanBoxView!.frame)

    }
    // 这个是把期望的扫面区域转换成Output 的坐标。计算方式参考下面博文
    fileprivate func coverToMetadataOutputRectOfInterest(rect:CGRect) -> CGRect {
        // 参考：https://www.jianshu.com/p/8bb3d8cb224e
        let size = CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.screenHeight);
        let  p1 = size.height/size.width;
        let  p2 :CGFloat = 1920/1080
        if (p1 < p2) {
            let  fixHeight = size.width * p2;
            let  fixPadding = (fixHeight - size.height)/2;
            let orX = (rect.origin.y + fixPadding)/fixHeight
            let orY = (size.width - (rect.width+rect.origin.x))/size.width
            let width = rect.height/fixHeight
            let height = rect.width/size.width
            return CGRect(x: orX, y: orY, width: width, height: height)
            
        } else {
            let fixWidth = size.height * (1/p2);
            let fixPadding = (fixWidth - size.width)/2;
            
            let orX = rect.origin.y/size.height
            let orY = (size.width - (rect.width+rect.origin.x) + fixPadding)/fixWidth
            let width = rect.height/size.height
            let height = rect.width/fixWidth
            
            return CGRect(x: orX, y: orY, width: width, height: height)
        }
        
       
    }
    
}

// MARK: - 扫描过程结果，摄像头代理
extension DSSacnBaseViewController:AVCaptureMetadataOutputObjectsDelegate ,AVCaptureVideoDataOutputSampleBufferDelegate {
    /// 扫描结果回调
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
                if let result = object.stringValue {
                    handleResultString(result)
                    stopScanRunning()
                }
            }
        }
    }
    /// 扫描过程回调
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}



