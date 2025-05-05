import Foundation

@MainActor
class GoalDetailViewModel: ObservableObject {
    private let router: GoalDetailRouter
    private let networkManager: GoalNetworkManager
    let goalId: UUID
    
    @Published var goal: GoalDetailItem?
    @Published var isLoading = false
    @Published var error: Error?
    
    init(router: GoalDetailRouter, goalId: UUID, networkManager: GoalNetworkManager = .shared) {
        self.router = router
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
} 
