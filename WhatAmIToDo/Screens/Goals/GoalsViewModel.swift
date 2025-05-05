import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    private var coordinator: NavigationCoordinator?
    private let network: GoalNetworkManager

    @Published var goals: [GoalListItem] = []
    @Published var isLoading = false
    @Published var error: Error?

    init(router _: GoalsRouter, networkManager: GoalNetworkManager = .shared) {
        self.network = networkManager
    }

    // MARK: - Навигация

    func setLocalCoordinator(_ coord: NavigationCoordinator) {
        coordinator = coord
    }

    func onGoalTap(_ goal: GoalListItem) {
        guard let coordinator else { return }
        coordinator.push(GoalDetailRouter(rootCoordinator: coordinator, goalId: goal.id))
    }

    func onCreateGoalTap() {
        guard let coordinator else { return }
        coordinator.push(GoalCreateRouter(rootCoordinator: coordinator))
    }

    // MARK: - Data

    func loadGoals() async {
        isLoading = true; defer { isLoading = false }
        do {
            let resp = try await network.listGoals(
                request: .init(limit: 20, offset: 0, status: nil)
            )
            goals = resp.goals.map(GoalListItem.init)
        } catch {
            self.error = error
        }
    }

    func refresh() async { await loadGoals() }
}
