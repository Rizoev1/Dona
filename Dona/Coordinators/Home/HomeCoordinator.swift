//
//  HomeCoordinator.swift
//  Dona
//
//  Created by Damir Rizoev on 15/04/26.
//

import FlowStacks
import SwiftUI

enum FundSelectionType: Hashable {
    case request
    case send
}

enum HomeRouter: Hashable {
    case home
    case notifications
    case activity
    case services
    case subServices(title: String)
    case payment(PaymentScreenType)
    case fundSelection(FundSelectionType)
    case profile
    case fundDetails(fund: Fund)
    case fundActivity(fundId: Int)
    case fundReport(fundId: Int)
    case fundApprovals(fundId: Int)
    case fundMembers(fundId: Int)
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
                    case .fundDetails(let fund):
                        IndividualFundScreen(
                            fund: fund,
                            onTopUp:     { routes.push(.payment(.topUp)) },
                            onRequest:   { f in routes.push(.payment(.request(fund: f))) },
                            onMembers:   { id in routes.push(.fundMembers(fundId: id)) },
                            onApprovals: { id in routes.push(.fundApprovals(fundId: id)) },
                            onActivity:  { id in routes.push(.fundActivity(fundId: id)) },
                            onReport:    { id in routes.push(.fundReport(fundId: id)) }
                        )
                    case .fundActivity(let fundId):
                        ActivityScreen(fundId: fundId)
                    case .fundReport(let fundId):
                        FundReportScreen(fundId: fundId)
                    case .fundApprovals(let fundId):
                        ApprovalsScreen(fundId: fundId)
                    case .fundMembers(let fundId):
                        MembersScreen(fundId: fundId)
                    }
                }
        }
    }
}

