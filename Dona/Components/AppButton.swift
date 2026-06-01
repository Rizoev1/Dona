//
//  AppButton.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import SwiftUI

enum AppButtonState {
    case `default`
    case disabled
    case loading
    case white
}

struct AppButton: View {
    @Environment(\.theme) private var theme
    @AppStorage("appLanguage") private var _language: String = "en"

    let title: String
    let state: AppButtonState
    let action: () -> Void

    var body: some View {
        Button {
            guard state == .default || state == .white else { return }
            HapticManager.impact(.light)
            action()
        } label: {
            ZStack {
                if state == .loading {
                    ProgressView()
                        .tint(theme.text.foregroundStaticWhite)
                } else {
                    Text(title)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(
                            state == .white
                                ? theme.text.onSurface
                                : theme.text.foregroundStaticWhite
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background {
                if state == .white {
                    theme.background.background
                } else {
                    LinearGradient(
                        colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
        .opacity(state == .disabled ? 0.4 : 1.0)
        .disabled(state == .disabled || state == .loading)
        .animation(.easeInOut(duration: 0.2), value: state)
    }
}

#Preview {
    ThemeProvider {
        VStack(spacing: 16) {
            AppButton(title: "Continue".localized, state: .default) {}
            AppButton(title: "Continue".localized, state: .disabled) {}
            AppButton(title: "Continue".localized, state: .loading) {}
        }
        .padding()
    }
}
