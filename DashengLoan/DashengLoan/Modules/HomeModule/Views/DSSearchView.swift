//
//  DSSearchView.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/24.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit
@objc protocol DSSearchViewDelegate {
    @objc optional func searchViewDidBeginEditing(searchView:DSSearchView)
    @objc optional func searchViewDidEndEditing(searchView:DSSearchView)
    @objc optional func cancelButtonClick()
    @objc optional func searchTextDidChanged(searchView:DSSearchView,text:String?)
    @objc optional func searchViewSeachButtonClick(searchView:DSSearchView)
    
}
class DSSearchView: UIView {
    var searchBar:DSTextField!
    weak var delegate:DSSearchViewDelegate?
    fileprivate let logoView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        logoView.image = UIImage(named: "search_icon")
        logoView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        searchBar = DSTextField()
        searchBar.leftView = logoView
        searchBar.borderStyle = .none
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.tintColor = UIColor.ds_blackText
        searchBar.leftViewMode = .always
        searchBar.attributedPlaceholder = NSAttributedString(string: "请输入机构名称或编码", attributes: [.foregroundColor:UIColor.ds_grayColor])
        searchBar.backgroundColor = UIColor(hex: "f5f5f5")
        searchBar.layer.cornerRadius = 17
        
        searchBar.textColor = UIColor.ds_blackText
        searchBar.font = UIFont.ds_font(ptSize: 14)
        searchBar.clearButtonMode = .whileEditing
        addSubview(searchBar)
        searchBar.addTarget(self, action: #selector(DSSearchView.searchTextDidChanged), for: .editingChanged)
        searchBar.snp.makeConstraints { (maker) in
            maker.left.equalTo(9)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(34)
        }
        let cancelBtn = UIButton(type: .custom)
        addSubview(cancelBtn)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.ds_blackText, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.ds_font(ptSize: 15)
        cancelBtn.addTarget(self, action: #selector(DSSearchView.cancelSearch), for: .touchUpInside)
        cancelBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-14)
            maker.centerY.equalToSuperview()
            maker.width.equalTo(35)
            maker.left.equalTo(searchBar.snp_rightMargin).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func cancelSearch()  {
        delegate?.cancelButtonClick!()
        
    }
    @objc func searchTextDidChanged()  {
        delegate?.searchTextDidChanged!(searchView: self, text: searchBar.text)
    }
    
}
extension DSSearchView:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchViewDidBeginEditing?(searchView: self)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchViewDidEndEditing?(searchView: self)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.searchViewSeachButtonClick?(searchView: self)
        return true
    }
}
class DSTextField: UITextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 15
        return rect
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 2)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 2)
    }
}
