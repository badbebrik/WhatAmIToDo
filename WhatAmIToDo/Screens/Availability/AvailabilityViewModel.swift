//
//  AvailabilityViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 08.05.2025.
//

import Foundation
import SwiftUI

@MainActor
final class AvailabilityViewModel: ObservableObject {
    @Published var days: [DayAvailabilityItem] = DayOfWeek.allCases.map {
        .init(day: $0, slots: [])
    }

    private let goalId: UUID
    private let network: GoalNetworkManager = .shared

    init(goalId: UUID) {
        self.goalId = goalId
    }

    func slots(for day: DayOfWeek) -> [TimeSlotItem] {
        days.first { $0.day == day }?.slots ?? []
    }

    func setSlots(_ newSlots: [TimeSlotItem], for day: DayOfWeek) {
        guard let idx = days.firstIndex(where: { $0.day == day }) else {
            return
        }
        days[idx].slots = newSlots.sorted()
    }

}
