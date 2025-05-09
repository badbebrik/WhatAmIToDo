import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel: GoalsViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var isShowingCreate = false
    @State private var selectedGoal: GoalListItem?

    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            content
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
        .onAppear {
            Task {
                await viewModel.loadGoals()
            }
        }
        .sheet(isPresented: $isShowingCreate) {
            NavigationView {
                GoalCreateView(viewModel: GoalCreateViewModel())
            }
        }
        .navigationDestination(item: $selectedGoal) { goal in
            GoalDetailView(viewModel: GoalDetailViewModel(goalId: goal.id))
        }
    }

    // MARK: - Под-view

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
                                .onTapGesture { selectedGoal = goal }
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
            isShowingCreate.toggle()
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

    private var statusBadge: some View {
        Text(goal.status.localizedTitle)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .background(
                Capsule().fill(goal.status.color)
            )
    }

    private var statusStripe: some View {
        Rectangle()
            .fill(goal.status.color)
            .frame(width: 6)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }

    var body: some View {
        HStack(spacing: 0) {
            statusStripe

            VStack(alignment: .leading, spacing: 12) {

                HStack {
                    Text(goal.title)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    Spacer(minLength: 8)
                    statusBadge
                }

                if let description = goal.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                ProgressView(value: Double(goal.progress), total: 100)
                    .tint(goal.status.color)

                HStack {
                    Label("\(goal.hoursPerWeek) ч/нед", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    if let next = goal.nextTask {
                        Label(next.title, systemImage: "arrow.right.circle")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(goal.status.tint)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                    )
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.07), radius: 6, y: 4)
        .opacity(goal.status == .completed ? 0.55 :
                 goal.status == .paused    ? 0.75 : 1)
    }
}
