//
//  GoalCreateViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import Foundation

final class GoalCreateViewModel: ObservableObject {
    private let router: GoalCreateRouter

    init(router: GoalCreateRouter) {
        self.router = router
    }

    func navigateBack() {
        self.router.pop()
    }
}
