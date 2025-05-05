//
//  GoalCreateViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import Foundation

@MainActor
final class GoalCreateViewModel: ObservableObject {
    @Published var title = ""
    @Published var description = ""
    @Published var hoursPerWeek = 1
    @Published var isLoading = false

    private let router: GoalCreateRouter
    private let network = GoalNetworkManager.shared

    init(router: GoalCreateRouter) {
        self.router = router
    }

    var canProceed: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func generatePreview() async {
        guard canProceed else { return }
        isLoading = true; defer { isLoading = false }

        do {
            let resp = try await network.generateGoal(
                request: .init(
                    title: title,
                    description: description.isEmpty ? nil : description,
                    hoursPerWeek: hoursPerWeek
                )
            )
            router.routeToPreview(resp.generatedGoal)
        } catch {
            // TODO: показать алерт
            print(error)
        }
    }
}
