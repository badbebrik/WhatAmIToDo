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
            EmptyView()
        }
    }
}
