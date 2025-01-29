//
//  NewPasswordVIew.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct NewPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isNewPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true

    @StateObject var viewModel: NewPasswordViewModel

    var body: some View {
        VStack(spacing: 20) {

            Text("New Password")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Some text with instructions to set new password")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                if isNewPasswordHidden {
                    SecureField("New Password", text: $newPassword)
                        .padding(.trailing, 40)
                } else {
                    TextField("New Password", text: $newPassword)
                        .padding(.trailing, 40)
                }

                Button {
                    isNewPasswordHidden.toggle()
                } label: {
                    Image(systemName: isNewPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .padding(.trailing, 8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

            ZStack {
                if isConfirmPasswordHidden {
                    SecureField("Repeat new password", text: $confirmPassword)
                        .padding(.trailing, 40)
                } else {
                    TextField("Repeat new password", text: $confirmPassword)
                        .padding(.trailing, 40)
                }

                Button {
                    isConfirmPasswordHidden.toggle()
                } label: {
                    Image(systemName: isConfirmPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

            Button {
                viewModel.navigateToMain()
            } label: {
                Text("Update Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(8)
            }

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
    NewPasswordView(viewModel: .init(router: .mock))
}
