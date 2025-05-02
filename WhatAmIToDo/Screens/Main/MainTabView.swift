import SwiftUI

struct MainTabView: View {

    private let rootCoordinator: NavigationCoordinator

    init(rootCoordinator: NavigationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
            
            Color.blue
                .tabItem {
                    Label("Календарь", systemImage: "calendar")
                }
            
            GoalsView(viewModel: GoalsViewModel(router: GoalsRouter(rootCoordinator: rootCoordinator)))
                .tabItem {
                    Label("Задачи", systemImage: "checklist")
                }
            
            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
} 
