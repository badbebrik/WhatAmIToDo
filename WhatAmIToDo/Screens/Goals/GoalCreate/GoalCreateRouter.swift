//
//  GoalCreateRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import SwiftUI

class GoalCreateRouter {
    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
}

extension GoalCreateRouter: Routable {
    func makeView() -> AnyView {
        let viewModel = GoalCreateViewModel(router: self)
        let view = GoalCreateView(viewModel: viewModel)
        return AnyView(view)
    }
    
    static func == (lhs: GoalCreateRouter, rhs: GoalCreateRouter) -> Bool {
        return false
    }

    func hash(into hasher: inout Hasher) {

    }
}


extension GoalCreateRouter {
    func pop() {
        self.rootCoordinator.popLast()
    }
}
