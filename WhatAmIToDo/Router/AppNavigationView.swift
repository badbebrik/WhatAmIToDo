//
//  AppNavigationView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct AppNavigationView: View {

    @StateObject var appRouter: AppRouter

    var body: some View {
        NavigationStack(path: $appRouter.paths) {
            appRouter.resolveInitialRouter().makeView()
                .navigationDestination(for: AnyRoutable.self) { router in
                    router.makeView()
                }
        }
    }
}

#Preview {
    AppNavigationView(appRouter: .init())
}
