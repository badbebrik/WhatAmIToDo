//
//  VerifyCodeRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class VerifyCodeRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

extension VerifyCodeRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = VerifyCodeViewModel(router: self)
        let view = VerifyCodeView(viewModel: viewModel)
        return AnyView(view)
    }
}

extension VerifyCodeRouter {
    static func == (lhs: VerifyCodeRouter, rhs: VerifyCodeRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}

extension VerifyCodeRouter {
    static let mock: VerifyCodeRouter = .init(rootCoordinator: AppRouter())
}

extension VerifyCodeRouter {
    func pop() {
        self.rootCoordinator.popLast()
    }
}
