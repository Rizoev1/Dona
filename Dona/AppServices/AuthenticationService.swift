//
//  AuthenticationService.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import Foundation
import Combine

class AuthenticationService: ObservableObject {
    enum Status {
        case authenticated
        case unauthenticated
        case idle
    }
    
    static var shared: AuthenticationService = AuthenticationService()
    
    @Published var status: Status = .unauthenticated {
        willSet(newValue) {
            switch newValue {
            case .authenticated:
                print("authenticated")
            case .unauthenticated:
                print("unauthenticated")
            default:
                break
            }
        }
    }
}
