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

    open var urlString:String = ""
    fileprivate let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (maker) in
            maker.top.left.bottom.right.equalToSuperview().offset(0)
        }
        let url  = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    


}
