//
//  XJLoopView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2019/2/20.
//  Copyright © 2019 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol XJLoopViewDelegate {
   @objc func loopView(_ loopView:XJLoopView,didShowIndex index:Int,imageView:UIImageView)
   @objc optional func loopView(_ loopView:XJLoopView,didClickIndex index:Int)
}
/// 循环的imageView的基础tag
fileprivate let baseImageViewTag = 10
/// 定时器出发间隔，即：多久滚动一次
fileprivate let spaceTime : TimeInterval = 4

/// 初始化方法
class XJLoopView: UIView {
    
    /// 设置代理
    open weak var delegate:XJLoopViewDelegate?
    /// pageControl的个数，当是1的时候，pageControl不展示，且不再自动循环滚动
    open var count:Int = 1 {
        didSet {
            var width = bounds.width
            let height = bounds.height
            if count > 1 {
                width = bounds.width * 3
                fireTimer()
            }else{
                scrollView.isScrollEnabled = false
            }
            scrollView.contentSize = CGSize(width: width, height: height)
            
            refreshImageViews()
            setPageControlCount()
        }
    }
    
    fileprivate var scrollView :UIScrollView!
    fileprivate var pageControl:UIPageControl!
    fileprivate var timer:Timer?
    fileprivate var currentIndex:Int = 0 {
        didSet{
            refreshImageViews()
            setPageControlCurrentPage(currentIndex)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configScrollView()
        configPageControl()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 循环滚动的View
extension XJLoopView:UIScrollViewDelegate {
    fileprivate func configScrollView() {
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.ds_lightGrayText
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
//        scrollView.scrollsToTop = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalToSuperview()
        }
        let width = bounds.width
        let height = bounds.height

        for index in 0..<3 {
            let imageView = UIImageView()
            scrollView.addSubview(imageView)
            imageView.tag = baseImageViewTag + index
            imageView.backgroundColor = UIColor(R: CGFloat(50*index + 50), G: CGFloat(50*index + 10), B: CGFloat(50*index + 20))
            imageView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(XJLoopView.loopViewClick(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
        }
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            pauseTime()
//        print("手动拖拽啦")
    }
     func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        continueTimer()
        scrollView.isScrollEnabled = false
//        print("松手啦")
    }
     func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
//        print("滚动结束啦")
        let offX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        
        if offX < width { // 向左 --
            var index = currentIndex - 1
            if index < 0 {
                index = count - 1
            }
            self.currentIndex = index
        }else if offX > width { // 向右 ++
            var index = currentIndex + 1
            if index > count - 1 {
                index = 0
            }
            self.currentIndex = index
        }else{ // 没动不用管
            
        }
        scrollView.isScrollEnabled = true
    }
   
    fileprivate func refreshImageViews() {
        if count < 1 {return}
        
        if count > 1 {
            for index in 0..<3 {
                if let imageView = scrollView.viewWithTag(baseImageViewTag + index) as? UIImageView {
                    let indexx = indexFromImageInex(index)
                    self.delegate?.loopView(self, didShowIndex: indexx, imageView: imageView)
                }
            }
            let width = bounds.width
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
        }else{

            if let imageView = scrollView.viewWithTag(baseImageViewTag + 0) as? UIImageView {
                let indexx = indexFromImageInex(0)
                self.delegate?.loopView(self, didShowIndex: indexx, imageView: imageView)

            }
        }
    }
    @objc fileprivate func loopViewClick(_ tapges:UITapGestureRecognizer) {
        var index  = (tapges.view?.tag)! - baseImageViewTag
        index = indexFromImageInex(index)
        delegate?.loopView?(self, didClickIndex: index)
        
    }
}

// MARK: - 位置计算
extension XJLoopView {
    /// 根据imageView展示的Index 获取当前数组应该展示的位置，
    fileprivate func indexFromImageInex(_ imageIndex:Int) -> Int {
        
        if imageIndex == 0 {//左边
            var leftIndex = self.currentIndex - 1
            if leftIndex < 0 {
                leftIndex = count - 1
            }
            return leftIndex
        }
        if imageIndex == 1 {
            return self.currentIndex
        }
        if imageIndex == 2 {
            var rightIndex = self.currentIndex + 1
            if rightIndex >= count {
                rightIndex = 0
            }
            return rightIndex
        }
        return 0
    }
}

// MARK: - 定时器管理
extension XJLoopView {

    fileprivate func fireTimer() {
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: spaceTime, target: self, selector: #selector(XJLoopView.showNextImageView), userInfo: nil, repeats: true)
        }
        timer?.fire()
    }
    
    @objc func showNextImageView()  {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                let width = self.bounds.width * 2
                self.scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
            }) { (finish) in
                var index = self.currentIndex + 1
                if index > self.count - 1 {
                    index = 0
                }
                self.currentIndex = index
            }
        }
    }
    fileprivate func invalidateTimer() {
        timer?.invalidate()
    }
    fileprivate func pauseTime() {
        timer?.fireDate = Date.distantFuture
    }
    fileprivate func continueTimer() {
        timer?.fireDate = Date.init(timeIntervalSinceNow: 2)
    }
    
}

// MARK: - pageControl
extension XJLoopView {
    fileprivate func configPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.ds_tintColor
        pageControl.pageIndicatorTintColor = UIColor.white
        addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.right.equalTo(-15)
        }
    }
    
    fileprivate func setPageControlCount() {
        pageControl.numberOfPages = count
    }
    fileprivate func setPageControlCurrentPage(_ page:Int) {
        pageControl.currentPage = page
    }
    
}
