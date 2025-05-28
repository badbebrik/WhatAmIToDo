//
//  AppNavigationView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct AppNavigationView: View {

    @StateObject var appRouter: AppRouter
    @EnvironmentObject var session: SessionManager

    private var isLoggedInOrHasTokens: Bool {
        session.isLoggedIn ||
        (KeychainManager.shared.getAccessToken() != nil && KeychainManager.shared.getRefreshToken() != nil)
    }

    var body: some View {
        if isLoggedInOrHasTokens {
            MainTabView(rootCoordinator: appRouter)
        } else {
            NavigationStack(path: $appRouter.paths) {
                SignInRouter(rootCoordinator: appRouter)
                    .makeView()
                    .navigationDestination(for: AnyRoutable.self) { $0.makeView() }
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    AppNavigationView(appRouter: .init())
}
