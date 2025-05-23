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
    let onToggle: (_ newDone: Bool) -> Void

    var body: some View {
        VStack(spacing: 24) {
            Capsule().fill(.secondary).frame(width: 44, height: 4)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 12) {
                Text(task.title)
                    .font(.title3.bold())
                    .multilineTextAlignment(.leading)

                HStack {
                    Label("\(task.start.hm) – \(task.end.hm)", systemImage: "clock")
                    Spacer()
                    Text("\(Int(task.end.timeIntervalSince(task.start)/3600)) ч")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                ProgressView(value: task.isDone ? 1 : 0)
                    .tint(.green)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                onToggle(!task.isDone)
                dismiss()
            } label: {
                Label(task.isDone ? "Вернуть в план" : "Завершить задачу",
                      systemImage: task.isDone ? "arrow.uturn.backward" : "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(task.isDone ? .orange : .green)

            Spacer(minLength: 0)
        }
        .padding()
        .presentationDetents([.medium])
    }
}
