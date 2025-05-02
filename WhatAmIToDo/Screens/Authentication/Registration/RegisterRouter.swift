//
//  RegisterRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class RegisterRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }

    func routeToRegistrationSuccess() {
        rootCoordinator.popToRoot()
    }

    func routeBack() {
        rootCoordinator.popLast()
    }
}

extension RegisterRouter: Routable {
    @MainActor func makeView() -> AnyView {
        let viewModel = RegisterViewModel(router: self, session: SessionManager.shared)
        let view = RegisterView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension RegisterRouter {
    static func == (lhs: RegisterRouter, rhs: RegisterRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}

extension RegisterRouter {
    static let mock: RegisterRouter = .init(rootCoordinator: AppRouter())
}
