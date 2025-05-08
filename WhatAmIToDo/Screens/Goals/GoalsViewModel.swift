import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    private let network: GoalNetworkManager
    @Published var goals: [GoalListItem] = []
    @Published var isLoading = false
    @Published var error: Error?

    init(networkManager: GoalNetworkManager = .shared) {
        self.network = networkManager
    }

    // MARK: - Навигация

    func onGoalTap(_ goal: GoalListItem) {
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
