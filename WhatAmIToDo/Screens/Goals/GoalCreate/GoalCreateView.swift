//
//  GoalCreateView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import SwiftUI

struct GoalCreateView: View {
    @StateObject var viewModel: GoalCreateViewModel

    var body: some View {
        Form {
            Section("Название") {
                TextField("Напр.: «Выучить SwiftUI»", text: $viewModel.title)
            }

            Section("Описание") {
                TextEditor(text: $viewModel.description)
                    .frame(height: 120)
            }

            Section("Часы в неделю") {
                Stepper(value: $viewModel.hoursPerWeek, in: 1...168) {
                    Text("\(viewModel.hoursPerWeek) ч/нед")
                }
            }

            Section {
                Button("Далее") {
                    Task { await viewModel.generatePreview() }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .disabled(!viewModel.canProceed)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView().scaleEffect(1.5)
                }
            }
        }
        .navigationTitle("Новая цель")
        .navigationBarTitleDisplayMode(.inline)
    }
}
