//
//  AppRouter.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class AppRouter: ObservableObject {
    @Published var paths = NavigationPath()
}

extension AppRouter: NavigationCoordinator {
    func push(_ router: any Routable) {
        DispatchQueue.main.async {
            self.paths.append(router)
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
