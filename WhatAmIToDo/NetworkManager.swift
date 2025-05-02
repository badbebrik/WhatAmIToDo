//
//  NetworkManager.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 01.05.2025.
//

import Foundation

// MARK: — Ошибки сетевого слоя

enum NetworkError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
}

// MARK: — HTTP-методы

private enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}

// MARK: — Эндпоинты

enum Endpoint {
    case googleLogin(idToken: String)
    case login(email: String, password: String)
    case signup(name: String, email: String, password: String)
    case sendVerificationCode(email: String)
    case verifyCode(email: String, code: String)
    case refresh(refreshToken: String)
    case logout(refreshToken: String)
    case getMe

    /// Нужно ли добавлять Authorization
    var requiresAuth: Bool {
        switch self {
        case .googleLogin, .login, .signup, .sendVerificationCode, .verifyCode, .refresh, .logout:
            return false
        case .getMe:
            return true
        }
    }

    /// URL-путь (относительно baseURL)
    var path: String {
        switch self {
        case .googleLogin:          return "/api/auth/google"
        case .login:                return "/api/auth/login"
        case .signup:               return "/api/auth/signup"
        case .sendVerificationCode: return "/api/auth/send-code"
        case .verifyCode:           return "/api/auth/verify-email"
        case .refresh:              return "/api/auth/refresh"
        case .logout:               return "/api/auth/logout"
        case .getMe:                return "/api/auth/me"
        }
    }

    fileprivate var method: HTTPMethod {
        switch self {
        case .getMe:
            return .get
        default:
            return .post
        }
    }

    /// Тело запроса
    var body: Data? {
        struct Payload: Encodable {
            let idToken: String?
            let email: String?
            let password: String?
            let name: String?
            let code: String?
            let refreshToken: String?

            init(idToken: String? = nil,
                 email: String? = nil,
                 password: String? = nil,
                 name: String? = nil,
                 code: String? = nil,
                 refreshToken: String? = nil) {
                self.idToken     = idToken
                self.email        = email
                self.password     = password
                self.name         = name
                self.code         = code
                self.refreshToken = refreshToken
            }
        }

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        switch self {
        case .googleLogin(let id):
            return try? encoder.encode(Payload(idToken: id))
        case .login(let email, let pass):
            return try? encoder.encode(Payload(email: email, password: pass))
        case .signup(let name, let email, let pass):
            return try? encoder.encode(Payload(email: email, password: pass, name: name))
        case .sendVerificationCode(let email):
            return try? encoder.encode(Payload(email: email))
        case .verifyCode(let email, let code):
            return try? encoder.encode(Payload(email: email, code: code))
        case .refresh(let rt):
            return try? encoder.encode(Payload(refreshToken: rt))
        case .logout(let rt):
            return try? encoder.encode(Payload(refreshToken: rt))
        case .getMe:
            return nil
        }
    }

    /// Собирает URLRequest, включая заголовки и тело
    func makeRequest(baseURL: URL, accessToken: String?) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = body {
            req.httpBody = body
        }
        if requiresAuth, let token = accessToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return req
    }
}


@MainActor
final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: "http://localhost:8080")!
    private let session: URLSession
    private var isRefreshing = false

    private init() {
        let cfg = URLSessionConfiguration.default
        cfg.waitsForConnectivity = true
        session = URLSession(configuration: cfg)
    }

    /// Общий метод запроса и декодирования JSON
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let token = KeychainManager.shared.getAccessToken()
        let req   = try endpoint.makeRequest(baseURL: baseURL, accessToken: token)

        do {
            let data = try await perform(request: req, needsAuth: endpoint.requiresAuth)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let err as NetworkError {
            throw err
        } catch {
            throw NetworkError.unknown(error)
        }
    }

    private func perform(request: URLRequest, needsAuth: Bool) async throws -> Data {
        print("Making request to: \(request.url?.absoluteString ?? "unknown URL")")
        print("Method: \(request.httpMethod ?? "unknown")")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Request body: \(bodyString)")
        }
        
        let (data, resp) = try await session.data(for: request)
        if let http = resp as? HTTPURLResponse {
            print("Response status code: \(http.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response body: \(responseString)")
            }
        }
        
        if let http = resp as? HTTPURLResponse, http.statusCode == 401, needsAuth {
            print("Received 401, attempting to refresh token...")
            try await refreshToken()
            var retry = request
            if let newAT = KeychainManager.shared.getAccessToken() {
                retry.setValue("Bearer \(newAT)", forHTTPHeaderField: "Authorization")
            }
            let (data2, resp2) = try await session.data(for: retry)
            guard let http2 = resp2 as? HTTPURLResponse, 200..<300 ~= http2.statusCode else {
                throw NetworkError.invalidResponse(statusCode: (resp2 as? HTTPURLResponse)?.statusCode ?? -1)
            }
            return data2
        }

        if let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode {
            return data
        } else if let http = resp as? HTTPURLResponse {
            throw NetworkError.invalidResponse(statusCode: http.statusCode)
        }
        return data
    }

    private func refreshToken() async throws {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        let rt = KeychainManager.shared.getRefreshToken() ?? ""
        let resp: RefreshResponse = try await request(.refresh(refreshToken: rt))
        KeychainManager.shared.saveTokens(
            access: resp.accessToken,
            refresh: resp.refreshToken
        )
    }
}
