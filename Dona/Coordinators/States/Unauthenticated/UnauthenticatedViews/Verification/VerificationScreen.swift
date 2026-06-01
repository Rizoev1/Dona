//
//  VerificationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import SwiftUI
import FlowStacks

struct VerificationScreen: View {
    @EnvironmentObject var navigator: FlowNavigator<UnauthenticatedRouter>
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: VerificationViewModel
    @FocusState private var isFocused: Bool
    @State private var code: String = ""
    @State private var didNavigate = false

    init(phone: String) {
        _viewModel = StateObject(wrappedValue: VerificationViewModel(phone: phone))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 80)

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Enter the SMS code")
                        .font(AppFont.heading2)
                        .foregroundStyle(theme.text.onSurface)
                    Text("We sent it to your phone number")
                        .font(AppFont.largeRegular)
                        .foregroundStyle(theme.text.onSecondary)
                }
                makeCodeField()

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onErrorContainer)
                }

                if viewModel.isResending {
                    ProgressView()
                } else {
                    Text("Resend code")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.primaryContainer)
                        .onTapGesture {
                            viewModel.resendOtp()
                        }
                }
            }
            .padding(20)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 32))

            Spacer()
        }
        .padding(.horizontal)
        .appBackground()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
        .onDisappear {
            isFocused = false
        }
    }

    @ViewBuilder
    func makeCodeField() -> some View {
        ZStack {
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    let digitsOnly = code.filter { $0.isNumber }
                    let character = index < digitsOnly.count
                        ? String(digitsOnly[digitsOnly.index(digitsOnly.startIndex, offsetBy: index)])
                        : ""
                    let isActive = isFocused && (digitsOnly.count == index || (digitsOnly.count == 6 && index == 5))

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(theme.background.secondaryContainer)
                            .frame(width: 54, height: 54)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(theme.stroke.scrim, lineWidth: isActive ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.2), value: isActive)
                            }

                        if viewModel.isLoading && digitsOnly.count == 6 {
                            ProgressView()
                                .frame(width: 20, height: 20)
                        } else {
                            Text(character)
                                .font(AppFont.heading4)
                                .foregroundStyle(theme.text.onSurface)
                        }
                    }
                }
            }

            TextField("", text: Binding(
                get: { code },
                set: { newValue in
                    guard !viewModel.isLoading else { return }
                    let digits = newValue.filter { $0.isNumber }
                    code = String(digits.prefix(6))

                    if code.count == 6 && !didNavigate {
                        didNavigate = true
                        viewModel.verifyOtp(code: code) { sessionToken, command in
                            switch command {
                            case .setPin:
                                navigator.push(.pinSetup(sessionToken: sessionToken))
                            case .checkPin:
                                navigator.push(.pinVerify)
                            }
                        }
                    }
                }
            ))
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .foregroundColor(.clear)
            .accentColor(.clear)
            .focused($isFocused)
            .frame(width: 0, height: 0)
            .opacity(0.01)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .onChange(of: viewModel.errorMessage) { error in
            if error != nil { didNavigate = false }
        }
    }
}

#Preview {
    VerificationScreen(phone: "992901234567")
}
