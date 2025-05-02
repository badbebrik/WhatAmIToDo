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
        Group {
            switch viewModel.currentStep {
            case 1:
                RegistrationStep1View(name: $viewModel.name, onNext:
                                        { viewModel.onNextStep() }, onBack: { viewModel.onBackStep() })
            case 2:
                RegistrationStep2View(name: $viewModel.name, email: $viewModel.email, password: $viewModel.password, confirmPassword: $viewModel.confirmPassword, onNext:
                                        { viewModel.onNextStep() }, onBack: { viewModel.onBackStep() })
            case 3:
                RegistrationStep3View(name: $viewModel.name, email: $viewModel.email, code1: $viewModel.code1, code2: $viewModel.code2, code3: $viewModel.code3, code4:
                                        $viewModel.code4, onNext: { viewModel.onNextStep() }, onBack: { viewModel.onBackStep() })
            default:
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
        .overlay { if viewModel.isLoading { ProgressView().scaleEffect(1.4) } }
        .alert(item: $viewModel.alert) {
            Alert(title: Text("Error"), message: Text($0.message), dismissButton: .default(Text("OK")))
        }
    }
}
