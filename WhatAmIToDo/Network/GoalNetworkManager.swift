import Foundation

enum GoalNetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
    case unauthorized
    case unknown
}

final class GoalNetworkManager {
    static let shared = GoalNetworkManager()
    private let baseURL = "http://localhost:8080"
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.timeoutIntervalForResource = 300
        session = URLSession(configuration: configuration)
    }
    
    private func createDateDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    // MARK: - Generate Goal
    func generateGoal(request: GenerateGoalRequest) async throws -> GenerateGoalResponse {
        let endpoint = "/api/goals/generate"
        let url = try createURL(for: endpoint)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoalNetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(GenerateGoalResponse.self, from: data)
        case 401:
            throw GoalNetworkError.unauthorized
        default:
            throw GoalNetworkError.unknown
        }
    }
    
    // MARK: - Create Goal
    func createGoal(request: CreateGoalRequest) async throws -> CreateGoalResponse {
        let endpoint = "/api/goals"
        let url = try createURL(for: endpoint)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoalNetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(CreateGoalResponse.self, from: data)
        case 401:
            throw GoalNetworkError.unauthorized
        default:
            throw GoalNetworkError.unknown
        }
    }
    
    // MARK: - List Goals
    func listGoals(request: ListGoalsRequest) async throws -> ListGoalsResponse {
        print("GoalNetworkManager: Запрос списка целей")
        print("GoalNetworkManager: Параметры запроса - limit: \(request.limit), offset: \(request.offset), status: \(request.status ?? "не указан")")
        
        var components = URLComponents(string: baseURL + "/api/goals")!
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(request.limit)),
            URLQueryItem(name: "offset", value: String(request.offset))
        ]
        
        if let status = request.status {
            components.queryItems?.append(URLQueryItem(name: "status", value: status))
        }
        
        guard let url = components.url else {
            print("GoalNetworkManager: Неверный URL")
            throw GoalNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("GoalNetworkManager: Токен авторизации получен")
        } else {
            print("GoalNetworkManager: Токен авторизации не найден")
            throw GoalNetworkError.unauthorized
        }
        
        print("GoalNetworkManager: Отправляем запрос на \(url.absoluteString)")
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("GoalNetworkManager: Неверный формат ответа")
            throw GoalNetworkError.invalidResponse
        }
        
        print("GoalNetworkManager: Получен ответ с кодом: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200:
            print("GoalNetworkManager: Успешный ответ")
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Тело ответа: \(responseString)")
            }
            
            let decoder = createDateDecoder()
            
            do {
                let result = try decoder.decode(ListGoalsResponse.self, from: data)
                print("GoalNetworkManager: Успешно декодировано:")
                print("GoalNetworkManager: Количество целей: \(result.goals.count)")
                print("GoalNetworkManager: Всего: \(result.meta.total)")
                print("GoalNetworkManager: Лимит: \(result.meta.limit)")
                print("GoalNetworkManager: Смещение: \(result.meta.offset)")
                
                if !result.goals.isEmpty {
                    print("GoalNetworkManager: Пример первой цели:")
                    let firstGoal = result.goals[0]
                    print("GoalNetworkManager: ID: \(firstGoal.id)")
                    print("GoalNetworkManager: Название: \(firstGoal.title)")
                    print("GoalNetworkManager: Статус: \(firstGoal.status)")
                    print("GoalNetworkManager: Прогресс: \(firstGoal.progress)")
                    print("GoalNetworkManager: Часов в неделю: \(firstGoal.hoursPerWeek ?? 0)")
                    print("GoalNetworkManager: Обновлено: \(firstGoal.updatedAt?.description ?? "нет")")
                }
                
                return result
            } catch let decodingError as DecodingError {
                print("GoalNetworkManager: Ошибка декодирования:")
                switch decodingError {
                case .dataCorrupted(let context):
                    print("GoalNetworkManager: Data corrupted: \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("GoalNetworkManager: Key not found: \(key.stringValue) in \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("GoalNetworkManager: Type mismatch: expected \(type) in \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("GoalNetworkManager: Value not found: expected \(type) in \(context.debugDescription)")
                @unknown default:
                    print("GoalNetworkManager: Unknown decoding error: \(decodingError)")
                }
                throw GoalNetworkError.decodingError
            }
        case 401:
            print("GoalNetworkManager: Ошибка авторизации")
            throw GoalNetworkError.unauthorized
        case 500:
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Ошибка сервера: \(responseString)")
            }
            throw GoalNetworkError.networkError(NSError(domain: "GoalNetworkManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка сервера"]))
        default:
            print("GoalNetworkManager: Неизвестная ошибка: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Тело ответа: \(responseString)")
            }
            throw GoalNetworkError.unknown
        }
    }
    
    // MARK: - Get Goal
    func getGoal(id: UUID) async throws -> GoalResponse {
        print("GoalNetworkManager: Запрос деталей цели")
        print("GoalNetworkManager: ID цели: \(id)")
        
        let endpoint = "/api/goals/\(id)"
        let url = try createURL(for: endpoint)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("GoalNetworkManager: Токен авторизации получен")
        } else {
            print("GoalNetworkManager: Токен авторизации не найден")
            throw GoalNetworkError.unauthorized
        }
        
        print("GoalNetworkManager: Отправляем запрос на \(url.absoluteString)")
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("GoalNetworkManager: Неверный формат ответа")
            throw GoalNetworkError.invalidResponse
        }
        
        print("GoalNetworkManager: Получен ответ с кодом: \(httpResponse.statusCode)")
        
        switch httpResponse.statusCode {
        case 200:
            print("GoalNetworkManager: Успешный ответ")
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Тело ответа: \(responseString)")
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let result = try decoder.decode(GetGoalResponse.self, from: data)
                print("GoalNetworkManager: Успешно декодировано:")
                print("GoalNetworkManager: ID: \(result.goal.id)")
                print("GoalNetworkManager: Название: \(result.goal.title)")
                print("GoalNetworkManager: Статус: \(result.goal.status)")
                print("GoalNetworkManager: Прогресс: \(result.goal.progress)")
                print("GoalNetworkManager: Часов в неделю: \(result.goal.hoursPerWeek)")
                print("GoalNetworkManager: Обновлено: \(result.goal.updatedAt)")
                print("GoalNetworkManager: Количество фаз: \(result.goal.phases?.count ?? 0)")
                return result.goal
            } catch let decodingError as DecodingError {
                print("GoalNetworkManager: Ошибка декодирования:")
                switch decodingError {
                case .dataCorrupted(let context):
                    print("GoalNetworkManager: Data corrupted: \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("GoalNetworkManager: Key not found: \(key.stringValue) in \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("GoalNetworkManager: Type mismatch: expected \(type) in \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("GoalNetworkManager: Value not found: expected \(type) in \(context.debugDescription)")
                @unknown default:
                    print("GoalNetworkManager: Unknown decoding error: \(decodingError)")
                }
                throw GoalNetworkError.decodingError
            }
        case 401:
            print("GoalNetworkManager: Ошибка авторизации")
            throw GoalNetworkError.unauthorized
        case 404:
            print("GoalNetworkManager: Цель не найдена")
            throw GoalNetworkError.networkError(NSError(domain: "GoalNetworkManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Цель не найдена"]))
        case 500:
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Ошибка сервера: \(responseString)")
            }
            throw GoalNetworkError.networkError(NSError(domain: "GoalNetworkManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Ошибка сервера"]))
        default:
            print("GoalNetworkManager: Неизвестная ошибка: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("GoalNetworkManager: Тело ответа: \(responseString)")
            }
            throw GoalNetworkError.unknown
        }
    }
    
    // MARK: - Private Helpers
    private func createURL(for endpoint: String) throws -> URL {
        guard let url = URL(string: baseURL + endpoint) else {
            throw GoalNetworkError.invalidURL
        }
        return url
    }
} 
