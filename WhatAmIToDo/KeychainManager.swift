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
        print("Saving tokens to keychain...")
        save(key: accessKey,  value: access)
        save(key: refreshKey, value: refresh)
        print("Tokens saved successfully")
    }
    func getAccessToken() -> String?  { 
        let token = read(key: accessKey)
        print("Access token retrieved: \(token != nil ? "exists" : "nil")")
        return token
    }
    func getRefreshToken() -> String? { 
        let token = read(key: refreshKey)
        print("Refresh token retrieved: \(token != nil ? "exists" : "nil")")
        return token
    }

    func clearTokens() {
        print("Clearing tokens from keychain...")
        delete(key: accessKey)
        delete(key: refreshKey)
        print("Tokens cleared successfully")
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

