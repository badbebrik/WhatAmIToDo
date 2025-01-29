//
//  NewPasswordViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class NewPasswordViewModel: ObservableObject {
    private let router: NewPasswordRouter

    init(router: NewPasswordRouter) {
        self.router = router
    }

    func navigateBack() {
        self.router.pop()
    }

    func navigateToMain() {
        self.router.routeToMain()
    }
}
