//
//  DSDate.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit


extension Date {
    static func date(_ dateStr:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone.local
        let dastDate = formatter.date(from: dateStr)
        
        let sysZone = NSTimeZone.system
        let interval = sysZone.secondsFromGMT(for: dastDate!)
        
        let date = dastDate?.addingTimeInterval(TimeInterval(interval))
        return date!
        
        
    }
}
