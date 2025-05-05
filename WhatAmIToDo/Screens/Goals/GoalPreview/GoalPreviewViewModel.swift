//
//  GoalPreviewViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import Foundation

@MainActor
final class GoalPreviewViewModel: ObservableObject {
    @Published var isSaving = false

    let preview: GeneratedGoalPreview
    private let router: GoalPreviewRouter
    private let network = GoalNetworkManager.shared

    init(router: GoalPreviewRouter, preview: GeneratedGoalPreview) {
        self.router = router
        self.preview = preview
    }

    func navigateBack() {
        router.pop()
    }

    func saveGoal() async {
        isSaving = true; defer { isSaving = false }
        do {
            _ = try await network.createGoal(
                request: preview.asCreateGoalRequest()
            )
            router.popToRoot()                     // вернулись в список целей
        } catch {
            // TODO: показать алерт
            print(error)
        }
    }
}
