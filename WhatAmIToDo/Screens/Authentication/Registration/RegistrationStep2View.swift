//
//  RegistrationStep2View.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct RegistrationStep2View: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @State var isPasswordHidden: Bool = true
    @State var isConfirmPasswordHidden = true
    
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 25) {
                Text("Регистрация")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Приятно познакомиться \(name)! Заверши оставшиеся шаги регистрации.")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(alignment: .leading, spacing: 20) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

                ZStack {
                    if isPasswordHidden {
                        SecureField("Пароль", text: $password)
                            .padding(.trailing, 40)
                    } else {
                        TextField("Пароль", text: $password)
                            .padding(.trailing, 40)
                    }

                    Button {
                        isPasswordHidden.toggle()
                    } label: {
                        Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .padding(.trailing, 8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

                ZStack {
                    if isConfirmPasswordHidden {
                        SecureField("Повтор пароля", text: $confirmPassword)
                            .padding(.trailing, 40)
                    } else {
                        TextField("Повтор пароля", text: $confirmPassword)
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

            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }

            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    Button {
                        onNext()
                    } label: {
                        Image(systemName: "arrowshape.right.circle")
                            .foregroundStyle(.black)
                    }
                }
            }

        }
    }
}
