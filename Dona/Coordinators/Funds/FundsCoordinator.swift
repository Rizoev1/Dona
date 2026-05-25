//
//  FundsCoordinator.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import FlowStacks
import SwiftUI

enum FundsRouter: Hashable {
    case funds
    case fundNaming
    case fundAmount(name: String)
    case fundRules(name: String, apy: Double?)
    case fundInvitation(fundId: Int)
    case fundDetails(fund: Fund)
    case fundActivity(fundId: Int)
    case fundReport(fundId: Int)
    case approvals(fundId: Int)
    case members(fundId: Int)
    case payment(PaymentScreenType)
}

struct FundsCoordinator: View {
    @State private var routes: Routes<FundsRouter> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            FundsScreen(routes: $routes)
                .flowDestination(for: FundsRouter.self) { screen in
                    switch screen {
                    case .funds:
                        FundsScreen(routes: $routes)
                    case .fundNaming:
                        FundNamingScreen(routes: $routes)
                    case .fundAmount(let name):
                        FundAmountSetting(routes: $routes, fundName: name)
                    case .fundRules(let name, let apy):
                        FundCommunityRulesScreen(routes: $routes, fundName: name, apy: apy)
                    case .fundInvitation(let fundId):
                        FundMemberInvitationScreen(routes: $routes, fundId: fundId)
                    case .fundDetails(let fund):
                        IndividualFundScreen(
                            fund: fund,
                            onTopUp:    { routes.push(.payment(.topUp)) },
                            onRequest:  { f in routes.push(.payment(.request(fund: f))) },
                            onMembers:  { id in routes.push(.members(fundId: id)) },
                            onApprovals:{ id in routes.push(.approvals(fundId: id)) },
                            onActivity: { id in routes.push(.fundActivity(fundId: id)) },
                            onReport:   { id in routes.push(.fundReport(fundId: id)) }
                        )
                    case .fundActivity(let fundId):
                        ActivityScreen(fundId: fundId)
                    case .fundReport(let fundId):
                        FundReportScreen(fundId: fundId)
                    case .approvals(let fundId):
                        ApprovalsScreen(fundId: fundId)
                    case .members(let fundId):
                        MembersScreen(fundId: fundId)
                    case .payment(let type):
                        PaymentScreen(type: type)
                    }
                }
        }
    }
}
