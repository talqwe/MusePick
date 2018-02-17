//
//  DateFirebase.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 16/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation

extension Date {
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    static func fromFirebase(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    func toFirebase()->Double{
        return floor(self.timeIntervalSince1970/1000000000) // Epoch in Sec
    }
    
    static func fromFirebase(_ interval:Double)->Date{
        return Date(timeIntervalSince1970: (interval/1000000000))
    }
}
