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
    case funds
    case payments
}

struct AuthenticatedCoordinator: View {
    var body: some View {
        TabView {
            HomeCoordinator()
                .tabItem { Label("Home", systemImage: "house.fill") }

            FundsCoordinator()
                .tabItem { Label("Funds", systemImage: "chart.pie.fill") }

            PaymentsCoordinator()
                .tabItem { Label("Payments", systemImage: "creditcard.fill") }
        }
    }
}
