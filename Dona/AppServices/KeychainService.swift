//
//  KeychainService.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import KeychainSwift

final class KeychainService {
    struct Key {
        static let accessToken  = "access_token"
        static let refreshToken = "refresh_token"
        static let sessionToken = "session_token"
    }

    static let shared = KeychainService()

    private let keychain = KeychainSwift()

    init() {}

    var accessToken: String? {
        get { keychain.get(Key.accessToken) }
        set {
            if let newValue {
                keychain.set(newValue, forKey: Key.accessToken)
            } else {
                keychain.delete(Key.accessToken)
            }
        }
    }

    var refreshToken: String? {
        get { keychain.get(Key.refreshToken) }
        set {
            if let newValue {
                keychain.set(newValue, forKey: Key.refreshToken)
            } else {
                keychain.delete(Key.refreshToken)
            }
        }
    }

    var sessionToken: String? {
        get { keychain.get(Key.sessionToken) }
        set {
            if let newValue {
                keychain.set(newValue, forKey: Key.sessionToken)
            } else {
                keychain.delete(Key.sessionToken)
            }
        }
    }

    func saveTokens(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
    }

    func clear() {
        keychain.clear()
    }
}
