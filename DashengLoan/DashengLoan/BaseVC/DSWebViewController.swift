//
//  DSWebViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
import WebKit
class DSWebViewController: DSViewController {
    fileprivate let webProgressKey:String = "estimatedProgress"
    fileprivate let webTitleKey:String = "title"

    open var urlString:String = ""
    
    fileprivate let webView = WKWebView()
    fileprivate let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: 2))
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configSubViews()
        loadRequest()
        
    }
    deinit {
        webView.removeObserver(self, forKeyPath: webProgressKey)
        webView.removeObserver(self, forKeyPath: webTitleKey)

    }
    func configSubViews()  {
        view.addSubview(webView)
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.left.bottom.right.equalTo(0)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(webView).offset(0)
            
        }
        progressView.progressTintColor = UIColor.ds_tintColor
        progressView.trackTintColor = UIColor.white
        
        webView.addObserver(self, forKeyPath: webProgressKey, options: .new, context: nil)
         webView.addObserver(self, forKeyPath: webTitleKey, options: .new, context: nil)
        
    }
    func loadRequest()  {
        if let url  = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// MARK: - KVO
extension DSWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == webTitleKey) {
            self.navigationItem.title = self.webView.title;
        }
        if keyPath == webProgressKey && object as? WKWebView == webView {
            let value : NSNumber = change?[NSKeyValueChangeKey.newKey] as! NSNumber
            if value.floatValue == 1 {
                progressView.isHidden = true
                progressView.setProgress(0, animated: false)
            }else{
                progressView.isHidden = false
                progressView.setProgress(value.floatValue, animated: true)
            }
        }
    }
}
