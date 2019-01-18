//
//  DSDate.swift
//  dashengLoan
//
//  Created by liuxiangjing on 2018/12/25.
//  Copyright © 2018 powerfulfin. All rights reserved.
//

import UIKit


extension Date {
    /// 当前的年月日
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
    func year() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.year!
    }

    
    ///  当前时间戳，秒级
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
   
}
