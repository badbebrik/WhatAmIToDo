import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    private let router: GoalsRouter
    private let networkManager: GoalNetworkManager

    @Published var goals: [GoalListItem] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init(router: GoalsRouter, networkManager: GoalNetworkManager = .shared) {
        self.router = router
        self.networkManager = networkManager
    }
    
    func loadGoals() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = ListGoalsRequest(limit: 20, offset: 0, status: nil)
            let response = try await networkManager.listGoals(request: request)
            goals = response.goals.map { GoalListItem(from: $0) }
        } catch {
            self.error = error
        }
    }
    
    func onGoalTap(_ goal: GoalListItem) {
        router.routeToGoalDetail(goalId: goal.id)
    }

    func onCreateGoalTap() {
        router.routeToGoalCreate()
    }

    func refresh() async {
        await loadGoals()
    }
} 
