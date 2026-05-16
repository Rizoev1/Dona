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
        case idle           // Splash: not yet determined
        case unauthenticated
        case pendingPin     // Session token exists — PIN entry required
        case authenticated
    }

    static var shared = AuthenticationService()

    @Published var status: Status = .idle

    init() {}

    // Called by SplashScreen after brief animation
    func resolveInitialStatus() {
        if KeychainService.shared.sessionToken != nil {
            status = .pendingPin
        } else {
            status = .unauthenticated
        }
    }
}
