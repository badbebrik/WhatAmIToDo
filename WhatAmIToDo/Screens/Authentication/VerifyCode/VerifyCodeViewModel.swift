//
//  Untitled.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

class VerifyCodeViewModel: ObservableObject {
    private let router: VerifyCodeRouter

    init(router: VerifyCodeRouter) {
        self.router = router
    }

    func navigateBack() {
        self.router.pop()
    }
}
