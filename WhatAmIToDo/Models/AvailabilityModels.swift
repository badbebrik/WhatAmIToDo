//
//  AvailabilityModels.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 08.05.2025.
//

import Foundation


enum DayOfWeek: Int, CaseIterable, Identifiable {
    case mon = 1, tue, wed, thu, fri, sat, sun
    var id: Int { rawValue }

    var shortName: String {
        switch self {
        case .mon: "Пн"
        case .tue:
            "Вт"
        case .wed:
            "Ср"
        case .thu:
            "Чт"
        case .fri:
            "Пт"
        case .sat:
            "Сб"
        case .sun:
            "Вс"
        }
    }

    var fullName: String {
        switch self {
        case .mon: "Понедельник"; case .tue: "Вторник"
        case .wed: "Среда"; case .thu: "Четверг"
        case .fri: "Пятница"; case .sat: "Суббота"
        case .sun: "Воскресенье"
        }
    }
}

struct DayAvailabilityItem: Identifiable {
    var id: DayOfWeek { day }
    let day: DayOfWeek
    var slots: [TimeSlotItem]
}


struct TimeSlotItem: Identifiable, Comparable {
    let id = UUID()
    let start: Date
    let end: Date

    var formatted: String {
        "\(DateFormatter.hm.string(from: start)) – \(DateFormatter.hm.string(from: end))"
    }

    static func < (l: Self, r: Self) -> Bool { l.start < r.start }
}


private extension DateFormatter {
    static let hm: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }()
}
