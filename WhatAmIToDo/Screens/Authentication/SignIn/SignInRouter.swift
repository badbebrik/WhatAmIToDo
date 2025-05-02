//
//  SignInRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class SignInRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }

    func routeToRegister() {
        let router = RegisterRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

// MARK: Hashable implementation
extension SignInRouter: Routable {
    static func == (lhs: SignInRouter, rhs: SignInRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}

// MARK: ViewFactory implementation
extension SignInRouter {
    @MainActor func makeView() -> AnyView {
        let viewModel = SignInViewModel(router: self, session: SessionManager.shared)
        let view = SignInView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension SignInRouter {
    static let mock: SignInRouter = .init(rootCoordinator: AppRouter())
}

extension SignInRouter {
    func routeToForgotPassword() {
        let router = ForgotPasswordRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}

extension SignInRouter {
    func routeToMain() {
        let router = MainRouter(rootCoordinator: self.rootCoordinator)
        rootCoordinator.push(router)
    }
}
