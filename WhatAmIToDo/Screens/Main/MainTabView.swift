import SwiftUI

struct MainTabView: View {
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
            
            Color.green
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