//
//  UnauthenticatedCoordinator.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI
import FlowStacks

enum UnauthenticatedRouter: Hashable {
    case login
    case verification
    case pin(savedPin: [Int])
}

struct UnauthenticatedCoordinator: View {
    @State private var routes: Routes<UnauthenticatedRouter> = []
    
    var body: some View {
        FlowStack($routes, withNavigation: true) {
            LanguageOnboardingScreen()
                .flowDestination(for: UnauthenticatedRouter.self) { screen in
                    switch screen {
                    case .login:
                        LogInScreen()
                    case .verification:
                        VerificationScreen()
                    case .pin(let savedPin):
                        PinScreen(savedPin: savedPin, onSuccess:  {
                            AuthenticationService.shared.status = .authenticated
                        })
                    }
                }
        }
    }
}
