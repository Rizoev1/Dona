//
//  PinScreen.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI

enum PinScreenState {
    case create
    case confirm
    case enter
}

struct PinScreen: View {
    @Environment(\.theme) private var theme
    @State private var pin: [Int] = []
    @State private var firstPin: [Int] = []
    @State private var savedPin: [Int] = []
    @State private var screenState: PinScreenState
    @State private var isError: Bool = false

    var onForgotPin: (() -> Void)?
    var onSuccess: (() -> Void)?

    init(savedPin: [Int] = [], onForgotPin: (() -> Void)? = nil, onSuccess: (() -> Void)? = nil) {
        _savedPin = State(initialValue: savedPin)
        _screenState = State(initialValue: savedPin.isEmpty ? .create : .enter)
        self.onForgotPin = onForgotPin
        self.onSuccess = onSuccess
    }

    let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "delete"]
    ]

    var title: String {
        switch screenState {
        case .create: return "Create a PIN"
        case .confirm: return "Confirm PIN"
        case .enter: return "Enter your PIN to log in"
        }
    }

    var showSubtitle: Bool {
        screenState != .enter
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)
                if showSubtitle {
                    Text("For secure access")
                        .font(AppFont.largeRegular)
                        .foregroundStyle(theme.text.onSecondary)
                }
            }

            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    ForEach(0 ..< 4, id: \.self) { index in
                        Circle()
                            .fill(isError
                                ? theme.text.onErrorContainer
                                : (index < pin.count
                                    ? theme.text.primaryContainer
                                    : theme.text.onTertiaryContainer))
                            .frame(
                                width: isError ? 8 : (index < pin.count ? 12 : 8),
                                height: isError ? 8 : (index < pin.count ? 12 : 8)
                            )
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pin.count)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isError)
                    }
                }
                .frame(height: 20)

                if isError {
                    Text("Incorrect PIN")
                        .font(AppFont.largeRegular)
                        .foregroundStyle(theme.text.onErrorContainer)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isError)

            Spacer().frame(height: 100)

            VStack(spacing: 0) {
                ForEach(keys, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(row, id: \.self) { key in
                            if key == "delete" {
                                Button {
                                    if !pin.isEmpty {
                                        pin.removeLast()
                                        isError = false
                                    }
                                } label: {
                                    Image(.tagCross)
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(theme.text.onTertiaryContainer)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                            } else if key.isEmpty {
                                Group {
                                    if screenState == .enter {
                                        Button {
                                            // Face ID action
                                        } label: {
                                            Image(.faceId)
                                                .resizable()
                                                .frame(width: 28, height: 28)
                                                .foregroundStyle(theme.stroke.scrim)
                                        }
                                    } else {
                                        Spacer()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                            } else {
                                Button {
                                    handleKeyPress(key)
                                } label: {
                                    Text(key)
                                        .font(AppFont.heading3)
                                        .foregroundStyle(theme.text.onSurface)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                            }
                        }
                    }
                }
            }

            if screenState == .enter {
                Button {
                    onForgotPin?()
                } label: {
                    Text("Forgot PIN?")
                        .font(AppFont.largeSemibold)
                        .foregroundStyle(theme.text.primaryContainer)
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 24)
        .appBackground()
    }

    private func handleKeyPress(_ key: String) {
        guard pin.count < 4, let digit = Int(key) else { return }
        isError = false
        pin.append(digit)

        guard pin.count == 4 else { return }

        switch screenState {
        case .create:
            firstPin = pin
            pin = []
            screenState = .confirm

        case .confirm:
            if pin == firstPin {
                savedPin = pin
                pin = []
                screenState = .enter
                onSuccess?()
            } else {
                showError()
            }

        case .enter:
            if pin == savedPin {
                pin = []
                onSuccess?()
            } else {
                showError()
            }
        }
    }

    private func showError() {
        withAnimation {
            isError = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            pin = []
        }
    }
}

#Preview {
    PinScreen()
}
