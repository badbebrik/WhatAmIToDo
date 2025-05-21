//
//  DateFormatter+HM.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 08.05.2025.
//

import Foundation

extension DateFormatter {
    static let hm: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
}
