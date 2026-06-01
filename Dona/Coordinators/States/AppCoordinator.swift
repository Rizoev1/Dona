//
//  AppCoordinator.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import FlowStacks
import SwiftUI

struct AppCoordinator: View {
    @ObservedObject private var authService = AuthenticationService.shared

    var body: some View {
        switch authService.status {
        case .idle:
            SplashScreen()
        case .unauthenticated:
            UnauthenticatedCoordinator()
        case .pendingPin:
            PinScreen(
                mode: .enter,
                allowsBiometrics: true,
                onForgotPin: {
                    KeychainService.shared.clear()
                    AuthenticationService.shared.status = .unauthenticated
                },
                onSuccess: {
                    AuthenticationService.shared.status = .authenticated
                }
            )
        case .authenticated:
            AuthenticatedCoordinator()
        }
    }
}
