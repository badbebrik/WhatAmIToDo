//
//  PhasePreviewRow.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

struct PhasePreviewRow: View {
    let phase: GeneratedPhaseDraft

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(phase.title)
                    .font(.headline)

                Spacer()

                Text("#\(phase.order + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let description = phase.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            ForEach(phase.tasks) { task in
                TaskPreviewRow(task: task)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
