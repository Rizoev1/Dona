//
//  PaymentsCoordinator.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import FlowStacks
import SwiftUI

struct PaymentsCoordinator: View {
    @State private var routes: Routes<PaymentsRouter> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            PaymentsScreen()
        }
    }
}

enum PaymentsRouter: Hashable {}
