import Foundation
import SwiftUI

@MainActor
class GoalsViewModel: ObservableObject {
    private let network: GoalNetworkManager = .shared
    @Published var goals: [GoalListItem] = []
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Навигация

    func onGoalTap(_ goal: GoalListItem) {
        print("GoalsViewModel: Нажатие на цель")
        print("GoalsViewModel: ID цели: \(goal.id)")
        print("GoalsViewModel: Название: \(goal.title)")
    }

    // MARK: - Data

    func loadGoals() async {
        print("GoalsViewModel: Начало загрузки целей")
        isLoading = true
        defer { 
            isLoading = false
            print("GoalsViewModel: Завершение загрузки целей")
        }
        
        do {
            print("GoalsViewModel: Отправка запроса на получение целей")
            let resp = try await network.listGoals(
                request: .init(limit: 20, offset: 0, status: nil)
            )
            print("GoalsViewModel: Получен ответ от сервера")
            print("GoalsViewModel: Количество целей: \(resp.goals.count)")
            
            let newGoals = resp.goals.map { goal in
                print("GoalsViewModel: Преобразование цели в UI модель:")
                print("GoalsViewModel: ID: \(goal.id)")
                print("GoalsViewModel: Название: \(goal.title)")
                print("GoalsViewModel: Статус: \(goal.status)")
                print("GoalsViewModel: Часов в неделю: \(goal.hoursPerWeek ?? 0)")
                return GoalListItem(from: goal)
            }
            goals = newGoals
            print(goals)

            print("GoalsViewModel: Все цели успешно преобразованы")
        } catch {
            print("GoalsViewModel: Ошибка при загрузке целей: \(error.localizedDescription)")
            self.error = error
        }
    }

    func refresh() async {
        print("GoalsViewModel: Обновление списка целей")
        await loadGoals()
    }

    @MainActor
    func deleteGoal(id: UUID) async {
        do {
            try await network.deleteGoal(id: id)
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
}
