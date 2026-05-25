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
    case verification(phone: String)
    case pinSetup(sessionToken: String)
    case pinVerify
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
                    case .verification(let phone):
                        VerificationScreen(phone: phone)
                    case .pinSetup(let sessionToken):
                        PinScreen(
                            mode: .setup(sessionToken: sessionToken),
                            onSuccess: {
                                AuthenticationService.shared.status = .authenticated
                            }
                        )
                    case .pinVerify:
                        PinScreen(
                            mode: .enter,
                            onSuccess: {
                                AuthenticationService.shared.status = .authenticated
                            }
                        )
                    }
                }
        }
    }
}
