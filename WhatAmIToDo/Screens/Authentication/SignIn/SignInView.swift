//
//  LoginView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {

    @StateObject var viewModel: SignInViewModel
    @EnvironmentObject private var session: SessionManager

    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordHidden: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            Text("WhatAmIToDo")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

            SecureInput(title: "Password", text: $viewModel.password)

            Button("Forgot password?") {
                viewModel.navigateToForgotPassword()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Button {
                viewModel.signInWithEmail()
            } label: {
                Text("Sign In")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .cornerRadius(8)
            }

            Button {
                viewModel.signInWithGoogle(from: UIApplication.shared.windows.first!)
            } label: {
                HStack {
                    Image(systemName: "g.circle")
                    Text("Continue with Google")
                }
                .frame(maxWidth: .infinity)
                .padding().overlay(RoundedRectangle(cornerRadius: 8).stroke())
            }
            .padding(.top, 8)

            HStack {
                Text("Don't have an account?")
                Button {
                    viewModel.navigateToRegister()
                } label: {
                    Text("Sign Up")
                }
            }
            .padding(.top, 10)

        }
        .padding()
        .overlay { if viewModel.isLoading { ProgressView().scaleEffect(1.4) } }
        .alert(item: $viewModel.alert) {
                    Alert(title: Text("Error"), message: Text($0.message), dismissButton: .default(Text("OK")))
                }
    }

    private struct SecureInput: View {
        let title: String
        @Binding var text: String
        @State private var isHidden = true

        var body: some View {
            ZStack(alignment: .trailing) {
                Group {
                    if isHidden { SecureField(title, text: $text) }
                    else        { TextField(title, text: $text) }
                }
                .padding(.trailing, 40)

                Button { isHidden.toggle() } label: {
                    Image(systemName: isHidden ? "eye.slash" : "eye").foregroundColor(.gray)
                }.padding(.trailing, 8)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.5)))
        }
    }
}

