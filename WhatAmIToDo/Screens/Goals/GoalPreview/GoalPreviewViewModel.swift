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
    private let network = GoalNetworkManager.shared

    init(preview: GeneratedGoalPreview) {
        self.preview = preview
    }


    func saveGoal() async {
        isSaving = true; defer { isSaving = false }
        do {
            _ = try await network.createGoal(
                request: preview.asCreateGoalRequest()
            )
        } catch {
            // TODO: показать алерт
            print(error)
        }
    }
}
