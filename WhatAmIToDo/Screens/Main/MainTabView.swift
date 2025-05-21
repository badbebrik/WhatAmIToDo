import SwiftUI

struct MainTabView: View {

    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }

    var body: some View {
        TabView {
            GoalsView(viewModel: GoalsViewModel())
                .tabItem {
                    Label("Цели", systemImage: "checklist")
                }

            ScheduleView(viewModel: ScheduleViewModel())
                .tabItem {
                    Label("Расписание", systemImage: "calendar")
                }

            DashboardView(viewModel: DashboardViewModel())
                .tabItem {
                    Label("Дашборд", systemImage: "house.fill")
                }
            

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
} 
