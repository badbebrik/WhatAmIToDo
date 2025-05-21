//
//  GoalPreviewView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

struct GoalPreviewView: View {
    @StateObject private var viewModel: GoalPreviewViewModel
    @Environment(\.presentationMode) private var presentationMode
    let onDismiss: () -> Void

    init(viewModel: GoalPreviewViewModel, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack {
            if viewModel.isSaving {
                Spacer()
                ProgressView().scaleEffect(1.5)
                Spacer()
            } else {
                ScrollView {
                    GoalHeaderPreview(preview: viewModel.preview)

                    PhasePreviewRow(phase: viewModel.preview.phases[0])

                }
                .padding()

                HStack {
                    Button("Отменить") {
                        presentationMode.wrappedValue.dismiss()
                        onDismiss()
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Сохранить цель") {
                        Task {
                            await viewModel.saveGoal()
                            presentationMode.wrappedValue.dismiss()
                            onDismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .navigationTitle("Предпросмотр")
        .navigationBarTitleDisplayMode(.inline)
    }
}
