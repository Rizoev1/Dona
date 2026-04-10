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
        content
            .background {
                LinearGradient(
                    colors: [theme.background.inversePrimary, theme.background.background],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}
