import SwiftUI

class MainRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

extension MainRouter: Routable {
    @MainActor func makeView() -> AnyView {
        let view = MainTabView()
        return AnyView(view)
    }
}

extension MainRouter {
    static func == (lhs: MainRouter, rhs: MainRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {
    }
}

extension MainRouter {
    static let mock: MainRouter = .init(rootCoordinator: AppRouter())
} 