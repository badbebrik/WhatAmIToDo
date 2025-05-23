//
//  ScheduleView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var viewModel: ScheduleViewModel
    @Environment(\.colorScheme) private var colorScheme

    @State private var selectedTask: ScheduledTaskItem?

    var body: some View {
        VStack(spacing: 0) {
            DateCarousel(selected: $viewModel.selectedDate) { date in
                Task {
                    await viewModel.load(for: date)
                }
            }
            .padding(.vertical, 8)
            .background(
                Color(.systemBackground)
                    .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
            )

            Divider()

            DayTimeline(tasks: viewModel.tasks,
                        onTap: { task in
                            selectedTask = task
                        },
                        onToggle: { task in
                            Task {
                                await viewModel.toggle(task, to: !task.isDone)
                            }
                        })
                .overlay(alignment: .topLeading) {
                    if viewModel.isLoading {
                        ProgressView()
                            .offset(y: 120)
                    }
                }
                .animation(.easeInOut, value: viewModel.tasks)
        }
        .navigationTitle("Расписание")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.initialLoad()
        }
        .sheet(item: $selectedTask) { task in
            TaskOverlay(task: task) { newDone in
                Task {
                    await viewModel.toggle(task, to: newDone)
                    selectedTask = nil
                }
            }
        }
    }

    private struct DayTimeline: View {
        let tasks: [ScheduledTaskItem]
        let onTap: (ScheduledTaskItem) -> Void
        let onToggle: (ScheduledTaskItem) -> Void

        private let hours = Array(0...23)

        var body: some View {
            if tasks.isEmpty {
                EmptyStateView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                        Section {
                            ZStack(alignment: .topLeading) {
                                VStack(spacing: 0) {
                                    ForEach(hours, id: \.self) { hour in
                                        HStack(spacing: 4) {
                                            Text("\(hour, format: .number) :00")
                                                .font(.caption2)
                                                .frame(width: 34, alignment: .trailing)
                                                .foregroundStyle(.secondary)
                                            Rectangle()
                                                .fill(Color.secondary.opacity(0.2))
                                                .frame(height: 0.5)
                                        }
                                        .frame(height: 80, alignment: .top)
                                    }
                                }

                                ForEach(tasks) { task in
                                    TaskBlock(task: task)
                                        .padding(.leading, 50)
                                        .padding(.trailing, 20)
                                        .onTapGesture {
                                            onTap(task)
                                        }
                                        .contextMenu {
                                            Button(task.isDone ? "Вернуть в план" : "Завершить задачу") {
                                                onToggle(task)
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private struct EmptyStateView: View {
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 46))
                    .foregroundColor(.accentColor)

                Text("Нет задач на этот день")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    private struct TaskBlock: View {
        let task: ScheduledTaskItem

        private let hourHeight: CGFloat = 80

        private var top: CGFloat {
            let calendar = Calendar.current
            let comps = calendar.dateComponents([.hour, .minute], from: task.start)
            let hour = CGFloat(comps.hour ?? 0)
            let minute = CGFloat(comps.minute ?? 0)
            return (hour + minute / 60) * hourHeight
        }

        private var height: CGFloat {
            CGFloat(task.end.timeIntervalSince(task.start) / 3600) * hourHeight
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text("\(task.start.hm) – \(task.end.hm)")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(8)
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .frame(height: height, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(task.status.color)
            )
            .offset(y: top)
            .shadow(radius: 2, y: 1)
        }
    }

    private struct DateCarousel: View {

        @Binding var selected: Date
        var onChange: (Date) -> Void

        private let range: [Date] = {
            let cal = Calendar.current
            let start = cal.startOfDay(for: .now)
            return (-7...7).compactMap { cal.date(byAdding: .day, value: $0, to: start)}
        }()

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(range, id: \.self) { date in
                        dayChip(for: date)
                            .onTapGesture {
                                selected = date
                                onChange(date)
                            }
                    }
                }
            }
        }

        private func dayChip(for date: Date) -> some View {
            let cal = Calendar.current
            let isToday = cal.isDateInToday(date)
            let isSel   = cal.isDate(date, inSameDayAs: selected)

            return VStack(spacing: 4) {
                Text(date, format: .dateTime.weekday(.narrow))
                    .font(.caption2).bold()
                Text(date, format: .dateTime.day())
                    .font(.headline)
            }
            .foregroundColor(isSel ? .white : .primary)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Capsule().fill(
                    isSel ? Color.accentColor
                    : isToday ? Color.accentColor.opacity(0.2)
                    : Color.secondary.opacity(0.15)
                )
            )
        }
    }
}

