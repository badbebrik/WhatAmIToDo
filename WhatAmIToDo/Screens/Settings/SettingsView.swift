import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var session: SessionManager
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Внешний вид") {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Button {
                            themeManager.setTheme(theme)
                        } label: {
                            HStack {
                                Image(systemName: theme.icon)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 30)
                                
                                Text(theme.title)
                                
                                Spacer()
                                
                                if theme == themeManager.currentTheme {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                        .foregroundColor(.primary)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Выйти")
                        }
                    }
                }
            }
            .navigationTitle("Настройки")
            .alert("Выйти из аккаунта?", isPresented: $showingLogoutAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Выйти", role: .destructive) {
                    Task {
                        await session.logout()
                    }
                }
            } message: {
                Text("Вы уверены, что хотите выйти из аккаунта?")
            }
        }
    }
} 