//
//  Date+HM.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation

extension Date {
    var hm: String {
        let df = DateFormatter.hm
        return df.string(from: self)
    }
}
