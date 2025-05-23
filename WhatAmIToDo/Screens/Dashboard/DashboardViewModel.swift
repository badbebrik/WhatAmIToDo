//
//  DashboardViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation

@MainActor final class DashboardViewModel: ObservableObject {
    @Published var username: String = "Пользователь"
    @Published var motivation: String?
    @Published var upcoming: [ScheduledTaskItem] = []
    @Published var today: [ScheduledTaskItem] = []
    @Published var stats: StatsResponse?

    @Published var selected: ScheduledTaskItem?

    private let net = ScheduleNetworkManager.shared

    func refreshAll() async {
        async let user: () = loadUser()
        async let motivation: () = loadMotivation()
        async let upcoming: () = loadUpcoming()
        async let today: () = loadToday()
        async let stats: () = loadStats()
        _ = await (user, motivation, upcoming, today, stats)
    }

    func openSchedule() {

    }

    private func loadUser() async {
        struct Me: Decodable {let name: String}
        do { let me: Me = try await NetworkManager.shared.request(.getMe)
            username = me.name
        } catch {
            username = "Гость"
        }
    }

    private func loadMotivation() async {
        do { motivation = try await net.motivationToday().motivation } catch {
            motivation = nil
        }
    }

    private func loadUpcoming() async {
        do { upcoming = try await net.upcomingTasks(limit: 10).map(ScheduledTaskItem.init)}
        catch {upcoming = []}
    }

    private func loadToday() async {
        do {
            today = try await net.schedule(for: Date())
                .tasks.map(ScheduledTaskItem.init)
        } catch {
            today = []
        }
    }

    private func loadStats() async {
        do {stats = try await net.stats()}
        catch {
            stats = nil
        }
    }

    func toggle(_ task: ScheduledTaskItem, to done: Bool) async {
        do {
            try await net.toggleScheduledTask(taskId: task.id, done: done)
            if let idx = upcoming.firstIndex(where: { $0.id == task.id }) {
                upcoming[idx].status = done ? .completed : .pending
            }
            if let idx = today.firstIndex(where: { $0.id == task.id }) {
                today[idx].status = done ? .completed : .pending
            }
        } catch {
            print("toggle error", error)
        }
    }
}
