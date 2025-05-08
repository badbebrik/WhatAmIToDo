//
//  AvailabilityView.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 08.05.2025.
//

import SwiftUI

struct AvailabilityView: View {

    @StateObject private var viewModel: AvailabilityViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var editingDay: DayOfWeek? = nil


    var body: some View {
        Rectangle()
    }
}
