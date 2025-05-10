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

        }
    }

    private struct DayTimeline: View {
        var body: some View {
            EmptyView()
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
