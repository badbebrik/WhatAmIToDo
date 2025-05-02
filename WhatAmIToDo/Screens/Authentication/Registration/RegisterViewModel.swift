//
//  RegisterViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation

@MainActor
class RegisterViewModel: ObservableObject {
    private let router: RegisterRouter
    private var session: SessionManager

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
    @Published var isLoading   = false
    @Published var alert: AlertState?

    init(router: RegisterRouter, session: SessionManager) {
        self.router = router
        self.session = session
    }

    func onNextStep() {
        switch currentStep {
        case 1: currentStep = 2
        case 2: Task { await signup() }
        case 3: Task { await verifyEmail() }
        default: break
        }
    }

    func onBackStep() {
        if currentStep > 1 {
            currentStep -= 1
        } else {
            router.routeBack()
        }
    }

    // MARK: — бизнес-логика
    private func signup() async {
        guard password == confirmPassword else {
            alert = .init(message: "Passwords mismatch")
            return
        }
        isLoading = true; defer { isLoading = false }
        do {
            print("Starting signup request...")
            let signupResponse: EmptyResponse = try await session.network.request(
                .signup(name: name, email: email, password: password)
            )
            print("Signup successful, sending verification code...")
            
            currentStep = 3
        } catch let error as NetworkError {
            print("Network error occurred: \(error)")
            switch error {
            case .invalidURL:
                alert = .init(message: "Invalid server URL")
            case .invalidResponse(let statusCode):
                alert = .init(message: "Server error: \(statusCode)")
            case .decodingError(let error):
                alert = .init(message: "Data format error: \(error.localizedDescription)")
            case .unknown(let error):
                alert = .init(message: "Unknown error: \(error.localizedDescription)")
            }
        } catch {
            print("Unexpected error: \(error)")
            alert = .init(message: "Unexpected error: \(error.localizedDescription)")
        }
    }

    private func verifyEmail() async {
        let code = code1 + code2 + code3 + code4
        guard code.count == 4 else { alert = .init(message: "Enter 4-digit code"); return }

        isLoading = true; defer { isLoading = false }
        do {
            print("Starting email verification request...")
            let resp: VerifyEmailResponse = try await session.network.request(
                .verifyCode(email: email, code: code)
            )
            print("Email verification successful, saving tokens...")
            session.keychain.saveTokens(access: resp.accessToken,
                                        refresh: resp.refreshToken)
            session.user = resp.user
            session.isLoggedIn = true
            print("Tokens saved, navigating to main...")
            router.routeToMain()
        } catch let error as NetworkError {
            print("Network error occurred: \(error)")
            switch error {
            case .invalidURL:
                alert = .init(message: "Invalid server URL")
            case .invalidResponse(let statusCode):
                alert = .init(message: "Server error: \(statusCode)")
            case .decodingError(let error):
                alert = .init(message: "Data format error: \(error.localizedDescription)")
            case .unknown(let error):
                alert = .init(message: "Unknown error: \(error.localizedDescription)")
            }
        } catch {
            print("Unexpected error: \(error)")
            alert = .init(message: "Unexpected error: \(error.localizedDescription)")
        }
    }

    private func completeRegistration() {
        router.routeToRegistrationSuccess()
    }
}

struct VerifyEmailResponse: Decodable {
    let accessToken:  String
    let refreshToken: String
    let user:         UserResponse
}

struct EmptyResponse: Decodable {}
