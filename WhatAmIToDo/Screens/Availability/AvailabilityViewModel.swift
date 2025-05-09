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

    @Published var selectedDay: DayOfWeek = .mon

    private let goalId: UUID
    private let network: GoalNetworkManager = .shared

    init(goalId: UUID) {
        self.goalId = goalId
    }

    func item(for day: DayOfWeek) -> DayAvailabilityItem? {
        days.first { $0.day == day }
    }

    func addSlot() {
        guard let idx = days.firstIndex(where: { $0.day == selectedDay }) else { return }
        let cal = Calendar.current
        let start = cal.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        let end   = cal.date(byAdding: .hour, value: 1, to: start)!
        days[idx].slots.append(TimeSlotItem(start: start, end: end))
        days[idx].slots.sort()
    }

    func delete(_ slot: TimeSlotItem) {
        guard let dayIdx = days.firstIndex(where: { $0.day == selectedDay }),
              let slotIdx = days[dayIdx].slots.firstIndex(of: slot) else { return }
        days[dayIdx].slots.remove(at: slotIdx)
    }

    func binding(for slot: TimeSlotItem) -> Binding<TimeSlotItem> {
        guard
            let dayIdx  = days.firstIndex(where: { $0.day == selectedDay }),
            let slotIdx = days[dayIdx].slots.firstIndex(of: slot)
        else { return .constant(slot) }

        return Binding<TimeSlotItem>(
            get:  { self.days[dayIdx].slots[slotIdx] },
            set:  { self.days[dayIdx].slots[slotIdx] = $0 }
        )
    }

    func save(_ dismiss: DismissAction) async {
        let body = UpdateAvailabilityRequest(
            days: days
                .filter { !$0.slots.isEmpty }
                .map(DayAvailabilityDTO.init)
        )
        print("[Network] Saving availability:")
        print("[Network] Days count: \(body.days.count)")
        for day in body.days {
            print("[Network] Day: \(day), slots: \(day.slots.count)")
        }
        do {
            _ = try await ScheduleNetworkManager.shared
                .updateAvailability(goalId: goalId, body: body)
            print("[Network] Successfully saved")
            dismiss()
        } catch {
            print("[Network] Error saving: \(error.localizedDescription)")
        }
    }
}
