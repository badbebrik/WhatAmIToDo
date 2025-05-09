//
//  AvailabilityDTO.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 08.05.2025.
//

import Foundation

struct UpdateAvailabilityRequest: Encodable {
    let days: [DayAvailabilityDTO]
}

struct DayAvailabilityDTO: Codable {
    let dayOfWeek: Int
    let slots: [TimeSlotDTO]

    init(from item: DayAvailabilityItem) {
        dayOfWeek = item.day.rawValue
        slots = item.slots.map(TimeSlotDTO.init)
    }
}

struct AvailabilityResponse: Codable {
    let days: [DayAvailabilityDTO]
}

struct TimeSlotDTO: Codable {
    let startTime: String
    let endTime: String

    init(from slot: TimeSlotItem) {
        let fmt = DateFormatter.hm
        startTime = fmt.string(from: slot.start)
        endTime   = fmt.string(from: slot.end)
    }
}
