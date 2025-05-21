//
//  Date+YMD.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation

extension Date {
    var ymd: String {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.timeZone = .current
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self)
    }
}
