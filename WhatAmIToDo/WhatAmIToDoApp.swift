//
//  WhatAmIToDoApp.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

@main
struct WhatAmIToDoApp: App {
    var body: some Scene {
        WindowGroup {
            AppNavigationView(appRouter: .init())
        }
    }
}
