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
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 300
        session = URLSession(configuration: configuration)
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
        var components = URLComponents(string: baseURL + "/api/goals")!
        components.queryItems = [
            URLQueryItem(name: "limit", value: String(request.limit)),
            URLQueryItem(name: "offset", value: String(request.offset))
        ]
        
        if let status = request.status {
            components.queryItems?.append(URLQueryItem(name: "status", value: status))
        }
        
        guard let url = components.url else {
            throw GoalNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoalNetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(ListGoalsResponse.self, from: data)
        case 401:
            throw GoalNetworkError.unauthorized
        default:
            throw GoalNetworkError.unknown
        }
    }
    
    // MARK: - Get Goal
    func getGoal(id: UUID) async throws -> GoalResponse {
        let endpoint = "/api/goals/\(id)"
        let url = try createURL(for: endpoint)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = await SessionManager.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GoalNetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(GoalResponse.self, from: data)
        case 401:
            throw GoalNetworkError.unauthorized
        default:
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
