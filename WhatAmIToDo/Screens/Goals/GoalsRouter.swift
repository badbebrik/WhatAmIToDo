import SwiftUI

class GoalsRouter {
    private let rootCoordinator: NavigationCoordinator
    
    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func routeToGoalDetail(goalId: UUID) {
        let router = GoalDetailRouter(rootCoordinator: self.rootCoordinator, goalId: goalId)
        rootCoordinator.push(router)
    }

    func routeToGoalCreate() {
        let router = GoalCreateRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: - Hashable implementation
extension GoalsRouter: Routable {
    static func == (lhs: GoalsRouter, rhs: GoalsRouter) -> Bool {
        return false
    }
    
    func hash(into hasher: inout Hasher) {
    }
}

// MARK: - ViewFactory implementation
extension GoalsRouter {
    @MainActor func makeView() -> AnyView {
        let viewModel = GoalsViewModel(router: self)
        let view = GoalsView(viewModel: viewModel)
        return AnyView(view)
    }
}


