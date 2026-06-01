//
//  SplashScreen.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI

struct SplashScreen: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ZStack {
            theme.background.background.ignoresSafeArea()
            VStack(spacing: 16) {
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text("Dona".localized)
                    .font(AppFont.heading1)
                    .foregroundStyle(theme.text.onSurface)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                AuthenticationService.shared.resolveInitialStatus()
            }
        }
    }
}

#Preview {
    SplashScreen()
}
