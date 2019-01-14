//
//  XJToast.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/21.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class XJToast: NSObject {
    //显示菊花
    class func showToastAction() {
        if Thread.main.isMainThread {
            toastView = self.currentToastView()
            toastView?.removeFromSuperview()
            let AppDlgt = UIApplication.shared.delegate as! AppDelegate
            AppDlgt.window?.addSubview(toastView!)
            
            let indicatorView = toastView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: 70/2, y: 70/2)
            indicatorView.startAnimating()
            toastView?.frame = CGRect.init(x: (XJDeviceInfo.screenWidth-70)/2, y: (XJDeviceInfo.screenHeight-70)/2, width: 70, height: 70)
            toastView?.alpha = 1
        }else{
            DispatchQueue.main.async {
                self.showToastAction()
            }
            return
        }
    }
    
    //隐藏菊花
    class func hiddenToastAction() {
        if toastView != nil {
            let indicatorView = toastView?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.stopAnimating()
            toastView?.alpha = 0
            toastView?.removeFromSuperview()
        }
    }
    
    //默认显示消息-->center
    class func showToastAction(message : String) {
        self.showToast(message: message, aLocationStr: "center", aShowTime: 5.0)
    }
    
    //显示消息
    class func showToast(message : String?, aLocationStr : String?, aShowTime : TimeInterval) {
        if Thread.current.isMainThread {
            toastLabel = self.currentToastLabel()
            toastLabel?.removeFromSuperview()
            
            let AppDlgt = UIApplication.shared.delegate as! AppDelegate
            AppDlgt.window?.addSubview(toastLabel!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > (XJDeviceInfo.screenWidth - 20) {
                width = XJDeviceInfo.screenWidth - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            var labFrame = CGRect.zero
            if aLocationStr != nil, aLocationStr == "top" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.15, width: width, height: height)
            }else if aLocationStr != nil, aLocationStr == "bottom" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.85, width: width, height: height)
            }else{
                //default-->center
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.5, width: width, height: height)
            }
            toastLabel?.frame = labFrame
            toastLabel?.text = message as String?
            toastLabel?.alpha = 1
            UIView.animate(withDuration: aShowTime, animations: {
                toastLabel?.alpha = 0;
            })
        }else{
            DispatchQueue.main.async {
                self.showToast(message: message, aLocationStr: aLocationStr, aShowTime: aShowTime)
            }
            return
        }
    }
    
    
    
    //显示(带菊花的消息)-->default center
    class func showIndicatorToastAction(message : String) {
        self.showIndicatorToast(message: message, aLocationStr: "center", aShowTime: 2.0)
    }
    
    
    //显示(带菊花的消息)
    class func showIndicatorToast(message : String?, aLocationStr : String?, aShowTime : TimeInterval) {
        if Thread.current.isMainThread {
            toastViewLabel = self.currentToastViewLabel()
            toastViewLabel?.removeFromSuperview()
            let appDlgt = UIApplication.shared.delegate as! AppDelegate
            appDlgt.window?.addSubview(toastViewLabel!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            var height : CGFloat = 0
            if width > (XJDeviceInfo.screenWidth - 20) {
                width = XJDeviceInfo.screenWidth - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }else{
                height = 40
            }
            
            var labFrame = CGRect.zero
            if aLocationStr != nil, aLocationStr == "top" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.15, width: width, height: 60+height)
            }else if aLocationStr != nil, aLocationStr == "bottom" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.85, width: width, height: 60+height)
            }else{
                //default-->center
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.5, width: width, height: 60+height)
            }
            toastViewLabel?.frame = labFrame
            toastViewLabel?.alpha = 1
            
            let indicatorView = toastViewLabel?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: width/2, y: 70/2)
            indicatorView.startAnimating()
            
            let aLabel = toastViewLabel?.viewWithTag(11) as! UILabel
            aLabel.frame = CGRect.init(x: 0, y: 60, width: width, height: height)
            aLabel.text = message as String?
        } else {
            DispatchQueue.main.async {
                self.showIndicatorToast(message: message, aLocationStr: aLocationStr, aShowTime: aShowTime)
            }
            return
        }
    }
    
    //隐藏(带菊花的消息)
    class func hiddenIndicatorToastAction() {
        if toastViewLabel != nil {
            let indicatorView = toastViewLabel?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.stopAnimating()
            toastViewLabel?.alpha = 0
            toastViewLabel?.removeFromSuperview()
        }
    }
    
    class func showProgressToastAction(message:String?){
        self.showProgressToast(message: message, aLocationStr: "center")
    }
    class func setProgress(progress:CGFloat) {
        if toastViewProgress != nil {
            
            if progress > 0 {
                let indicatorView = toastViewProgress?.viewWithTag(10) as! UIActivityIndicatorView
                if indicatorView.isAnimating {
                    indicatorView.stopAnimating()
                }
            }
            let progressView = toastViewProgress?.viewWithTag(12) as! ProgressView
            if progressView.isHidden {
                progressView.isHidden = false
            }
            progressView.setProgress(progress: progress, time: 1.0, animate: true)
            if progress == 1 {
                self.hiddenProgressToastAction()
            }
        }
    }
    class func hiddenProgressToastAction(){
        if toastViewProgress != nil {
            let indicatorView = toastViewProgress?.viewWithTag(10) as! UIActivityIndicatorView
            if indicatorView.isAnimating {
                indicatorView.stopAnimating()
            }
            toastViewProgress?.alpha = 0
            toastViewProgress?.removeFromSuperview()
        }
    }
    //展示进度条
    class func showProgressToast(message:String?,aLocationStr : String?) {
        if Thread.current.isMainThread {
            toastViewProgress = self.currentToastViewProgress()
            toastViewProgress?.removeFromSuperview()
            let appDlgt = UIApplication.shared.delegate as! AppDelegate
            appDlgt.window?.addSubview(toastViewProgress!)
            
            var width = self.stringText(aText: message, aFont: 16, isHeightFixed: true, fixedValue: 40)
            width += 20
            var height : CGFloat = 40
            if width > (XJDeviceInfo.screenWidth - 20) {
                width = XJDeviceInfo.screenWidth - 20
                height = self.stringText(aText: message, aFont: 16, isHeightFixed: false, fixedValue: width)
            }
            
            var labFrame = CGRect.zero
            if aLocationStr != nil, aLocationStr == "top" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.15, width: width, height: 60+height)
            }else if aLocationStr != nil, aLocationStr == "bottom" {
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.85, width: width, height: 60+height)
            }else{
                //default-->center
                labFrame = CGRect.init(x: (XJDeviceInfo.screenWidth-width)/2, y: XJDeviceInfo.screenHeight*0.45, width: width, height: 60+height)
            }
            toastViewProgress?.frame = labFrame
            toastViewProgress?.alpha = 1
            
            let progressView = toastViewProgress?.viewWithTag(12) as! ProgressView
            progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            progressView.center = CGPoint.init(x: width/2, y: 70/2)
            progressView.isHidden = true
            
            let indicatorView = toastViewProgress?.viewWithTag(10) as! UIActivityIndicatorView
            indicatorView.center = CGPoint.init(x: width/2, y: 70/2)
            indicatorView.startAnimating()
            
            let aLabel = toastViewProgress?.viewWithTag(11) as! UILabel
            aLabel.frame = CGRect.init(x: 0, y: 60, width: width, height: height)
            aLabel.text = message as String?
            
        }else{
            DispatchQueue.main.async {
                showProgressToast(message: message, aLocationStr: aLocationStr)
            }
        }
    }
    
}
extension XJToast {
    static var toastView : UIView?
    class func currentToastView() -> UIView {
        objc_sync_enter(self)
        if toastView == nil {
            toastView = UIView.init()
            toastView?.backgroundColor = UIColor.darkGray
            toastView?.layer.masksToBounds = true
            toastView?.layer.cornerRadius = 5.0
            toastView?.alpha = 0
            
            let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastView?.addSubview(indicatorView)
        }
        objc_sync_exit(self)
        return toastView!
    }
    
    static var toastLabel : UILabel?
    class func currentToastLabel() -> UILabel {
        objc_sync_enter(self)
        if toastLabel == nil {
            toastLabel = UILabel.init()
            toastLabel?.backgroundColor = UIColor.darkGray
            toastLabel?.font = UIFont.systemFont(ofSize: 16)
            toastLabel?.textColor = UIColor.white
            toastLabel?.numberOfLines = 0;
            toastLabel?.textAlignment = .center
            toastLabel?.lineBreakMode = .byCharWrapping
            toastLabel?.layer.masksToBounds = true
            toastLabel?.layer.cornerRadius = 5.0
            toastLabel?.alpha = 0;
        }
        objc_sync_exit(self)
        return toastLabel!
    }
    
    static var toastViewLabel : UIView?
    class func currentToastViewLabel() -> UIView {
        objc_sync_enter(self)
        if toastViewLabel == nil {
            toastViewLabel = UIView.init()
            toastViewLabel?.backgroundColor = UIColor.darkGray
            toastViewLabel?.layer.masksToBounds = true
            toastViewLabel?.layer.cornerRadius = 5.0
            toastViewLabel?.alpha = 0
            
             let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastViewLabel?.addSubview(indicatorView)
            
            let aLabel = UILabel.init()
            aLabel.tag = 11
            aLabel.backgroundColor = toastViewLabel?.backgroundColor
            aLabel.font = UIFont.systemFont(ofSize: 16)
            aLabel.textColor = UIColor.white
            aLabel.textAlignment = .center
            aLabel.lineBreakMode = .byCharWrapping
            aLabel.layer.masksToBounds = true
            aLabel.layer.cornerRadius = 5.0
            aLabel.numberOfLines = 0;
            toastViewLabel?.addSubview(aLabel)
        }
        objc_sync_exit(self)
        return toastViewLabel!
    }
    static var toastViewProgress:UIView?
    class func currentToastViewProgress() -> UIView {
        objc_sync_enter(self)
        if toastViewProgress == nil {
            toastViewProgress = UIView()
            toastViewProgress?.backgroundColor = UIColor.darkGray
            toastViewProgress?.layer.masksToBounds = true
            toastViewProgress?.layer.cornerRadius = 5.0
            toastViewProgress?.alpha = 0
            
            let progressView = ProgressView()
            progressView.tag = 12
            progressView.isHidden = true
            toastViewProgress?.addSubview(progressView)
            
            let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
            indicatorView.tag = 10
            indicatorView.hidesWhenStopped = true
            indicatorView.color = UIColor.white
            toastViewProgress?.addSubview(indicatorView)
            
            let aLabel = UILabel.init()
            aLabel.tag = 11
//            aLabel.backgroundColor = toastViewLabel?.backgroundColor
            aLabel.font = UIFont.systemFont(ofSize: 16)
            aLabel.textColor = UIColor.white
            aLabel.textAlignment = .center
            aLabel.lineBreakMode = .byCharWrapping
            aLabel.layer.masksToBounds = true
            aLabel.layer.cornerRadius = 5.0
            aLabel.numberOfLines = 0;
            toastViewProgress?.addSubview(aLabel)
        }
        objc_sync_exit(self)
        return toastViewProgress!
    }
    
}

// MARK: - 配置
extension XJToast {
    //根据字符串长度获取对应的宽度或者高度
    class func stringText(aText : String?, aFont : CGFloat, isHeightFixed : Bool, fixedValue : CGFloat) -> CGFloat {
        var size = CGSize.zero
        if isHeightFixed == true {
            size = CGSize.init(width: CGFloat(MAXFLOAT), height: fixedValue)
        }else{
            size = CGSize.init(width: fixedValue, height: CGFloat(MAXFLOAT))
        }
        //返回计算出的size
        let resultSize = aText?.boundingRect(with: size, options: (NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue)), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: aFont)], context: nil).size
        if isHeightFixed == true {
            return resultSize!.width + 20 //增加左右20间隔
        } else {
            return resultSize!.height + 20 //增加上下20间隔
        }
    }
}
class ProgressView: UIView {
    var progressProperty = ProgressProgerty.init()
    private let progressLayer = CAShapeLayer()
    
    init(propressProperty:ProgressProgerty,frame:CGRect) {
        self.progressProperty = propressProperty
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(ovalIn: bounds).cgPath
        let tracklayer = CAShapeLayer()
        tracklayer.frame = bounds
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = UIColor(white: 1, alpha: 0.2).cgColor
        tracklayer.lineWidth = progressProperty.width!
        tracklayer.path = path
        layer.addSublayer(tracklayer)
        
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressProperty.progressColor?.cgColor
        progressLayer.lineWidth = progressProperty.width!
        progressLayer.path = path
        progressLayer.strokeStart = progressProperty.progressStart!
        progressLayer.strokeEnd = progressProperty.progressEnd!
        layer.addSublayer(progressLayer)
        
        setProgress(progress: 0.05, time: 1, animate: false)
    }
    
    func setProgress(progress:CGFloat,time:CFTimeInterval,animate:Bool){
        CATransaction.begin()
        CATransaction.setDisableActions(!animate)
        CATransaction.setAnimationDuration(time)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut))
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
}
struct ProgressProgerty {
    var width : CGFloat?
    var trackColor : UIColor?
    var progressColor : UIColor?
    var progressStart : CGFloat?
    var progressEnd : CGFloat?
    
    init(width:CGFloat, progressEnd:CGFloat, progressColor:UIColor) {
        self.width = width
        self.progressEnd = progressEnd
        self.progressColor = progressColor
        trackColor = UIColor.gray
        progressStart = 0.0
    }
    
    init() {
        width = 2
        trackColor = UIColor.clear
        progressColor = UIColor.white
        progressStart = 0.0
        progressEnd = 1
    }
}
