//
//  SignInViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation

class SignInViewModel: ObservableObject {
    private let router: SignInRouter

    init(router: SignInRouter) {
        self.router = router
    }

    func navigateToRegister() {
        self.router.routeToRegister()
    }

    func navigateToForgotPassword() {
        self.router.routeToForgotPassword()
    }
}
