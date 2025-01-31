//
//  RegisterView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct RegisterView: View {

    @StateObject var viewModel: RegisterViewModel

    var body: some View {
        TabView(selection: $viewModel.currentStep) {
            RegistrationStep1View(name: $viewModel.name, onNext: { viewModel.onNextStep()}, onBack:{viewModel.onBackStep()})
                .tag(1)

            RegistrationStep2View(name: $viewModel.name, email: $viewModel.email, password: $viewModel.password, confirmPassword: $viewModel.confirmPassword) {
                viewModel.onNextStep()
            } onBack: {
                viewModel.onBackStep()
            }
            .tag(2)

            RegistrationStep3View(name: $viewModel.name, email: $viewModel.email, code1: $viewModel.code1, code2: $viewModel.code2, code3: $viewModel.code3, code4: $viewModel.code4) {
                viewModel.onNextStep()
            } onBack: {
                viewModel.onBackStep()
            }
            .tag(3)
        }
        .navigationBarBackButtonHidden()
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    RegisterView(viewModel: .init(router: RegisterRouter.mock))
}
