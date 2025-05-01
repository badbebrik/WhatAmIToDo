//
//  KeychainManager.swift
//  WhatAmIToDo
//
//  Created by Виктория Серикова on 01.05.2025.
//

import Foundation

// MARK: — Keychain

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    private let accessKey  = "access_token"
    private let refreshKey = "refresh_token"

    func saveTokens(access: String, refresh: String) {
        save(key: accessKey,  value: access)
        save(key: refreshKey, value: refresh)
    }
    func getAccessToken() -> String?  { read(key: accessKey) }
    func getRefreshToken() -> String? { read(key: refreshKey) }

    func clearTokens() {
        delete(key: accessKey)
        delete(key: refreshKey)
    }

    private func save(key: String, value: String) {
        let data  = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecValueData   : data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    private func read(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData  : true,
            kSecMatchLimit  : kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    private func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass       : kSecClassGenericPassword,
            kSecAttrAccount : key
        ]
        SecItemDelete(query as CFDictionary)
    }
}

