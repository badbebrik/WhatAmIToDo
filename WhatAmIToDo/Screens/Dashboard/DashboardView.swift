//
//  DashboardView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import SwiftUI

struct DashboardView: View {

    @StateObject var viewModel: DashboardViewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        EmptyView()
    }

    private var greetingHeader: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Привет, \(viewModel.username)!")
                    .font(.title3.weight(.semibold))
                Text(Date(), format: .dateTime.weekday(.wide))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    private struct ProgressRing: View {
        let percent: Double
        var body: some View {
            ZStack {
                Circle().stroke(lineWidth: 6)
                    .opacity(0.15)
                Circle().trim(from: 0, to: percent)
                    .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.accentColor)
                Text("\(Int(percent * 100))%")
                    .font(.caption2.bold())
            }
        }
    }

    private struct MotivationCard: View {
        let text: String
        let onClose: () -> Void
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "sun.max.fill")
                    .font(.title2)
                Text(text)
                    .font(.callout)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .shadow(radius: 4, y: 2)
        }
    }

    private struct UpcomingCarousel: View {
        
    }

    private struct UpcomingCard: View {
        let task: ScheduledTaskItem
        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                Text(task.start, format: .dateTime.hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(width: 180, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(task.status.color.opacity(0.15))
            )
        }
    }

    private struct TodaySection: View {

    }

    private struct StatsSection: View {

    }
}
