//
//  AppBackgroundModifier.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import Foundation
import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: theme.background.inversePrimary, location: 0.00),
                    Gradient.Stop(color: theme.background.surface, location: 0.32)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .ignoresSafeArea()

            content
        }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}
