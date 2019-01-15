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
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(webView).offset(2)
        }
        progressView.progressTintColor = UIColor.ds_blueText
        progressView.trackTintColor = UIColor.white
        
        webView.addObserver(self, forKeyPath: webProgressKey, options: .new, context: nil)
        webView.addObserver(self, forKeyPath: webTitleKey, options: .new, context: nil)
        
    }
   fileprivate func loadRequest()  {
        if let url  = URL(string: urlString) {
            if url.host != nil {
                var request = URLRequest(url: url)
                request.timeoutInterval = 5
                webView.load(request)
            }else{
                showURLContent()
            }
        }else{
            showURLContent()
        }
    }
    fileprivate func showURLContent() {
        let contentlabel = UILabel()
        contentlabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 12))
        contentlabel.numberOfLines = 0
        webView.addSubview(contentlabel)
        contentlabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.top.equalTo(10)
            maker.right.equalTo(-15)
        }
        contentlabel.text = urlString
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

extension DSWebViewController:WKUIDelegate {
    ///
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
           let result =  DSRouter.parsingURL(url: url)
            if result.0 == .none || result.0 == .web {
                decisionHandler(.allow)
            }else{
                
                DSRouter.openURL(url: url) {[weak self] (info) in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        var controllers = self?.rt_navigationController?.viewControllers
                        let count = (controllers?.count)!-1
                        let index = count - 1
                        controllers?.removeSubrange(index..<count)
                        self?.rt_navigationController?.viewControllers = controllers!
                    })
                }
                decisionHandler(.cancel)
            }
        }else{
            decisionHandler(.allow)
        }
        
    }
}
extension DSWebViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        if let webError =  (error as NSError).userInfo[NSURLErrorFailingURLStringErrorKey] as? String {
            showErrorLoadTips("\"\(webError)\"加载失败")
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
    }
}
extension DSWebViewController {
    fileprivate func showErrorLoadTips(_ tips:String){
        view.viewWithTag(13)?.removeFromSuperview()
        let contentlabel = UILabel()
        contentlabel.tag = 13
        contentlabel.configLabel(color: .ds_blackText, font: .ds_font(ptSize: 13))
        contentlabel.numberOfLines = 0
        contentlabel.textAlignment = .left
        webView.addSubview(contentlabel)
        contentlabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.top.equalTo(10)
        }
        contentlabel.text = tips
    }
}
