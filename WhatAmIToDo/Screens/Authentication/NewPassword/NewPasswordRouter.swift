//
//  NewPasswordRoute.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class NewPasswordRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

extension NewPasswordRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = NewPasswordViewModel(router: self)
        let view = NewPasswordView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension NewPasswordRouter {
    static func == (lhs: NewPasswordRouter, rhs: NewPasswordRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}

extension NewPasswordRouter {
    static let mock: NewPasswordRouter = .init(rootCoordinator: AppRouter())
}

extension NewPasswordRouter {
    func pop() {
        rootCoordinator.popLast()
    }

    func routeToMain() {
    }
}
