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

    @Namespace private var animationNS

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                greetingBlock

                MotivationSection(text: viewModel.motivation)

                UpcomingSection(tasks: viewModel.upcoming)

                TodaySection(today: viewModel.today,
                             onTap: { task in viewModel.selected = task })

                EnhancedStatsSection(stats: viewModel.stats)

            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .background(backgroundColor)
        .navigationTitle("Дашборд")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { Task { await viewModel.refreshAll() } }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .task { await viewModel.refreshAll() }
        .sheet(item: $viewModel.selected) { task in
            TaskOverlay(task: task) { newDone in
                Task {
                    await viewModel.toggle(task, to: newDone)
                    await viewModel.refreshAll()
                }
            }
        }
    }

    private var backgroundColor: Color {
        scheme == .dark ? Color.black : Color.white
    }

    private var greetingBlock: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Привет, \(viewModel.username)!")
                        .font(.title2).bold()
                    Text(Date(), format: .dateTime.weekday(.wide))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ProgressRing(percent: viewModel.stats?.tasksCompletedRatio ?? 0)
                    .frame(width: 60, height: 60)
            }
            .padding()
        }
        .frame(height: 100)
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


    private struct MotivationSection: View {
        let text: String?
        @State private var show = false

        var body: some View {
            if let motivation = text {
                HStack(alignment: .center, spacing: 12) {
                    AnimatedIcon()
                    Text(motivation)
                        .font(.callout).bold()
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Button(action: { }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.orange.opacity(0.1))
                )
                .shadow(color: .orange.opacity(0.2), radius: 8, x: 0, y: 4)
                .scaleEffect(show ? 1 : 0.9)
                .opacity(show ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: show)
                .onAppear { show = true }
            }
        }
    }

    private struct AnimatedIcon: View {
        @State private var animate = false
        var body: some View {
            Image(systemName: "sun.max.fill")
                .font(.largeTitle)
                .foregroundStyle(
                    AngularGradient(
                        gradient: Gradient(colors: [.yellow, .orange, .red, .yellow]),
                        center: .center
                    )
                )
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: animate)
                .onAppear { animate = true }
        }
    }

    private struct UpcomingSection: View {
        let tasks: [ScheduledTaskItem]
        var body: some View {
            if !tasks.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ближайшие задачи").font(.headline)
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
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        }
    }

    private struct EnhancedStatsSection: View {
        let stats: StatsResponse?
        var planned: Int { stats?.tasksPlanned ?? 0 }
        var completed: Int { stats?.tasksCompleted ?? 0 }
        var ratio: Double { stats?.tasksCompletedRatio ?? 0 }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Статистика").font(.headline)

                Chart {
                    BarMark(
                        x: .value("Категория", "Выполнено"),
                        y: .value("Количество", completed)
                    )
                    .annotation(position: .top) {
                        Text("\(completed)")
                            .font(.caption.bold())
                    }
                    BarMark(
                        x: .value("Категория", "Запланировано"),
                        y: .value("Количество", planned)
                    )
                    .annotation(position: .top) {
                        Text("\(planned)")
                            .font(.caption.bold())
                    }
                }
                .frame(height: 160)
                .chartYScale(domain: 0...Double(max(planned, completed) + 2))
                .chartYAxis(.hidden)
                .chartXAxisLabel("Задачи")

                HStack {
                    Text("Завершено: \(Int(ratio * 100))%")
                        .font(.subheadline.bold())
                    Spacer()
                    ProgressCircle(percent: ratio)
                        .frame(width: 40, height: 40)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            .shadow(radius: 6, y: 3)
        }
    }

    private struct ProgressCircle: View {
        let percent: Double
        var body: some View {
            ZStack {
                Circle().stroke(lineWidth: 5).opacity(0.2)
                Circle()
                    .trim(from: 0, to: percent)
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.blue)
                Text("\(Int(percent * 100))%")
                    .font(.caption2.bold())
            }
        }
    }

    private struct TodaySection: View {
        let today: [ScheduledTaskItem]
        var onTap: (ScheduledTaskItem) -> Void
        @State private var showList = false

        var body: some View {
            VStack(alignment: .leading) {
                Text("Сегодня").font(.headline)
                if today.isEmpty {
                    Text("На сегодня нет задач")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 12)
                } else {
                    ForEach(today.prefix(3)) { task in
                        TodayCard(task: task)
                            .onTapGesture { onTap(task) }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .onAppear {
                withAnimation(.easeOut.delay(0.3)) { showList = true }
            }
        }
    }

    private struct TodayCard: View {
        let task: ScheduledTaskItem
        @State private var pressed = false

        var body: some View {
            HStack(spacing: 12) {
                Circle().fill(task.status.color)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.subheadline.weight(.semibold))
                        .strikethrough(task.isDone, color: .primary)
                    Text(task.start, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue.opacity(0.05))
            )
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
            .scaleEffect(pressed ? 0.97 : 1)
            .animation(.spring(), value: pressed)
        }
    }
}

