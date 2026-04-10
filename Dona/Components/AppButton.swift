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
}

struct AppButton: View {
    @Environment(\.theme) private var theme

    let title: String
    let state: AppButtonState
    let action: () -> Void

    var body: some View {
        Button {
            guard state == .default else { return }
            action()
        } label: {
            ZStack {
                if state == .loading {
                    ProgressView()
                        .tint(theme.text.foregroundStaticWhite)
                } else {
                    Text(title)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.foregroundStaticWhite)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background {
                LinearGradient(
                    colors: state == .disabled
                        ? [Color(hex: "#9E9EA7"), Color(hex: "#9E9EA7")]
                        : [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                    startPoint: .trailing,
                    endPoint: .leading
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
        .disabled(state == .disabled || state == .loading)
        .animation(.easeInOut(duration: 0.2), value: state)
    }
}

#Preview {
    ThemeProvider {
        VStack(spacing: 16) {
            AppButton(title: "Continue", state: .default) {}
            AppButton(title: "Continue", state: .disabled) {}
            AppButton(title: "Continue", state: .loading) {}
        }
        .padding()
    }
}
