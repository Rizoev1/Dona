//
//  AuthenticatedCoordinator.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI
import FlowStacks

enum AuthenticatedRouter: Hashable {
    case home
    // добавьте остальные экраны
}

struct AuthenticatedCoordinator: View {
    @State private var routes: Routes<AuthenticatedRouter> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            HomeScreen()
                .flowDestination(for: AuthenticatedRouter.self) { screen in
                    switch screen {
                    case .home:
                        HomeScreen()
                    }
                }
        }
    }
}
