//
//  RegisterViewModel.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import Foundation

class RegisterViewModel: ObservableObject {
    private let router: RegisterRouter

    init(router: RegisterRouter) {
        self.router = router
    }
}
