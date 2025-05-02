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
            Text("Registration")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Welcome to WhatAmIToDo App! What’s your name?")
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Name", text: $name)
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
