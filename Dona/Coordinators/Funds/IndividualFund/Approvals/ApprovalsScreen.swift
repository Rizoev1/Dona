//
//  ApprovalsScreen.swift
//  Dona
//
//  Created by Damir.Rizoev on 05/05/26.
//

import SwiftUI

struct ApprovalsScreen: View {
    @Environment(\.theme) var theme
    @StateObject private var viewModel: ApprovalsViewModel
    @AppStorage("appLanguage") private var _language: String = "en"

    init(fundId: Int) {
        _viewModel = StateObject(wrappedValue: ApprovalsViewModel(fundId: fundId))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                if viewModel.isLoading && viewModel.withdrawals.isEmpty {
                    withdrawalSkeleton()
                    withdrawalSkeleton()
                } else if !viewModel.isLoading && viewModel.withdrawals.isEmpty {
                    EmptyStateView(
                        icon: Image(systemName: "checkmark.circle"),
                        title: "No pending approvals".localized,
                        subtitle: "All withdrawal requests have been reviewed".localized
                    )
                } else {
                    ForEach(viewModel.withdrawals, id: \.id) { request in
                        makeWithdrawalCard(request)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Approvals".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder func makeWithdrawalCard(_ request: WithdrawalRequest) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("U\(request.userId)")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.primaryContainer)
                    .padding(10)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("User #\(request.userId)")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Text("WITHDRAWAL REQUEST".localized)
                        .font(AppFont.smallMedium)
                        .foregroundStyle(theme.text.foregroundWarning1)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(theme.background.backgroundWarning)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                Spacer()
                Text(request.shortDate)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Amount".localized)
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Spacer()
                    HStack(spacing: 4) {
                        Text(request.amountFormatted)
                            .font(AppFont.heading4)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                if request.fee > 0 {
                    HStack {
                        Text("Fee".localized)
                            .font(AppFont.mediumRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        Spacer()
                        Text(request.feeFormatted)
                            .font(AppFont.mediumMedium)
                            .foregroundStyle(theme.text.onSurface)
                    }
                }
            }
            .padding(16)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 10) {
                AppButton(title: "Reject".localized, state: .default) {
                    viewModel.reject(request)
                }
                AppButton(title: "Approve".localized, state: .default) {
                    viewModel.approve(request)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 8)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func withdrawalSkeleton() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ShimmerBox(width: 44, height: 44, cornerRadius: 22)
                VStack(alignment: .leading, spacing: 6) {
                    ShimmerBox(width: 100, height: 14)
                    ShimmerBox(width: 140, height: 20, cornerRadius: 60)
                }
                Spacer()
                ShimmerBox(width: 60, height: 12)
            }
            Divider()
            ShimmerBox(height: 80, cornerRadius: 20)
            HStack(spacing: 10) {
                ShimmerBox(height: 48, cornerRadius: 14)
                ShimmerBox(height: 48, cornerRadius: 14)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 8)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ApprovalsScreen(fundId: 1)
}
