//
//  GoalPreviewView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

struct GoalPreviewView: View {
    @StateObject private var viewModel: GoalPreviewViewModel

    init(viewModel: GoalPreviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
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

                    ForEach(viewModel.preview.phases) { phase in
                        PhasePreviewRow(phase: phase)
                    }
                }
                .padding()

                HStack {
                    Button("Отменить") {
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Сохранить цель") {
                        Task { await viewModel.saveGoal() }
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
