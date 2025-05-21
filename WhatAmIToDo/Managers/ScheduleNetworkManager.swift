//
//  ScheduleNetworkManager.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 10.05.2025.
//

import Foundation

private enum ScheduleEndpoint {
    case updateAvailability(goalId: UUID, body: UpdateAvailabilityRequest)
    case getAvailability(goalId: UUID)
    case autoSchedule(goalId: UUID)
    case getSchedule(date: String?)
    case getScheduleRange(start: String, end: String)
    case upcomingTasks(limit: Int)
    case stats
    case motivationToday

    var requiresAuth: Bool { true }

    var method: String {
        switch self {
        case .getAvailability, .getSchedule, .getScheduleRange,
             .upcomingTasks, .stats, .motivationToday:
            return "GET"
        case .updateAvailability, .autoSchedule:
            return "POST"
        }
    }

    var path: String {
        switch self {
        case .updateAvailability(let id, _),
             .getAvailability(let id):
            return "/api/availability/\(id)"
        case .autoSchedule(let id):
            return "/api/availability/\(id)/schedule"
        case .getSchedule:
            return "/api/schedule"
        case .getScheduleRange:
            return "/api/schedule"
        case .upcomingTasks:
            return "/api/tasks/upcoming"
        case .stats:
            return "/api/stats"
        case .motivationToday:
            return "/api/motivation/today"
        }
    }

    func body() throws -> Data? {
        switch self {
        case .updateAvailability(_, let body):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try encoder.encode(body)
        default: return nil
        }
    }

    func queryItems() -> [URLQueryItem]? {
        switch self {
        case .getSchedule(let date?) :
            return [.init(name: "date", value: date)]
        case .getScheduleRange(let start, let end):
            return [
                .init(name: "start_date", value: start),
                .init(name: "end_date",   value: end)
            ]
        case .upcomingTasks(let limit) :
            return [.init(name: "limit", value: "\(limit)")]
        default: return nil
        }
    }
}


@MainActor
final class ScheduleNetworkManager {

    static let shared = ScheduleNetworkManager()

    private let baseURL = URL(string: "http://localhost:8080")!
    private let session : URLSession

    private init() {
        let cfg = URLSessionConfiguration.default
        session = URLSession(configuration: cfg)
    }

    private func request<T: Decodable>(_ ep: ScheduleEndpoint) async throws -> T {
        var comps = URLComponents(url: baseURL.appendingPathComponent(ep.path),
                                  resolvingAgainstBaseURL: false)!
        comps.queryItems = ep.queryItems()

        guard let url = comps.url else { throw NetworkError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = ep.method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let body = try ep.body() { 
            req.httpBody = body
            print("[Network] Request to \(ep.path):")
            print("[Network] Method: \(ep.method)")
            if let bodyString = String(data: body, encoding: .utf8) {
                print("[Network] Body: \(bodyString)")
            }
        }

        if let token = KeychainManager.shared.getAccessToken() {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, resp) = try await session.data(for: req)
        guard let http = resp as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            print("[Network] Error on \(ep.path):")
            print("[Network] Status code: \((resp as? HTTPURLResponse)?.statusCode ?? -1)")
            throw NetworkError.invalidResponse(
                statusCode: (resp as? HTTPURLResponse)?.statusCode ?? -1
            )
        }

        print("[Network] Response from \(ep.path):")
        if let responseString = String(data: data, encoding: .utf8) {
            print("[Network] Body: \(responseString)")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { dateinput in
            let container = try dateinput.singleValueContainer()
            let str = try container.decode(String.self)
            if let date = iso.date(from: str) { return date }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Bad date \(str)"
            )
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }


    func updateAvailability(goalId: UUID,
                            body: UpdateAvailabilityRequest) async throws -> AvailabilityResponse {
        try await request(.updateAvailability(goalId: goalId, body: body))
    }

    func availability(for goalId: UUID) async throws -> AvailabilityResponse {
        try await request(.getAvailability(goalId: goalId))
    }

    func autoSchedule(goalId: UUID) async throws {
        struct Dummy: Codable {}
        _ = try await request(_: .autoSchedule(goalId: goalId)) as Dummy
    }

    func schedule(for date: Date) async throws -> ScheduleDayResponse {
        try await request(.getSchedule(date: date.ymd))
    }

    func schedule(from start: Date, to end: Date) async throws -> [ScheduleDayResponse] {
        try await request(.getScheduleRange(start: start.ymd, end: end.ymd))
    }

    func upcomingTasks(limit: Int = 5) async throws -> [ScheduledTaskDTO] {
        try await request(.upcomingTasks(limit: limit))
    }

    func stats() async throws -> StatsResponse {
        try await request(.stats)
    }

    func motivationToday() async throws -> MotivationTodayResponse {
        try await request(.motivationToday)
    }
}


private extension Date {
    var ISO8601Date: String {
        ISO8601DateFormatter().string(from: self).prefix(10).description
    }
}
