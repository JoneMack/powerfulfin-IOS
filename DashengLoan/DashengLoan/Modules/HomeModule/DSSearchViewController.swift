//
//  DSSearchViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/10.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSSearchViewController: DSTableViewController {
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "请输入机构名称/编号"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width-30, height: XJDeviceInfo.naivgaitonBarHeight)
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }

}
extension DSSearchViewController :UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        popViewController()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
}
