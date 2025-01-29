//
//  LoginView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct SignInView: View {

    @StateObject var viewModel: SignInViewModel

    var body: some View {
        Text("SignInView")
            .font(.largeTitle)
            .fontWeight(.bold)
        Button("To Register") {
            viewModel.navigateToRegister()
        }
    }
}

#Preview {
    SignInView(viewModel: .init(router: SignInRouter.mock))
}
