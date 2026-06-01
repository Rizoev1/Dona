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
    @StateObject private var tabRouter = TabRouter.shared

    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            HomeCoordinator()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            FundsCoordinator()
                .tabItem { Label("Funds", systemImage: "chart.pie.fill") }
                .tag(1)

            PaymentsCoordinator()
                .tabItem { Label("Payments", systemImage: "creditcard.fill") }
                .tag(2)
        }
        .environmentObject(tabRouter)
    }
}
