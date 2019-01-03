//
//  DSArray.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/28.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    mutating func removeToLastFrom(_ index:Int) {
        let currentIndex = index
        while currentIndex < count {
            removeLast()
        }
    }
    mutating func removeObjects(from starObjc:Element,to endObjc:Element) {
        if let starIndex = index(of:starObjc) {
            if let lastIndex = index(of: endObjc)  {
                if starIndex < lastIndex {
                    removeSubrange((starIndex+1)..<lastIndex)
                }
            }
        }
    }
    
}
