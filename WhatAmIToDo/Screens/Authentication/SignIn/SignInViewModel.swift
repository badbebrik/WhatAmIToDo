//
//  SignInViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
final class SignInViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var alert: AlertState?

    @Published var email = ""
    @Published var password = ""

    private let router: SignInRouter
    private let session: SessionManager

    init(router: SignInRouter, session: SessionManager) {
        self.router = router
        self.session = session
    }

    // MARK: Actions

    func signInWithEmail() {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                print("Starting sign in request...")
                let resp: LoginResponse = try await session.network.request(
                    .login(email: email, password: password)
                )
                print("Sign in successful, saving tokens...")
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
    }

    func signInWithGoogle(from view: UIView) {
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let vc = view.findHostingController() ?? UIViewController()
                try await session.loginWithGoogle(presenting: vc)
            } catch {
                alert = .init(message: error.localizedDescription)
            }
        }
    }

    func navigateToRegister()       { router.routeToRegister() }
    func navigateToForgotPassword() { router.routeToForgotPassword() }
}
