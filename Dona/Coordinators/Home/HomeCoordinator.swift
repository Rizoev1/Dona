//
//  HomeCoordinator.swift
//  Dona
//
//  Created by Damir Rizoev on 15/04/26.
//

import FlowStacks
import SwiftUI

enum HomeRouter: Hashable {
    case home
    case notifications
    case activity
    case services
    case subServices(title: String)
    case payment(PaymentScreenType)
    case fundSelection(PaymentScreenType)
    case profile
}

struct HomeCoordinator: View {
    @State private var routes: Routes<HomeRouter> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            HomeScreen()
                .flowDestination(for: HomeRouter.self) { screen in
                    switch screen {
                    case .home:
                        HomeScreen()
                    case .notifications:
                        NotificationsScreen()
                    case .activity:
                        ActivityScreen()
                    case .services:
                        ServicesScreen()
                    case .subServices(let title):
                        SubServicesScreen(title: title)
                    case .payment(let type):
                        PaymentScreen(type: type)
                    case .fundSelection(let type):
                        FundSelectionScreen(type: type)
                    case .profile:
                        ProfileScreen()
                    }
                }
        }
    }
}

