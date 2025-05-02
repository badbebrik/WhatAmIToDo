//
//  WhatAmIToDoApp.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI
import GoogleSignInSwift

@main
struct WhatAmIToDoApp: App {

    @StateObject var session = SessionManager.shared
    @StateObject var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            AppNavigationView(appRouter: .init())
                .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : 
                                    themeManager.currentTheme == .light ? .light : nil)
        }
        .environmentObject(session)
    }
}
