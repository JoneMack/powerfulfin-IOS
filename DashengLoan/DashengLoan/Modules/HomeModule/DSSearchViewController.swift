//
//  DSSearchViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/10.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
private let cellIdentifier = "searchCellIdentifier"
class DSSearchViewController: DSTableViewController {
    fileprivate var searView:DSSearchView!
    fileprivate var oragnationArray = [DSOrgation]()
    fileprivate var page:Int = 1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchView()
        configTableView()
    }
    fileprivate func configSearchView() {
        searView = DSSearchView(frame: CGRect(x: 0, y: 0, width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.defaultBarHeight))
        navigationController?.navigationBar.addSubview(searView)
        searView.delegate = self
        searView.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(0)
        }
        searView.searchBar.becomeFirstResponder()
    }
    fileprivate func configTableView()  {
        tableView?.register(DSSearchTableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
        tableView?.rowHeight = 69
        tableView?.separatorStyle = .none
        addRefreshControl(#selector(DSSearchViewController.reloadSearchData))
        self.refreshControl?.tintColor = UIColor.ds_darkText
    }
    override func tableViewType() -> UITableView.Style {
        return .grouped
    }
    override func configNavigationBarApperance() {
        super.configNavigationBarApperance()
        navigationController?.navigationBar.setBackgroundImage(UIImage.ds_image(color: UIColor.white, size: CGSize(width: XJDeviceInfo.screenWidth, height: XJDeviceInfo.naivgaitonBarHeight)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.ds_image(color: UIColor.white, size: CGSize(width: XJDeviceInfo.screenWidth, height: 2))
        navigationController?.navigationBar.barTintColor = UIColor.ds_blackText
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func rt_customBackItem(withTarget target: Any!, action: Selector!) -> UIBarButtonItem! {
        return nil
    }
}

// MARK: - cell内容
extension DSSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oragnationArray.count
//        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DSSearchTableViewCell
        let orgation = oragnationArray[indexPath.row]
        cell.titleLabel?.text = orgation.name
        cell.detailLabel?.text = orgation.address
//        cell.titleLabel?.text = "翡翠教育+++"
//        cell.detailLabel?.text = "北京市海淀区中关村南路111号B座2109"
        return cell
    }
    // MARK:  cell点击，进入分期
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let orgation = oragnationArray[indexPath.row]
        DSApply.default.beginApply(orgation.id ?? "", fromController: self)
        
    }
}

// MARK: - 搜索框变化
extension DSSearchViewController :DSSearchViewDelegate {
    internal func cancelButtonClick() {
        if searView.searchBar.isFirstResponder {
           searView.searchBar.resignFirstResponder()
        }else{
            popViewController()
        }
    }
    internal func searchViewDidBeginEditing(searchView: DSSearchView) {
        
    }
    internal func searchViewDidEndEditing(searchView: DSSearchView) {
        
    }
    internal func searchTextDidChanged(searchView: DSSearchView, text: String?) {
        page = 1
        loadSearchData(text: text ?? "")
    }
}

// MARK: - 获取数据
extension DSSearchViewController {
    @objc fileprivate func reloadSearchData() {
        searView.searchBar.resignFirstResponder()
        page = 1
        loadSearchData(text: searView.searchBar.text ?? "")
    }
    fileprivate func loadSearchData(text:String) {
        DSHomeDataService.searchSchools(name: text, page: page) {[weak self] (searchResult) in
            if self?.page == 1 {
                self?.oragnationArray.removeAll()
            }
            self?.oragnationArray = (self?.oragnationArray ?? []) + (searchResult.list ?? [])
            self?.tableView?.reloadData()
        }
    }
}


