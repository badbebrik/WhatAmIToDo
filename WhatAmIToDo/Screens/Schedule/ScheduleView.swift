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
        var body: some View {
            EmptyView()
        }
    }
}
