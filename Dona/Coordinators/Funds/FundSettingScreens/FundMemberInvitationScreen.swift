//
//  FundMemberInvitationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundMemberInvitationScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @StateObject private var viewModel = FundInvitationViewModel()
    @FocusState private var isFocused: Bool

    let fundId: Int

    @State private var animatedStep: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)
                .padding(.vertical, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Invite Community Members")
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("Search and invite Dona users to join your fund. They will receive a notification.")
                            .font(AppFont.largeRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }

                    makePhoneInput()

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(AppFont.mediumRegular)
                            .foregroundStyle(theme.text.onErrorContainer)
                    }

                    if viewModel.isSuccess {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(theme.text.foregroundSuccess1)
                            Text("Invitation sent!")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.foregroundSuccess1)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(theme.background.backgroundSuccess)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.bottom, 16)
            }

            VStack(spacing: 6) {
                AppButton(
                    title: "Invite member",
                    state: viewModel.isLoading ? .loading : .default
                ) {
                    viewModel.invite(fundId: fundId)
                }
                AppButton(title: "Skip now", state: .white) {
                    routes = []
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) { animatedStep = 4 }
            }
        }
    }

    @ViewBuilder func makePhoneInput() -> some View {
        HStack(spacing: 0) {
            Text("+992 ")
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.onSurface)
                .padding(.leading, 16)

            TextField("00 000 00 00", text: $viewModel.phone)
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.onSurface)
                .keyboardType(.phonePad)
                .focused($isFocused)
                .padding(.vertical, 17)
                .onChange(of: viewModel.phone) { newValue in
                    let digits = newValue.filter { $0.isNumber }
                    viewModel.phone = String(digits.prefix(9))
                }
        }
        .frame(height: 56)
        .background(theme.background.secondaryContainer)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { isFocused = true }
        }
    }
}
