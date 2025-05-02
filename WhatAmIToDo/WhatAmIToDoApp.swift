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

    var body: some Scene {
        WindowGroup {
            AppNavigationView(appRouter: .init())
        }
        .environmentObject(session)
    }
}
