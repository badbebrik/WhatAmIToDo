//
//  ScheduleModels.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation
import SwiftUI

struct ScheduledTaskItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let start: Date
    let end:   Date
    let status: TaskStatus

    init(dto: ScheduledTaskDTO) {
        self.id     = dto.id
        self.title  = dto.title
        self.start  = dto.startTime.dateHM
        self.end    = dto.endTime.dateHM
        self.status = TaskStatus(rawValue: dto.status) ?? .pending
    }
}

private extension String {
    var dateHM: Date {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.date(from: self) ?? .init()
    }
}
