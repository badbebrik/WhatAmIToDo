import SwiftUI

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
    
    var title: String {
        switch self {
        case .system: return "Системная"
        case .light: return "Светлая"
        case .dark: return "Темная"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "iphone"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    @Published var currentTheme: AppTheme = .system
    
    private init() {
        currentTheme = selectedTheme
    }
    
    func setTheme(_ theme: AppTheme) {
        selectedTheme = theme
        currentTheme = theme
    }
} 