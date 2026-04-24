//
//  AuthenticationService.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import Foundation
import Combine

class AuthenticationService: ObservableObject {
    enum Status: String {
        case authenticated
        case unauthenticated
        case idle
    }
    
    static var shared = AuthenticationService()
    
    private let key = "auth_status"
    
    @Published var status: Status = .idle {
        didSet {
            UserDefaults.standard.set(status.rawValue, forKey: key)
        }
    }
    
    init() {
        if let saved = UserDefaults.standard.string(forKey: key),
           let status = Status(rawValue: saved) {
            self.status = status
        } else {
            self.status = .unauthenticated
        }
    }
}
