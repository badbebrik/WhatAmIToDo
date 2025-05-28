//
//  TaskOverlay.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 23.05.2025.
//

import SwiftUI

struct TaskOverlay: View {
    @Environment(\.dismiss) private var dismiss
    let task: ScheduledTaskItem
    let onToggle: (Bool) -> Void

    @State private var progress: Double = 0
    @State private var isCompleting = false
    @State private var showConfetti = false
    @State private var buttonPressed = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.secondary.opacity(0.6))
                    .frame(width: 36, height: 4)
                    .padding(.top, 8)

                Text(task.title)
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

                HStack {
                    Label {
                        Text("\(task.start.hm) – \(task.end.hm)")
                    } icon: {
                        Image(systemName: "clock")
                    }
                    Spacer()
                    Text(String(format: "%.1f ч", task.durationHours))
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 8)
                        Capsule()
                            .fill(Color.green)
                            .frame(width: geo.size.width * progress,
                                   height: 8)
                            .animation(.easeOut(duration: 0.8), value: progress)
                    }
                }
                .frame(height: 8)
                .padding(.horizontal)

                VStack(spacing: 12) {
                    if !task.isDone {
                        Button {
                            guard !isCompleting else { return }
                            isCompleting = true
                            withAnimation {
                                progress = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                showConfetti = true
                                onToggle(true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Выполнить")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.green)
                                )
                                .foregroundColor(.white)
                                .scaleEffect(buttonPressed ? 0.95 : 1)
                        }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in buttonPressed = true }
                                .onEnded { _ in buttonPressed = false }
                        )
                        .padding(.horizontal)
                    }

                    if task.isDone {
                        Button {
                            onToggle(false)
                            dismiss()
                        } label: {
                            Text("Вернуть в план")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: 360)
            .padding(.bottom, 20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground).opacity(0.96))
            )
            .overlay(
                ConfettiView(isActive: $showConfetti)
            )
            .presentationDetents([.fraction(0.35)])
        }
        .onAppear {
            progress = task.isDone ? 1 : 0
        }
    }
}

private struct ConfettiView: View {
    @Binding var isActive: Bool
    @State private var pieces: [Piece] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    Circle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size)
                        .position(piece.position)
                        .opacity(piece.opacity)
                }
            }
            .onChange(of: isActive) { active in
                if active { emit(in: geo.size) }
            }
            .onReceive(Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()) { _ in
                guard isActive else { return }
                for index in pieces.indices {
                    pieces[index].position.x += pieces[index].dx
                    pieces[index].position.y += pieces[index].dy
                    pieces[index].opacity -= 0.02
                }
                pieces.removeAll { $0.opacity <= 0 }
            }
        }
        .allowsHitTesting(false)
    }

    private func emit(in size: CGSize) {
        pieces = (0..<80).map { _ in
            let angle = Double.random(in: 0...360) * .pi/180
            let speed: CGFloat = CGFloat.random(in: 2...6)
            return Piece(
                id: .init(),
                position: CGPoint(x: size.width/2, y: size.height*0.2),
                dx: cos(angle)*speed,
                dy: sin(angle)*speed + 2,
                size: CGFloat.random(in: 6...12),
                color: [.red, .yellow, .green, .blue, .pink].randomElement()!,
                opacity: 1
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isActive = false
        }
    }

    private struct Piece: Identifiable {
        let id: UUID
        var position: CGPoint
        var dx: CGFloat
        var dy: CGFloat
        var size: CGFloat
        var color: Color
        var opacity: Double
    }
}

private extension ScheduledTaskItem {
    var durationHours: Double {
        end.timeIntervalSince(start) / 3600
    }
    var startFormatted: String { start.hm }
    var endFormatted: String { end.hm }
}

