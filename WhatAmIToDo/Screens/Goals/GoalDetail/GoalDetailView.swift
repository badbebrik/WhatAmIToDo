import SwiftUI

struct GoalDetailView: View {
    @StateObject private var viewModel: GoalDetailViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    @State private var showAvailability = false
    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false

    init(viewModel: GoalDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            backgroundGradient

            if viewModel.isLoading && viewModel.goal == nil {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let goal = viewModel.goal {
                ScrollView {
                    VStack(spacing: 24) {
                        GoalHeaderView(goal: goal)

                        if goal.status == .planning {
                            Button {
                                showAvailability = true
                            } label: {
                                Label("Внедрить в расписание", systemImage: "calendar.badge.plus")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.accentColor)
                                    .foregroundStyle(.white)
                                    .clipShape(.capsule)
                                    .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
                            }
                            .padding(.horizontal)
                        }

                        if let phases = goal.phases {
                            PhasesListView(phases: phases)
                        }

                        Spacer().frame(height: 80)
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }

            if viewModel.goal != nil {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .background(
                            Circle()
                                .fill(Color.red)
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        )
                        .padding()
                        .disabled(isDeleting)
                    }
                }
            }

            if isDeleting {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView("Удаляем…")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                    .shadow(radius: 10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadGoal()
        }
        .navigationDestination(isPresented: $showAvailability) {
            AvailabilityView(
                viewModel: AvailabilityViewModel(goalId: viewModel.goalId)
            )
        }
        .alert("Удалить цель?", isPresented: $showDeleteConfirmation) {
            Button("Отменить", role: .cancel) { }
            Button("Удалить", role: .destructive) {
                Task {
                    isDeleting = true
                    do {
                        try await viewModel.deleteGoal()
                        dismiss()
                    } catch {
                        isDeleting = false
                    }
                }
            }
        } message: {
            Text("Это действие невозможно отменить.")
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                colorScheme == .dark ? Color.black : Color.white,
                colorScheme == .dark ? Color.gray.opacity(0.3) : Color.blue.opacity(0.1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}


struct GoalHeaderView: View {
    let goal: GoalDetailItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(goal.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: goal.status.icon)
                    .foregroundColor(goal.status.color)
                    .font(.title2)
            }
            
            if let description = goal.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                ProgressView(value: Double(goal.progress), total: 100)
                    .tint(goal.status.color)
                
                HStack {
                    Label("\(goal.hoursPerWeek) ч/нед", systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let estimatedTime = goal.estimatedTime {
                        Label("\(estimatedTime) ч всего", systemImage: "hourglass")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

struct PhasesListView: View {
    let phases: [PhaseDetailItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Этапы")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(phases.sorted(by: { $0.order < $1.order })) { phase in
                PhaseCardView(phase: phase)
            }
        }
    }
}

struct PhaseCardView: View {
    let phase: PhaseDetailItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(phase.title)
                    .font(.headline)
                
                Spacer()
                
                Circle()
                    .fill(phase.status.color)
                    .frame(width: 12, height: 12)
            }
            
            if let description = phase.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let tasks = phase.tasks {
                ForEach(tasks) { task in
                    TaskRowView(task: task)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct TaskRowView: View {
    let task: TaskDetailItem
    
    var body: some View {
        HStack {
            Circle()
                .fill(task.status.color)
                .frame(width: 8, height: 8)
            
            Text(task.title)
                .font(.subheadline)
            
            Spacer()
            
            if let estimatedTime = task.estimatedTime {
                Text("\(estimatedTime) ч")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
