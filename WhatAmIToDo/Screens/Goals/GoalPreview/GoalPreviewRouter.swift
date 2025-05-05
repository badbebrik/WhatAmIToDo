//
//  GoalPreviewRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

final class GoalPreviewRouter {
    private let rootCoordinator: NavigationCoordinator
    let preview: GeneratedGoalPreview

    init(rootCoordinator: NavigationCoordinator, preview: GeneratedGoalPreview) {
        self.rootCoordinator = rootCoordinator
        self.preview = preview
    }
}

extension GoalPreviewRouter: Routable {
    @MainActor func makeView() -> AnyView {
        AnyView(
            GoalPreviewView(
                viewModel: GoalPreviewViewModel(router: self, preview: preview)
            )
        )
    }

    static func == (lhs: GoalPreviewRouter, rhs: GoalPreviewRouter) -> Bool { false }
    func hash(into hasher: inout Hasher) {}
}

extension GoalPreviewRouter {
    func pop()          { rootCoordinator.popLast() }
    func popToRoot()    { rootCoordinator.popToRoot() }
}
