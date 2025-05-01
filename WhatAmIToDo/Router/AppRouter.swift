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
        if isLoggedIn {
            print("isLoggedIn true")
            let signInRouter = SignInRouter(rootCoordinator: self)
            return signInRouter
        } else {
            let signInRouter = SignInRouter(rootCoordinator: self)
            print("isLoggedIn false")
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
