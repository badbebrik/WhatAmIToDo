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
    @Published var generatedPreview: GeneratedGoalPreview?
    @Published var errorMessage: String?

    private let network = GoalNetworkManager.shared

    var canProceed: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func generatePreview() async {
        guard canProceed else { return }
        isLoading = true; defer { isLoading = false }
        errorMessage = nil

        do {
            let resp = try await network.generateGoal(
                request: .init(
                    title: title,
                    description: description.isEmpty ? nil : description,
                    hoursPerWeek: hoursPerWeek
                )
            )
            generatedPreview = resp.generatedGoal
        } catch let error as URLError where error.code == .timedOut {
            errorMessage = "Генерация цели занимает больше времени, чем ожидалось."
        } catch {
            errorMessage = "Произошла ошибка при генерации предпросмотра: \(error.localizedDescription)"
        }
    }
}
