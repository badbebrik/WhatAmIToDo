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
    let onNext: () -> Void
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 20) {

            Text("Registration")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Verification code has been sent to \(email). Check your email and confirm the registration with code typed.")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 20) {
                TextField("", text: $code1)
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

                TextField("", text: $code2)
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

                TextField("", text: $code3)
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))

                TextField("", text: $code4)
                    .frame(width: 50, height: 50)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Button {
                onNext()
            } label: {
                Text("Verify")
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
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}
