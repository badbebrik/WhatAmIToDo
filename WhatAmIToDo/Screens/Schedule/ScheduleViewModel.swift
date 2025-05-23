//
//  ScheduleViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation

@MainActor final class ScheduleViewModel: ObservableObject {
    @Published var selectedDate: Date = .now
    @Published var tasks: [ScheduledTaskItem] = []
    @Published var isLoading = false
    @Published var motivation: String?

    private var network = ScheduleNetworkManager.shared

    func initialLoad() async {
        await load(for: selectedDate)
        await loadMotivation()
    }

    func load(for date: Date) async {
        isLoading = true; defer { isLoading = false }
        do {
            let resp = try await network.schedule(for: date)
            tasks = resp.tasks.map(ScheduledTaskItem.init)
        } catch {
            tasks = []
            print("Schedule error:", error.localizedDescription)
        }
    }

    private func loadMotivation() async {
        do {
            let mResp: MotivationTodayResponse = try await network.motivationToday()
            motivation = mResp.motivation
        } catch {
            motivation = nil
        }
    }
}
