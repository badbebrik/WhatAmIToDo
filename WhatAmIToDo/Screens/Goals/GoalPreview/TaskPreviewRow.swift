//
//  TaskPreviewRow.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

struct TaskPreviewRow: View {
    let task: GeneratedTaskDraft

    var body: some View {
        HStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 8, height: 8)

            Text(task.title)
                .font(.subheadline)

            Spacer()

            Text("\(task.estimatedTime) ч")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
