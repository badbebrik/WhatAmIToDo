//
//  ForgotPasswordView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct ForgotPasswordView: View {

    @StateObject var viewModel: ForgotPasswordViewModel

    @State var email: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Forgot Password?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Some text with instructions to restore password. Some Text with instructions to restore..")
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)


            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                .padding(.top, 20)
            Button {
                viewModel.navigateToVerifyCode()
            } label: {
                Text("Send code")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.navigateBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }

    }
}

#Preview {
    ForgotPasswordView(viewModel: .init(router: ForgotPasswordRouter.mock))
}
