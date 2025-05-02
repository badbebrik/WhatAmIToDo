import SwiftUI

class GoalDetailRouter {
    private let rootCoordinator: NavigationCoordinator
    let goalId: UUID
    
    init(rootCoordinator: NavigationCoordinator, goalId: UUID) {
        self.rootCoordinator = rootCoordinator
        self.goalId = goalId
    }
}

// MARK: - Hashable implementation
extension GoalDetailRouter: Routable {
    static func == (lhs: GoalDetailRouter, rhs: GoalDetailRouter) -> Bool {
        lhs.goalId == rhs.goalId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(goalId)
    }
}

// MARK: - ViewFactory implementation
extension GoalDetailRouter {
    @MainActor func makeView() -> AnyView {
        let viewModel = GoalDetailViewModel(router: self, goalId: goalId)
        let view = GoalDetailView(viewModel: viewModel)
        return AnyView(view)
    }
}

// MARK: - Mock for previews
extension GoalDetailRouter {
    static let mock: GoalDetailRouter = .init(rootCoordinator: AppRouter(), goalId: UUID())
} 