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

    init(viewModel: AvailabilityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.days) { item in
                        DayChip(
                            item: item,
                            isSelected: item.day == viewModel.selectedDay
                        )
                        .onTapGesture { viewModel.selectedDay = item.day }
                    }
                }
                .padding(.horizontal)
            }

            Divider()

            if let dayItem = viewModel.item(for: viewModel.selectedDay) {
                VStack(alignment: .leading, spacing: 16) {

                    HStack {
                        Text(dayItem.day.fullName)
                            .font(.headline)
                        Spacer()
                        Button {
                            viewModel.addSlot()
                        } label: {
                            Image(systemName: "plus")
                                .padding(8)
                                .background(Circle().fill(Color.accentColor))
                                .foregroundColor(.white)
                        }
                    }

                    ForEach(dayItem.slots) { slot in
                        TimeSlotRow(
                            slot: viewModel.binding(for: slot),
                            onDelete: { viewModel.delete(slot) }
                        )
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .navigationTitle("Доступность")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Сохранить") { Task { await viewModel.save(dismiss) } }
            }
        }
    }
}

// MARK: - Визуальный «чип» дня недели
private struct DayChip: View {
    let item: DayAvailabilityItem
    let isSelected: Bool

    var body: some View {
        Text(item.day.shortName)
            .font(.headline)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        isSelected
                        ? Color.accentColor
                        : item.slots.isEmpty
                          ? Color.secondary.opacity(0.15)
                          : Color.accentColor.opacity(0.15)
                    )
            )
            .foregroundColor(isSelected ? .white : .primary)
    }
}

private struct TimeSlotRow: View {
    @Binding var slot: TimeSlotItem
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            DatePicker(
                "",
                selection: $slot.start,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.compact)

            Text("–")

            DatePicker(
                "",
                selection: $slot.end,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.compact)

            Spacer()

            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash")
            }
        }
    }
}
