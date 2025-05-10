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

    }

    private struct MotivationCard: View {

    }

    private struct UpcomingCarousel: View {

    }

    private struct TodaySection: View {

    }

    private struct StatsSection: View {

    }
}
