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
    fileprivate var homeInfo :DSHomeInfo?
    fileprivate var schoolListView:UIView?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newsView.titleLabel?.start()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        newsView.titleLabel?.stop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationView()
        configSubViews()
        firstLaunchReloadData()
        reloadViewStatus(false)
        NotificationCenter.default.addObserver(self, selector: #selector(DSHomeViewController.reloadHomeData), name: DSApply.applyFinished, object: nil)
        DSUserCenter.default.addListener(self)
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
        bannerView.delegate = self
        contentView.addSubview(bannerView)
        
        newsView.frame = CGRect(x: 0, y: bannerView.frame.maxY+7, width: XJDeviceInfo.screenWidth, height: 32)
        contentView.addSubview(newsView)
        
        loanView = DSHomeLoanView()
        contentView.addSubview(loanView!)
        loanView?.frame = CGRect(x: 0, y: newsView.frame.maxY, width: XJDeviceInfo.screenWidth, height: 255)
       

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
// MARK: - 刷新页面
extension DSHomeViewController {
    func refreshViews()  {
        var bannerArray = [String]()
        let count = homeInfo?.banner?.count ?? 0
        for i in 0..<count {
            let banner = homeInfo?.banner?[i]
            bannerArray.append(banner?.img ?? "")
        }
        
        bannerView.loopView?.arrImage = bannerArray
        var orY = bannerView.frame.maxY
        if homeInfo?.notice?.content?.count == 0 {
            newsView.isHidden = true
        }else{
            newsView.isHidden = false
            newsView.titleLabel?.setTitle(title: homeInfo?.notice?.content ?? "")
            orY = newsView.frame.maxY
        }
        
        loanView?.removeFromSuperview()
        schoolListView?.removeFromSuperview()
        if DSAppearance.appearance.isAudit == false {
            loanView =  DSHomeLoanView.loanView(loanStatus: homeInfo?.loan)
            loanView?.delegate = self
            contentView.addSubview(loanView!)
            loanView?.frame = CGRect(x: 0, y: orY, width: XJDeviceInfo.screenWidth, height: 255)
            
            let height = XJDeviceInfo.screenHeight > (loanView?.frame.maxY)! ? XJDeviceInfo.screenHeight : (loanView?.frame.maxY)!
            contentView.contentSize = CGSize(width: XJDeviceInfo.screenWidth, height: height)

        }else{
            showJiaLanList(orY)
            let height = XJDeviceInfo.screenHeight > (schoolListView?.frame.maxY)! ? XJDeviceInfo.screenHeight : (schoolListView?.frame.maxY)!
            contentView.contentSize = CGSize(width: XJDeviceInfo.screenWidth, height: height)
        }
        
        
    }
}
// MARK: - 各页面跳转
extension DSHomeViewController:DSHomeLoanButtonViewDelegate {
    func bottomBttonClicl(index: Int, action: String?) {
//        let actions = "powerfulfin://apply?id=300650"
        DSRouter.openURL(url: action)
    }
    func searchButtonClick() {
        showSearchViewController()
    }
    @objc fileprivate func showScanViewController()  {
        let scanVC = DSScanViewController()
        pushToNextViewController(scanVC)
    }
    @objc fileprivate func callCustomerService() {
        let phone = homeInfo?.customer_service?.phone
        let phoneTitle = "呼叫:" + (phone ?? "4000029691")
        
        let email = homeInfo?.customer_service?.email
        let emailTitle = "邮箱:" + (email ?? "")
        
        let serviceSheet = UIAlertController(title: "工作时间：每天9：00——19：00", message: nil, preferredStyle: .actionSheet)
        serviceSheet.addAction(UIAlertAction(title: phoneTitle, style: .default, handler: { (action) in
            let callURL = "telprompt://" + (phone ?? "")
            if let url = URL(string: callURL),UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }))
        serviceSheet.addAction(UIAlertAction(title: emailTitle, style: .default, handler: { (action) in
            let callURL = "mailto://" + (email ?? "")
            if let url = URL(string: callURL),UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }))
        serviceSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(serviceSheet, animated: true)
    }
    @objc fileprivate func showSearchViewController() {
        let searchVC = DSSearchViewController()
        pushToNextViewController(searchVC)
    }
}
extension DSHomeViewController:DSHomeBannerViewDelegate {
    func bannerView(_ bannerView:DSHomeBannerView, didSelectedIndex index:Int) {
        if let homeBanner = homeInfo?.banner?[index] {
            if let url = homeBanner.url {
                DSRouter.openURL(url: url)
            }
        }
    }
}
// MARK: - 网络请求
extension DSHomeViewController {
   @objc func reloadHomeData()  {
    if self.refreshControl.isRefreshing == false {
        XJToast.showToastAction()
    }
        DSHomeDataService.loadHomeData {[weak self] (homeData, success) in
            self?.refreshControl.endRefreshing()
            if success == true {
                self?.homeInfo = homeData
                if homeData!.audit?.flag == "1" {
                   DSAppearance.appearance.isAudit = true
                }else{
                    DSAppearance.appearance.isAudit = false
                }
                self?.reloadViewStatus(true)
                self?.refreshViews()
            }else{
                self?.reloadViewStatus(false)
            }
        }
    }
    func reloadViewStatus(_ show:Bool)  {
        bannerView.isHidden = !show
        newsView.isHidden = !show
        if show == true {
            if DSAppearance.appearance.isAudit {
                loanView?.isHidden = true
            }else{
                loanView?.isHidden = false
            }
        }else{
            loanView?.isHidden = true
        }
        
    }
    func firstLaunchReloadData()  {
        if DSUserCenter.default.firstLaunch {
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.reloadHomeData()
            }
        }else{
            reloadHomeData()
        }
    }
    
}
extension DSHomeViewController:DSUserStatusListener {
    func userLoginSuccess() {
        reloadHomeData()
    }
    func userLogoutSuccess() {
        reloadHomeData()
    }
}

// MARK: - jialoan
extension DSHomeViewController {
    func showJiaLanList(_ ory:CGFloat)  {
        
        schoolListView = UIView(frame: CGRect(x: 0, y: ory, width: XJDeviceInfo.screenWidth, height: 700))
        contentView.addSubview(schoolListView!)
        schoolListView?.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 30))
        titleLabel.configLabel(color: UIColor.ds_blackText, font: .ds_boldFont(ptSize: 16))
        titleLabel.text = "申请机构"
        schoolListView?.addSubview(titleLabel)
        
        let indexY:CGFloat = 40
        let rowHeiht :CGFloat = 69
        let count = homeInfo?.audit?.list?.count ?? 0
        if let listArray = homeInfo?.audit?.list {
            
            for index in 0..<count {
                let orgation = listArray[index]
          
                 let cell = DSSearchTableViewCell(style: .default, reuseIdentifier: "11")
                cell.titleLabel?.text = orgation.name
                cell.detailLabel?.text = orgation.address
                cell.frame = CGRect(x: 0, y: indexY+(CGFloat(index) * rowHeiht), width: XJDeviceInfo.screenWidth, height: rowHeiht)
                schoolListView?.addSubview(cell)
                cell.tag = index
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(DSHomeViewController.showSignViewController(tap:)))
                cell.addGestureRecognizer(tapGes)
                
            }
        }
        let height =  indexY + CGFloat(count) * rowHeiht + XJDeviceInfo.tabBarHeight
        schoolListView?.frame = CGRect(x: 0, y: ory, width: XJDeviceInfo.screenWidth, height: height)
        
    }
    @objc fileprivate func showSignViewController(tap:UITapGestureRecognizer)  {
        let signVC = DSSignViewController()
        let index = tap.view?.tag ?? 0
        signVC.orgin = homeInfo?.audit?.list?[index]
        pushToNextViewController(signVC)
    }
}
