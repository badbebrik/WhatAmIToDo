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

    var body: some View {
        VStack(spacing: 20) {
            Text("Регистрация")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Добро пожаловать в WhatAmIToDo! Как тебя зовут?")
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Имя", text: $name)
                .autocorrectionDisabled()
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
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
