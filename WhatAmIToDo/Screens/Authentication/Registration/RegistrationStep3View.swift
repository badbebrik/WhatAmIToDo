//
//  RegistrationStep3View.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct RegistrationStep3View: View {
    @Binding var name: String
    @Binding var email: String

    @Binding var code1: String
    @Binding var code2: String
    @Binding var code3: String
    @Binding var code4: String

    @State private var animate = false
    @FocusState private var focusedField: Field?

    let onNext: () -> Void
    let onBack: () -> Void
    let onResend: () -> Void

    private enum Field {
        case one, two, three, four
    }

    private var isCodeComplete: Bool {
        [code1, code2, code3, code4].allSatisfy { $0.count == 1 }
    }

    var body: some View {
        VStack(spacing: 30) {

            Text("Регистрация")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animate)

            Text("Код подтверждения отправлен на \(email). Проверь почтовый ящик и введи код ниже.")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animate)

            HStack(spacing: 16) {
                codeField($code1, field: .one)
                codeField($code2, field: .two)
                codeField($code3, field: .three)
                codeField($code4, field: .four)
            }
            .frame(maxWidth: .infinity)
            .opacity(animate ? 1 : 0)
            .offset(y: animate ? 0 : -20)
            .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animate)

            VStack(spacing: 16) {
                Button {
                    onResend()
                } label: {
                    Text("Прислать код ещё раз")
                        .font(.body)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.4), value: animate)

                Button {
                    onNext()
                } label: {
                    Text("Подтвердить")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isCodeComplete ? Color.accentColor : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!isCodeComplete)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5), value: animate)
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
        }
        .onAppear {
            animate = true
            focusedField = .one
        }
    }

    @ViewBuilder
    private func codeField(_ text: Binding<String>, field: Field) -> some View {
        TextField("", text: text)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title)
            .frame(width: 60, height: 60)
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor.opacity(text.wrappedValue.isEmpty ? 0.5 : 1),
                                    lineWidth: 2))
            .focused($focusedField, equals: field)
            .onChange(of: text.wrappedValue) { new in
                if new.count > 1 {
                    text.wrappedValue = String(new.last!)
                }
                if new.count == 1 {
                    switch field {
                    case .one:   focusedField = .two
                    case .two:   focusedField = .three
                    case .three: focusedField = .four
                    case .four:  focusedField = nil
                    }
                } else if new.isEmpty {
                    switch field {
                    case .four:  focusedField = .three
                    case .three: focusedField = .two
                    case .two:   focusedField = .one
                    case .one:   break
                    }
                }
            }
    }
}
