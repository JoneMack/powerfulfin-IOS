//
//  DSViewController.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/7.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

class DSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
extension DSViewController : XJSwipToPopBackDelegate {
    func canSwipToPopBack() -> Bool {
        return true
    }
    func pushToNextViewController(_ viewController:UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
