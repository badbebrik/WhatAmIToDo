//
//  ForgotPasswordRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class ForgotPasswordRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

extension ForgotPasswordRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = ForgotPasswordViewModel(router: self)
        let view = ForgotPasswordView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension ForgotPasswordRouter {
    static func == (lhs: ForgotPasswordRouter, rhs: ForgotPasswordRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}

extension ForgotPasswordRouter {
    static let mock: ForgotPasswordRouter = .init(rootCoordinator: AppRouter())
}

extension ForgotPasswordRouter {
    func pop() {
        rootCoordinator.popLast()
    }
}
