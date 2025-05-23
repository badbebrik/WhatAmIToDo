import Foundation

@MainActor
class GoalDetailViewModel: ObservableObject {
    private let networkManager: GoalNetworkManager
    let goalId: UUID

    @Published var goal: GoalDetailItem?
    @Published var isLoading = false
    @Published var error: Error?

    init(goalId: UUID, networkManager: GoalNetworkManager = .shared) {
        self.goalId = goalId
        self.networkManager = networkManager
    }

    func loadGoal() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await networkManager.getGoal(id: goalId)
            goal = GoalDetailItem(from: response)
        } catch {
            self.error = error
        }
    }

    func refresh() async {
        await loadGoal()
    }

    func deleteGoal() async throws {
        try await networkManager.deleteGoal(id: goalId)
    }
}
