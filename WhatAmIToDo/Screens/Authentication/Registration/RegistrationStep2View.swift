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

    @State private var isPasswordHidden: Bool = true
    @State private var isConfirmPasswordHidden: Bool = true
    @State private var animate = false
    @FocusState private var focusedField: Field?

    let onNext: () -> Void
    let onBack: () -> Void

    private enum Field {
        case email, password, confirm
    }


    private var isEmailValid: Bool {
        let pattern = #"^\S+@\S+\.\S+$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    private var isPasswordStrong: Bool {
        password.count >= 8 &&
        password.range(of: #"[A-Za-z]"#, options: .regularExpression) != nil &&
        password.range(of: #"\d"#, options: .regularExpression) != nil
    }

    private var doPasswordsMatch: Bool {
        !confirmPassword.isEmpty && password == confirmPassword
    }

    private var canContinue: Bool {
        isEmailValid && isPasswordStrong && doPasswordsMatch
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            VStack(spacing: 12) {
                Text("Регистрация")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : -20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animate)

                Text("Приятно познакомиться \(name)! Заверши оставшиеся шаги регистрации.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : -20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animate)
            }

            VStack(alignment: .leading, spacing: 16) {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                Color.accentColor.opacity(email.isEmpty ? 0.5 : 1),
                                lineWidth: 2
                            )
                    )
                    .focused($focusedField, equals: .email)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : -20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animate)

                if !email.isEmpty && !isEmailValid {
                    Text("Введите корректный email")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut, value: isEmailValid)
                }

                ZStack {
                    Group {
                        if isPasswordHidden {
                            SecureField("Пароль", text: $password)
                        } else {
                            TextField("Пароль", text: $password)
                        }
                    }
                    .padding()
                    .padding(.trailing, 40)
                    .focused($focusedField, equals: .password)

                    Button {
                        isPasswordHidden.toggle()
                    } label: {
                        Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                    }
                    .padding(.trailing, 12)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.accentColor.opacity(password.isEmpty ? 0.5 : 1),
                            lineWidth: 2
                        )
                )
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.4), value: animate)

                if !password.isEmpty && !isPasswordStrong {
                    Text("Пароль должен быть не менее 8 символов и содержать буквы и цифры")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut, value: isPasswordStrong)
                }

                ZStack {
                    Group {
                        if isConfirmPasswordHidden {
                            SecureField("Повтор пароля", text: $confirmPassword)
                        } else {
                            TextField("Повтор пароля", text: $confirmPassword)
                        }
                    }
                    .padding()
                    .padding(.trailing, 40)
                    .focused($focusedField, equals: .confirm)

                    Button {
                        isConfirmPasswordHidden.toggle()
                    } label: {
                        Image(systemName: isConfirmPasswordHidden ? "eye.slash" : "eye")
                    }
                    .padding(.trailing, 12)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            Color.accentColor.opacity(confirmPassword.isEmpty ? 0.5 : 1),
                            lineWidth: 2
                        )
                )
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5), value: animate)

                if !confirmPassword.isEmpty && !doPasswordsMatch {
                    Text("Пароли не совпадают")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                        .animation(.easeInOut, value: doPasswordsMatch)
                }
            }

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }
                .opacity(animate ? 1 : 0)
                .offset(x: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.6), value: animate)
            }

            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    Button {
                        onNext()
                    } label: {
                        Image(systemName: "arrowshape.right.circle.fill")
                            .font(.title)
                            .foregroundColor(canContinue ? .accentColor : .gray)
                    }
                    .disabled(!canContinue)
                    .opacity(animate ? 1 : 0)
                    .offset(x: animate ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.7), value: animate)
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}
