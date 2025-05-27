//
//  GoalCreateView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 02.05.2025.
//

import SwiftUI

struct GoalCreateView: View {
    @StateObject var viewModel: GoalCreateViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var animateButton = false
    @State private var showPreview = false
    @FocusState private var fieldFocus: Field?

    enum Field { case title, description }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue.opacity(0.15), Color.teal.opacity(0.05)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        card {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Название")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                                TextField("Напр.: «Выучить SwiftUI»", text: $viewModel.title)
                                    .textFieldStyle(.plain)
                                    .font(.title3.weight(.semibold))
                                    .focused($fieldFocus, equals: .title)
                            }
                        }

                        card {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Описание")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                                TextEditor(text: $viewModel.description)
                                    .frame(height: 120)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.secondarySystemBackground))
                                    )
                                    .focused($fieldFocus, equals: .description)
                            }
                        }

                        card {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Часы в неделю")
                                    .font(.caption.weight(.semibold))
                                    .foregroundColor(.secondary)
                                Stepper(value: $viewModel.hoursPerWeek, in: 1...168) {
                                    Text("\(viewModel.hoursPerWeek) ч/нед")
                                }
                                .tint(.accentColor)
                            }
                        }

                        if let err = viewModel.errorMessage {
                            Text(err)
                                .font(.footnote.weight(.medium))
                                .foregroundColor(.red)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }
                        Button {
                            Task { await viewModel.generatePreview() }
                        } label: {
                            Text("Далее")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    Capsule()
                                        .fill(viewModel.canProceed ? Color.accentColor : Color.gray.opacity(0.4))
                                )
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.2), radius: 4, y: 3)
                        }
                        .disabled(!viewModel.canProceed || viewModel.isLoading)
                        .scaleEffect(animateButton ? 1.05 : 1)
                        .onAppear {
                            animateButton = true
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                .scrollDismissesKeyboard(.interactively)

                if viewModel.isLoading {
                    Color.black.opacity(0.25).ignoresSafeArea()
                    ProgressView().scaleEffect(1.6)
                }
            }
            .navigationTitle("Новая цель")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отменить") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $showPreview) {
                if let prew = viewModel.generatedPreview {
                    GoalPreviewView(
                        viewModel: GoalPreviewViewModel(preview: prew),
                        onDismiss: { dismiss() }
                    )
                } else {
                    Text("Ошибка загрузки предпросмотра")
                }
            }
            .onChange(of: viewModel.generatedPreview) { if $0 != nil { showPreview = true } }
        }
    }

    @ViewBuilder
    private func card<Content: View>(@ViewBuilder _ inner: () -> Content) -> some View {
        inner()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 6, y: 4)
            )
    }
}
