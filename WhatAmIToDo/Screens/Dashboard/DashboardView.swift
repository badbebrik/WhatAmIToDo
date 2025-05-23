//
//  DashboardView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import SwiftUI
import Charts

struct DashboardView: View {

    @StateObject var viewModel: DashboardViewModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                greetingHeader

                if let motivation = viewModel.motivation {
                    MotivationCard(text: motivation) {
                        withAnimation {
                            viewModel.motivation = nil
                        }
                    }
                }

                if !viewModel.upcoming.isEmpty {
                    UpcomingCarousel(tasks: viewModel.upcoming)
                }

                TodaySection(today: viewModel.today,
                             onTap: { task in viewModel.selected = task })


                StatsSection(stats: viewModel.stats ?? StatsResponse(tasksPlanned: 2, tasksCompleted: 5))

            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .background(
            LinearGradient(colors: scheme == .dark
                           ? [.black, .gray.opacity(0.3)]
                           : [.white, .blue.opacity(0.08)]
                           , startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        )
        .navigationTitle("Дашборд")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.refreshAll()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .task {
            await viewModel.refreshAll()
        }
        .sheet(item: $viewModel.selected) { task in
            TaskOverlay(task: task) { newDone in
                Task { await viewModel.toggle(task, to: newDone) }
            }
        }
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
            ProgressRing(percent: Double(viewModel.stats?.tasksCompletedRatio ?? 0))
                .frame(width: 60, height: 60)
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
        let tasks: [ScheduledTaskItem]
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ближайшие задачи")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tasks) { task in
                            UpcomingCard(task: task)
                        }
                    }
                }
            }
        }
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
        let today: [ScheduledTaskItem]
        var onTap: (ScheduledTaskItem) -> Void
        var body: some View {
            VStack(alignment: .leading) {
                Text("Сегодня").font(.headline)
                if today.isEmpty {
                    Text("На сегодня нет задач")
                        .font(.subheadline).foregroundColor(.secondary)
                        .padding(.vertical, 12)
                } else {
                    ForEach(today.prefix(3)) { task in
                        HStack(spacing: 12) {
                            Circle().fill(task.status.color)
                                .frame(width: 8, height: 8)
                            Text(task.title)
                                .strikethrough(task.isDone)
                                .foregroundColor(task.isDone ? .secondary : .primary)
                                .font(.subheadline)
                            Spacer()
                            Text(task.start, format: .dateTime.hour().minute())
                                .font(.caption).foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture { onTap(task) }
                    }
                }
            }
        }
    }


    private struct StatsSection: View {
        let stats: StatsResponse

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Статистика")
                    .font(.headline)

                Chart {
                    BarMark(x: .value("Completed", "Выполнено"),
                            y: .value("Qty", 3))
                    .foregroundStyle(.green)

                    BarMark(x: .value("Planned", "Запланировано"),
                            y: .value("Qty", 5))
                    .foregroundStyle(.secondary)

                }
                .frame(height: 140)
                .chartLegend(.hidden)
            }
        }
    }
}
