//
//  CLLoopView.swift
//  CLLoopScrollView
//
//  Created by Chris on 16/1/4.
//  Copyright © 2016年 ChrisLian. All rights reserved.
//

import UIKit

@objc public protocol CLLoopViewDelegate{
    func selectLoopViewPage(idx:Int);
}

public class CLLoopView: UIView,UIScrollViewDelegate {
    
    /**
     初始化
     - returns:
     */
    private func initializeUI(){
        
        let width = self.frame.size.width;
        let height = self.frame.size.height;
        
        loopScrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        loopScrollView.contentSize = CGSize(width: width*3, height: height)
        loopScrollView.showsVerticalScrollIndicator = false
        loopScrollView.showsHorizontalScrollIndicator = false
        loopScrollView.delegate = self
        loopScrollView.isPagingEnabled = true
        loopScrollView.bounces = false
        self.addSubview(loopScrollView)
        
        pageControl.frame = CGRect(x: 0, y: height-20, width: width, height: 20)
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor
        self.addSubview(pageControl)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(CLLoopView.tapGestureHandle(tap:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        loopScrollView.addGestureRecognizer(tap)
        
        
        imageView0.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageView1.frame = CGRect(x: width, y: 0, width: width, height: height)
        imageView2.frame = CGRect(x: width * 2.0, y: 0, width: width, height: height)
        imageView0.backgroundColor = UIColor.ds_lineGrayColor
        imageView1.backgroundColor = UIColor.ds_lineGrayColor
        imageView2.backgroundColor = UIColor.ds_lineGrayColor
 
        loopScrollView.addSubview(imageView0)
        loopScrollView.addSubview(imageView1)
        loopScrollView.addSubview(imageView2)
    }
    
    //MARK: - life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        self.stopTimer()
    }
    
    //MARK: - UIScrollView delegate
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let ratio = scrollView.contentOffset.x/self.frame.size.width
        self.endScrollMethod(ratio: ratio)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            let ratio = scrollView.contentOffset.x/self.frame.size.width
            self.endScrollMethod(ratio: ratio)
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    //MARK: - reload data
    private func updateImageData(){
        if arrImage.count < 2 { return}
        if currentPage == 0 {
            imageView0.setImage(arrImage.last)
            imageView1.setImage(arrImage[currentPage])
            imageView2.setImage(arrImage[currentPage + 1])
        }else if currentPage == arrImage.count - 1{
            imageView0.setImage(arrImage[currentPage - 1])
            imageView1.setImage(arrImage[currentPage])
            imageView2.setImage(arrImage.first)
        }else{
            imageView0.setImage(arrImage[currentPage - 1])
            imageView1.setImage(arrImage[currentPage])
            imageView2.setImage(arrImage[currentPage + 1])
        }
        pageControl.currentPage = currentPage
        loopScrollView.contentOffset = CGPoint(x: self.frame.size.width,y: 0)
    }
    
    private func endScrollMethod(ratio:CGFloat){
        
        if ratio <= 0.7{
            if currentPage - 1 < 0{
                currentPage = arrImage.count - 1
            }else{
                currentPage -= 1
            }
        }
        if ratio >= 1.3{
            if currentPage == arrImage.count - 1{
                currentPage = 0
            }else{
                currentPage += 1
            }
        }
        
        self.updateImageData()
        self.startTimer()
    }
    
    private func startTimer(){
        if autoShow {
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(CLLoopView.autoTurnNextView), userInfo: nil, repeats: true)
        }
    }
    private func stopTimer(){
        if autoShow{
            guard let timer = self.timer else{
                return
            }
            if timer.isValid{
                timer.invalidate()
            }
        }
    }
    
    
    //MARK: event response
    @objc fileprivate func tapGestureHandle(tap:UITapGestureRecognizer){
        guard let tmp = delegate else{
            print("delegate is nil")
            return
        }
        tmp.selectLoopViewPage(idx: currentPage)
    }
    @objc private func autoTurnNextView(){
        
        if currentPage == arrImage.count - 1{
            currentPage = 0
        }else{
            currentPage += 1
        }
        self.updateImageData()
    }
    
    //MARK: - setter & getter
    private var timer:Timer?       = nil
    private let pageControl:UIPageControl   = UIPageControl()
    private let loopScrollView:UIScrollView = UIScrollView()
    private let imageView0:UIImageView = UIImageView()
    private let imageView1:UIImageView = UIImageView()
    private let imageView2:UIImageView = UIImageView()
    
    
    public weak var delegate:CLLoopViewDelegate? = nil
    /// 当前页
    public var currentPage:Int = 0
    /// 定时跳转到下一页
    public var timeInterval:TimeInterval = 3 {
        willSet{
            if autoShow{
                self.stopTimer()
            }
        }
        didSet{
            if autoShow{
                self.startTimer()
            }
        }
    }
    /// 是否定时跳转到下一页
    public var autoShow:Bool = false{
        didSet{
            if autoShow{
                self.startTimer()
            }else{
                self.stopTimer()
            }
        }
    }
    /// 图片数组
    public var arrImage:[String] = []{
        willSet{
            currentPage = 0
            pageControl.numberOfPages = newValue.count
        }
        didSet{
            self.updateImageData()
        }
    }
    /// 指示器当前页颜色
    public var currentPageIndicatorTintColor:UIColor = UIColor ( red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0 ){
        willSet{
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    /// 指示器颜色
    public var pageIndicatorTintColor:UIColor = UIColor ( red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0 ){
        willSet{
            pageControl.pageIndicatorTintColor = newValue
        }
    }
}
