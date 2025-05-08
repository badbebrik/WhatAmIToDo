//
//  GoalCreateView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import SwiftUI

struct GoalCreateView: View {
    @StateObject var viewModel: GoalCreateViewModel
    @Environment(\.dismiss) private var dismissSheet
    @State private var showPreview = false

    var body: some View {
        NavigationStack {
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

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }

                Section {
                    Button("Далее") {
                        Task {
                            await viewModel.generatePreview()
                        }
                    }
                    .disabled(!viewModel.canProceed || viewModel.isLoading)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.2).ignoresSafeArea()
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
            }
            .navigationTitle("Новая цель")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") {
                        dismissSheet()
                    }
                }
            }
            .onChange(of: viewModel.generatedPreview) { newValue in
                if newValue != nil {
                    showPreview = true
                }
            }
            .navigationDestination(isPresented: $showPreview) {
                if let preview = viewModel.generatedPreview {
                    GoalPreviewView(
                        viewModel: GoalPreviewViewModel(preview: preview)
                    )
                } else {

                    Text("Ошибка загрузки предпросмотра")
                }
            }
        }
    }
}
