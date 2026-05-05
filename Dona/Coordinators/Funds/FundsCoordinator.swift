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
    case fundAmount
    case fundRules
    case fundInvitation
    case fundDetails
    case approvals
    case members
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
                    case .fundAmount:
                        FundAmountSetting(routes: $routes)
                    case .fundRules:
                        FundCommunityRulesScreen(routes: $routes)
                    case .fundInvitation:
                        FundMemberInvitationScreen(routes: $routes)
                    case .fundDetails:
                        IndividualFundScreen(routes: $routes)
                    case .approvals:
                        ApprovalsScreen()
                    case .members:
                        MembersScreen()
                    case .payment(let type):
                        PaymentScreen(type: type)
                    }
                }
        }
    }
}
