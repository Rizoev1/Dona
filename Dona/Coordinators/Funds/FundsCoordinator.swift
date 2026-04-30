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
                    }
                }
        }
    }
}
