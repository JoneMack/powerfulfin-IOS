//
//  DSHomeViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSHomeViewController: DSViewController {
    fileprivate let contentView = UIScrollView()
    fileprivate var backTopView = UIImageView()
    fileprivate let bannerView = DSHomeBannerView()
    fileprivate let newsView = DSHomeNewsView()
    fileprivate var loanView : DSHomeLoanView?
    fileprivate let refreshControl = UIRefreshControl()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocationService()
        setupNavigationView()
        configSubViews()
        

    }
    func configSubViews()  {
        view.addSubview(contentView)
        if #available(iOS 11.0, *) {
            contentView.contentInsetAdjustmentBehavior = .never
        }
        contentView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(0);
        }
       
        contentView.contentSize = CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.screenHeight)
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        contentView.delegate = self
        
        backTopView.image = UIImage.ds_backgroundImage(CGSize(width: XJDeviceInfo.screenWidth, height: 250))
        backTopView.frame = CGRect(x: 0, y: -150, width: XJDeviceInfo.screenWidth, height: 250)
        contentView.addSubview(backTopView)
        
        bannerView.frame = CGRect(x: 9, y: 9, width: XJDeviceInfo.screenWidth-18, height: 150)
        contentView.addSubview(bannerView)
        
        newsView.frame = CGRect(x: 0, y: bannerView.frame.maxY+7, width: XJDeviceInfo.screenWidth, height: 32)
        contentView.addSubview(newsView)
        
        loanView = DSHomeLoanView()
        contentView.addSubview(loanView!)
        loanView?.frame = CGRect(x: 0, y: newsView.frame.maxY, width: XJDeviceInfo.screenWidth, height: 255)
        let height = XJDeviceInfo.screenHeight > (loanView?.frame.maxY)! ? XJDeviceInfo.screenHeight : (loanView?.frame.maxY)!
        
        contentView.contentSize = CGSize(width: XJDeviceInfo.screenWidth, height: height)

        
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(DSHomeViewController.reloadHomeData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            contentView.refreshControl = refreshControl
            contentView.sendSubviewToBack(backTopView)
        }else{
            contentView.addSubview(refreshControl)
        }
    }
  
}

// MARK: - 定位
extension DSHomeViewController:DSLocationDelegate {
   fileprivate func configLocationService() {
        DSLoactionManager.manager.addListener(listen: self)
        DSLoactionManager.manager.updateUserLoaction()
    }
    internal func userLocationDidUpdate(_ success: Bool, error: Error?) {
        if success {
            print(DSLoactionManager.manager.longitude)
            print(DSLoactionManager.manager.latitude)
        }
    }
}

// MARK: - 导航栏
extension DSHomeViewController {
    fileprivate func setupNavigationView()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "home_icon_scan"), style: .plain, target: self, action: #selector(DSHomeViewController.showScanViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "home_icon_service"), style: .plain, target: self, action: #selector(DSHomeViewController.callCustomerService))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        let titleView = DSHomeSearchControl()
        titleView.addTarget(self, action: #selector(DSHomeViewController.showSearchViewController), for: .touchUpInside)
        navigationItem.titleView = titleView
        titleView.snp.makeConstraints { (maker) in
            maker.top.equalTo(5)
            maker.bottom.equalTo(-5)
            maker.left.equalTo(60)
            maker.right.equalTo(-60)
        }
    }
    
    
    @objc fileprivate func showScanViewController()  {
        
    }
    @objc fileprivate func callCustomerService() {
        
    }
    @objc fileprivate func showSearchViewController() {
        let searchVC = DSSearchViewController()
        pushToNextViewController(searchVC)
    }
}

// MARK: - UIScrollViewDelegate
extension DSHomeViewController:UIScrollViewDelegate  {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        if  offSetY < -150{
            var frame = backTopView.frame
            frame.size.height = -offSetY+100
            frame.origin.y = offSetY
            backTopView.frame = frame
        }
    }
}

// MARK: - Banner点击或者消息点击
extension DSHomeViewController {
    
}

// MARK: - 网络请求
extension DSHomeViewController {
   @objc func reloadHomeData()  {
    print("12345678")
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
        self.refreshControl.endRefreshing()
    }
    }
}
