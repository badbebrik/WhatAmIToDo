//
//  RegisterViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation

class RegisterViewModel: ObservableObject {
    private let router: RegisterRouter

    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var verificationCode: String = ""

    @Published var code1: String = ""
    @Published var code2: String = ""
    @Published var code3: String = ""
    @Published var code4: String = ""

    @Published var currentStep: Int = 1

    init(router: RegisterRouter) {
        self.router = router
    }

    func onNextStep() {
        if currentStep < 3 {
            currentStep += 1
        } else {
            completeRegistration()
        }
    }

    func onBackStep() {
        if currentStep > 1 {
            currentStep -= 1
        } else {
            router.routeBack()
        }
    }

    private func completeRegistration() {
        router.routeToRegistrationSuccess()
    }
}
