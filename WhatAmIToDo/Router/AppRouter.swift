//
//  AppRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class AppRouter: ObservableObject {
    @Published var paths = NavigationPath()

    func resolveInitialRouter(isLoggedIn: Bool) -> any Routable {
        let hasTokens = KeychainManager.shared.getAccessToken() != nil && KeychainManager.shared.getRefreshToken() != nil
        
        if isLoggedIn || hasTokens {
            print("User is logged in or has tokens, showing main screen")
            return MainRouter(rootCoordinator: self)
        } else {
            print("User is not logged in and has no tokens, showing sign in screen")
            let signInRouter = SignInRouter(rootCoordinator: self)
            return signInRouter
        }
    }
}

extension AppRouter: NavigationCoordinator {
    func push(_ router: any Routable) {
        DispatchQueue.main.async {
            let wrappedRouter = AnyRoutable(router)
            self.paths.append(wrappedRouter)
        }
    }
    func popLast() {
        DispatchQueue.main.async {
            self.paths.removeLast()
        }
    }
    func popToRoot() {
        DispatchQueue.main.async {
            self.paths.removeLast(self.paths.count)
        }
    }
}
