//
//  PinScreen.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI
import LocalAuthentication

struct PinScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel = PinViewModel()

    @State private var pin: [Int] = []
    @State private var firstPin: [Int] = []
    @State private var screenState: PinScreenState
    @State private var isError: Bool = false
    @State private var isPulsing: Bool = false
    @State private var shakeOffset: CGFloat = 0
    @State private var backendError: String?

    var errorText: String {
        if let msg = backendError { return msg }
        return screenState == .confirm ? "PINs don't match" : "Incorrect PIN"
    }

    let mode: PinMode
    let allowsBiometrics: Bool
    var onForgotPin: (() -> Void)?
    var onSuccess: (() -> Void)?

    init(mode: PinMode, allowsBiometrics: Bool = false, onForgotPin: (() -> Void)? = nil, onSuccess: (() -> Void)? = nil) {
        self.mode = mode
        self.allowsBiometrics = allowsBiometrics
        self.onForgotPin = onForgotPin
        self.onSuccess = onSuccess
        switch mode {
        case .setup: _screenState = State(initialValue: .create)
        case .enter: _screenState = State(initialValue: .enter)
        }
    }

    let keys: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "delete"]
    ]

    var biometricIcon: Image {
        viewModel.biometryType == .faceID ? Image(.faceId) : Image(systemName: "touchid")
    }

    var title: String {
        switch screenState {
        case .create: return "Create a PIN"
        case .confirm: return "Confirm PIN"
        case .enter: return "Enter your PIN to log in"
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            VStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)
                if screenState != .enter {
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
                                : (index < pin.count || viewModel.isLoading
                                    ? theme.text.primaryContainer
                                    : theme.text.onTertiaryContainer))
                            .frame(width: isError ? 12 : 12, height: isError ? 12 : 12)
                            .scaleEffect(viewModel.isLoading ? (isPulsing ? 1.3 : 0.7) : 1.0)
                            .animation(
                                viewModel.isLoading
                                    ? .easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(Double(index) * 0.1)
                                    : .spring(response: 0.3, dampingFraction: 0.6),
                                value: isPulsing
                            )
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pin.count)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isError)
                    }
                }
                .offset(x: shakeOffset)
                .frame(height: 20)

                if isError {
                    Text(errorText)
                        .font(AppFont.largeRegular)
                        .foregroundStyle(theme.text.onErrorContainer)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isError)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isLoading)

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
                                        viewModel.errorMessage = nil
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
                                    if screenState == .enter && allowsBiometrics && viewModel.biometryType != .none {
                                        Button {
                                            triggerBiometrics()
                                        } label: {
                                            biometricIcon
                                                .resizable()
                                                .scaledToFit()
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
                                .disabled(viewModel.isLoading)
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
        .onChange(of: viewModel.isLoading) { isLoading in
            isPulsing = isLoading
        }
        .onChange(of: viewModel.errorMessage) { error in
            guard let msg = error else { return }
            backendError = msg
            viewModel.errorMessage = nil
            showError()
        }
        .onAppear {
            if case .enter = mode, allowsBiometrics {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    triggerBiometrics()
                }
            }
        }
    }

    private func triggerBiometrics() {
        viewModel.authenticateWithBiometrics { onSuccess?() }
    }

    private func handleKeyPress(_ key: String) {
        guard pin.count < 4, let digit = Int(key), !viewModel.isLoading else { return }
        isError = false
        backendError = nil
        viewModel.errorMessage = nil
        pin.append(digit)

        guard pin.count == 4 else { return }

        switch screenState {
        case .create:
            firstPin = pin
            pin = []
            screenState = .confirm

        case .confirm:
            if pin == firstPin {
                let pinString = firstPin.map(String.init).joined()
                if case .setup(let sessionToken) = mode {
                    viewModel.setup(pin: pinString, sessionToken: sessionToken) {
                        onSuccess?()
                    }
                }
            } else {
                showError()
            }

        case .enter:
            let pinString = pin.map(String.init).joined()
            viewModel.verify(pin: pinString) {
                onSuccess?()
            }
        }
    }

    private func showError() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isError = true }

        let shakes: [(CGFloat, Double)] = [
            (-5, 0.0), (5, 0.1), (-3, 0.2), (3, 0.3), (0, 0.4)
        ]
        for (offset, delay) in shakes {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: 0.09)) { shakeOffset = offset }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            pin = []
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isError = false }
        }
    }
}

#Preview {
    PinScreen(mode: .enter)
}
