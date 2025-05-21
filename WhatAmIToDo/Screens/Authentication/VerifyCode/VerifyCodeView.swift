//
//  VerifyCodeView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 29.01.2025.
//

import SwiftUI

struct VerifyCodeView: View {
    @State private var code1: String = ""
    @State private var code2: String = ""
    @State private var code3: String = ""
    @State private var code4: String = ""

    @StateObject var viewModel: VerifyCodeViewModel

    var body: some View {
        VStack(spacing: 20) {

            Text("Введите код")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Введите код, присланный на указанную почту")
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

            VStack {
                Button {

                } label: {
                    Text("Прислать код еще раз")
                }
                Button {
                    viewModel.navigateToNewPassword()
                } label: {
                    Text("Подтвердить")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(8)
                }
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
    VerifyCodeView(viewModel: .init(router: VerifyCodeRouter.mock))
}
