//
//  LoginView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct SignInView: View {

    @StateObject var viewModel: SignInViewModel

    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordHidden: Bool = true

    var body: some View {
        VStack {
            Text("WhatAmIToDo")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

            ZStack {
                if isPasswordHidden {
                    SecureField("Password", text: $password)
                        .padding(.trailing, 40)
                } else {
                    TextField("Password", text: $password)
                        .padding(.trailing, 40)
                }

                Button {
                    isPasswordHidden.toggle()
                } label: {
                    Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                        .foregroundStyle(.gray)
                }
                .padding(.trailing, 8)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

            Button {

            } label: {
                Text("Forgot password?")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Button {

            } label: {
                Text("Sign In")
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .cornerRadius(8)
            }

            HStack {
                Text("Don't have an account?")
                Button {

                } label: {
                    Text("Sign Up")
                }
            }
            .padding(.top, 10)

        }
        .padding()
    }
}

#Preview {
    SignInView(viewModel: .init(router: SignInRouter.mock))
}
