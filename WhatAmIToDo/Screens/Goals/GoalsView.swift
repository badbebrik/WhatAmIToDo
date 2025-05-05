import SwiftUI


struct GoalsView: View {
    @StateObject private var viewModel: GoalsViewModel
    @State private var path = NavigationPath()
    @Environment(\.colorScheme) private var colorScheme

    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                content
                    .navigationDestination(for: AnyRoutable.self) { router in
                        router.makeView()
                    }

                addButton
            }
            .navigationTitle("Мои цели")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { await viewModel.refresh() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .task { await viewModel.loadGoals() }
            .onAppear {
                viewModel.setLocalCoordinator(
                    LocalNavigationCoordinator(path: $path)
                )
            }
        }
    }

    // MARK: - Под‑view

    private var content: some View {
        ZStack {
            backgroundGradient

            if viewModel.isLoading && viewModel.goals.isEmpty {
                ProgressView().scaleEffect(1.5)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.goals) { goal in
                            GoalCardView(goal: goal)
                                .onTapGesture { viewModel.onGoalTap(goal) }
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
                .refreshable { await viewModel.refresh() }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                colorScheme == .dark ? .black : .white,
                colorScheme == .dark ? .gray.opacity(0.3) : .blue.opacity(0.1)
            ],
            startPoint: .top, endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var addButton: some View {
        Button {
            viewModel.onCreateGoalTap()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(20)
                .background(
                    Circle()
                        .fill(Color.blue)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
        .padding(.trailing, 24)
        .padding(.bottom, 24)
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
