//
//  SessionManager.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 01.05.2025.
//


import Foundation
import UIKit    
import GoogleSignIn

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()

    @Published var user: UserResponse?
    @Published var isLoggedIn = false

    let network = NetworkManager.shared
    let keychain = KeychainManager.shared

    private(set) var accessToken: String?
    private(set) var refreshToken: String?

    private init() {

        accessToken  = keychain.getAccessToken()
        refreshToken = keychain.getRefreshToken()

        if let _ = keychain.getRefreshToken() {
            Task { await refresh() }
        }
    }

    /// Вход через Google
    func loginWithGoogle(presenting: UIViewController) async throws {
        guard
            let gsConf   = Bundle.main.infoDictionary?["GoogleSignIn"] as? [String: Any],
            let clientID = gsConf["ClientID"] as? String
        else {
            throw AuthError.configuration
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenting)

        guard let idToken = result.user.idToken else {
            throw AuthError.noToken
        }

        let response: LoginResponse = try await network.request(
            .googleLogin(idToken: idToken.tokenString)
        )

        keychain.saveTokens(
            access:  response.accessToken,
            refresh: response.refreshToken
        )

        self.user       = response.user
        self.isLoggedIn = true
        accessToken  = response.accessToken
        refreshToken = response.refreshToken
    }

    /// Refresh-flow: обновляем access, если есть refresh
    func refresh() async {
        do {
            let rt: String = keychain.getRefreshToken() ?? ""
            let resp: RefreshResponse = try await network.request(.refresh(refreshToken: rt))
            keychain.saveTokens(access: resp.accessToken, refresh: resp.refreshToken)
            accessToken  = resp.accessToken
            refreshToken = resp.refreshToken
        } catch {
            await logout()
        }
    }

    func logout() async {
        keychain.clearTokens()
        accessToken = nil
        refreshToken = nil
        self.user       = nil
        self.isLoggedIn = false
    }
}

// MARK: — DTO

struct UserResponse: Decodable {
    let id:    Int
    let email: String
    let name:  String
}

struct LoginResponse: Decodable {
    let accessToken:  String
    let refreshToken: String
    let user:         UserResponse
}

struct RefreshResponse: Decodable {
    let accessToken:  String
    let refreshToken: String
}

enum AuthError: Error {
    case configuration
    case noToken
}
