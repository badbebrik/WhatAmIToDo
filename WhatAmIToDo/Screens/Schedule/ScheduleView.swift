//
//  ScheduleView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel: ScheduleViewModel

    @Environment(\.colorScheme) private var colorScheme


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

            DayTimeline(tasks: viewModel.tasks)
                .overlay(alignment: .topLeading) {
                    if viewModel.isLoading {
                        ProgressView()
                            .offset(y: 120)
                    }
                }
                .animation(.easeInOut, value: viewModel.tasks)

            if let mot = viewModel.motivation {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                    Text(mot)
                        .font(
                            .footnote
                        )
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.05) : Color.accentColor.opacity(0.08))
                        .padding(.horizontal)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .navigationTitle("Расписание")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.initialLoad()
        }
    }

    private struct DayTimeline: View {
        let tasks: [ScheduledTaskItem]

        private let hours = Array(0...23)

        var body: some View {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 40) {
                                ForEach(hours, id: \.self) { h in
                                    HStack(spacing: 4) {
                                        Text("\(h, format: .number) :00")
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
                        }
                    }
                }
            }
        }
    }

    private struct TaskBlock: View {
        let task: ScheduledTaskItem

        var body: some View {
            GeometryReader { geo in
                let top = pixelOffset(for: task.start)
                let height = CGFloat(task.end.timeIntervalSince(task.start) / 3600) * 80

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    Text("\(task.start.hm) - \(task.end.hm)")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(task.status.color)
                )
                .frame(height: height, alignment: .top)
                .position(x: geo.size.width / 2, y: top + height / 2)
                .shadow(radius: 2, y: 1)
            }
        }

        private func pixelOffset(for date: Date) -> CGFloat {
            let comp = Calendar.current.dateComponents([.hour, .minute], from: date)
            let h = CGFloat(comp.hour ?? 0)
            let m = CGFloat(comp.minute ?? 0)
            return h * 80 + m / 60 * 80
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
