//
//  FundCommunityRulesScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundCommunityRulesScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @StateObject private var viewModel = FundCreationViewModel()

    let fundName: String
    let apy: Double?

    @State private var contributions: String = ""
    @State private var withdrawals: String = ""
    @State private var animatedStep: Int = 2
    @FocusState private var contributionsFocused: Bool
    @FocusState private var withdrawalsFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)
                .padding(.vertical, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Community Rules".localized)
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("Define the terms for your savings circle. Members must accept these to participate.".localized)
                            .font(AppFont.largeRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        makeGeneralRules()
                        makeContributions()
                        makeWithdrawals()
                        makeResolution()
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(AppFont.mediumRegular)
                            .foregroundStyle(theme.text.onErrorContainer)
                    }

                    AppButton(title: "Continue".localized, state: viewModel.isLoading ? .loading : .default) {
                        viewModel.createFund(name: fundName, apy: apy) { fundId in
                            routes.push(.fundInvitation(fundId: fundId))
                        }
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Create fund".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) { animatedStep = 3 }
            }
        }
    }

    @ViewBuilder func makeGeneralRules() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(.shield)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Text("General Rules".localized)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Charter & Purpose".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Text("This group is dedicated to collective saving and financial growth. We commit to consistent deposits to build a secure fund for future goals and emergencies.".localized)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeContributions() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(.moneyReceive)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Text("Contributions".localized)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Min. Deposit".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        TextField("0", text: $contributions)
                            .font(AppFont.mediumMedium)
                            .foregroundColor(theme.text.onSurface)
                            .tint(theme.text.onSurface)
                            .keyboardType(.numberPad)
                            .focused($contributionsFocused)
                            .fixedSize()
                        Text("TJS")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                Image(.moneys)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(theme.text.onTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture { contributionsFocused = true }
            VStack(alignment: .leading, spacing: 4) {
                Text("Late Policy".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Text("Missed deposits disrupt the saving cycle. Late payments incur a fixed 10 TJS fee added to the community reserve.".localized)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeWithdrawals() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(.arrowRightCircle)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Text("Withdrawals".localized)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Withdrawals".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Text("Withdrawals are permitted for emergencies or stated goals. Requests must be submitted 3 days in advance for Director approval.".localized)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Min. Withdrawal".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        TextField("0", text: $withdrawals)
                            .font(AppFont.mediumMedium)
                            .foregroundColor(theme.text.onSurface)
                            .tint(theme.text.onSurface)
                            .keyboardType(.numberPad)
                            .focused($withdrawalsFocused)
                            .fixedSize()
                        Text("%")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                Image(.moneys)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(theme.text.onTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture { withdrawalsFocused = true }
        }
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeResolution() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(.reserve)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Text("Dispute Resolution".localized)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Resolution Process".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Text("Disputes regarding account balances or withdrawal denials are mediated by the Director. Unresolved issues are settled by a binding member vote.".localized)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(12)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
