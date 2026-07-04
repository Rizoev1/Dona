//
//  PaymentsCoordinator.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import FlowStacks
import SwiftUI

enum PaymentsRouter: Hashable {
    case subServices(serviceId: Int, title: String)
    case payment(PaymentScreenType)
}

struct PaymentsCoordinator: View {
    @State private var routes: Routes<PaymentsRouter> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            PaymentsScreen()
                .flowDestination(for: PaymentsRouter.self) { screen in
                    switch screen {
                    case .subServices(let serviceId, let title):
                        SubServicesScreen(serviceId: serviceId, title: title) { subService in
                            routes.push(.payment(.services(serviceId: subService.serviceId, subServiceId: subService.id, title: title, prefillAccount: nil, prefillAmount: nil)))
                        }
                    case .payment(let type):
                        PaymentScreen(type: type)
                    }
                }
        }
    }
}
