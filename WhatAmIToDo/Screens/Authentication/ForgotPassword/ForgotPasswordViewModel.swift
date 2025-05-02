//
//  ForgotPasswordViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    private let router: ForgotPasswordRouter

    init(router: ForgotPasswordRouter) {
        self.router = router
    }

    func navigateBack() {
        self.router.pop()
    }

    func navigateToVerifyCode() {
        self.router.routeToVerifyCode()
    }
}
