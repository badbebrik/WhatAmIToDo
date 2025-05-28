import SwiftUI

struct MainTabView: View {

    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }

    var body: some View {
        TabView {
            NavigationStack {
                GoalsView(viewModel: GoalsViewModel())
                    .navigationTitle("Мои цели")
            }
            .tabItem { Label("Цели", systemImage: "checklist") }

            NavigationStack {
                ScheduleView(viewModel: ScheduleViewModel())
                    .navigationTitle("Расписание")
            }
            .tabItem { Label("Расписание", systemImage: "calendar") }

            NavigationStack {
                DashboardView(viewModel: DashboardViewModel())
                    .navigationTitle("Дашборд")
            }
            .tabItem { Label("Дашборд", systemImage: "house.fill") }

            NavigationStack {
                SettingsView()
                    .navigationTitle("Настройки")
            }
            .tabItem { Label("Настройки", systemImage: "gear") }
        }
    }
}
