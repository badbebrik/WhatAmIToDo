//
//  RegistrationStep1View.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct RegistrationStep1View: View {
    @Binding var name: String
    let onNext: () -> Void
    let onBack: () -> Void
    @State private var animate = false
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Регистрация")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1), value: animate)

            Text("Добро пожаловать в WhatAmIToDo! Как тебя зовут?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: animate)

            TextField("Имя", text: $name)
                .focused($isFocused)
                .autocorrectionDisabled()
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    name.isEmpty ? Color.accentColor.opacity(0.5) : Color.accentColor,
                                    lineWidth: 2
                                )
                )
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.3), value: animate)
                .onTapGesture { isFocused = true }
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
                .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.4), value: animate)
            }

            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Spacer()
                    Button {
                        onNext()
                    } label: {
                        Image(systemName: "arrowshape.right.circle.fill")
                            .font(.title)
                            .foregroundColor(name.isEmpty ? Color.gray : .accentColor)
                    }
                    .disabled(name.isEmpty)
                    .opacity(animate ? 1 : 0)
                    .offset(x: animate ? 0 : 20)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.5), value: animate)
                }
            }
        }
        .onAppear {
            animate = true
        }
    }
}
