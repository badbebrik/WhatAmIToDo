import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel: GoalsViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    backgroundGradient

                    if viewModel.isLoading && viewModel.goals.isEmpty {
                        ProgressView()
                            .scaleEffect(1.5)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.goals) { goal in
                                    GoalCardView(goal: goal)
                                        .onTapGesture {
                                            viewModel.onGoalTap(goal)
                                        }
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding()
                        }
                        .refreshable {
                            await viewModel.refresh()
                        }
                    }
                }

                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        Button(action: {
                            viewModel.onCreateGoalTap()
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background(
                                    Circle()
                                        .fill(Color.blue)
                                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("Мои цели")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Task {
                            await viewModel.refresh()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .task {
            await viewModel.loadGoals()
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

struct GoalCardView: View {
    let goal: GoalListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: goal.status.icon)
                    .foregroundColor(goal.color)
                    .font(.title3)
            }

            if let description = goal.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            ProgressView(value: Double(goal.progress), total: 100)
                .tint(goal.color)

            HStack {
                Label("\(goal.hoursPerWeek) ч/нед", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                if let nextTask = goal.nextTask {
                    Label(nextTask.title, systemImage: "arrow.right.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
