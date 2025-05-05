//
//   GoalHeaderPreview.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 03.05.2025.
//

import SwiftUI

struct GoalHeaderPreview: View {
    let preview: GeneratedGoalPreview

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(preview.title)
                .font(.title)
                .fontWeight(.bold)

            if let description = preview.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 12) {
                ProgressView(value: 0)
                    .tint(.blue)

                HStack {
                    Label("\(preview.hoursPerWeek) ч/нед", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Label("\(preview.estimatedTime) ч всего", systemImage: "hourglass")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}
