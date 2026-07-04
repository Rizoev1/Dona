//
//  FundsScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 28/04/26.
//

import SwiftUI
import FlowStacks

struct FundsScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @StateObject private var viewModel = FundsViewModel()
    @AppStorage("appLanguage") private var _language: String = "en"

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    makeOptionsBlock(text: "Create Community".localized, icon: Image(.add)) {
                        routes.push(.fundNaming)
                    }
                    makeOptionsBlock(text: "Migrate Existing Community".localized, icon: Image(.refresh)) {}
                }

                if viewModel.isLoading && viewModel.funds.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(0..<3, id: \.self) { _ in makeFundSkeleton() }
                    }
                } else if !viewModel.isLoading && viewModel.funds.isEmpty {
                    EmptyStateView(
                        icon: Image(.people),
                        title: "No communities yet".localized,
                        subtitle: "Create your first savings community to get started".localized
                    )
                } else {
                    VStack(spacing: 16) {
                        ForEach(viewModel.funds) { fund in
                            makeSavings(fund: fund) {
                                routes.push(.fundDetails(fund: fund))
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 12)
        .appBackground()
        .navigationTitle("Funds".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder func makeFundSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                ShimmerBox(width: 45, height: 45, cornerRadius: 12)
                VStack(alignment: .leading, spacing: 6) {
                    ShimmerBox(width: 130, height: 16)
                    ShimmerBox(width: 75, height: 12)
                }
                Spacer()
                ShimmerBox(width: 60, height: 22, cornerRadius: 60)
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    ShimmerBox(width: 80, height: 12)
                    ShimmerBox(width: 110, height: 22)
                }
                Spacer()
                ShimmerBox(width: 46, height: 46, cornerRadius: 23)
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeOptionsBlock(text: String, icon: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                icon
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                        startPoint: .trailing,
                        endPoint: .leading
                    ))
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Spacer()
                Text(text)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .frame(width: 180, height: 128, alignment: .leading)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder func makeSavings(fund: Fund, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    FundLogoView(urlString: fund.logoUrl, size: 45)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(fund.name)
                            .font(AppFont.xLargeBold)
                            .foregroundStyle(theme.text.onSurface)
                        Text("\(fund.memberCount) Members")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }

                    Spacer()

                    if fund.role == .admin {
                        Text("ADMIN")
                            .font(AppFont.smallMedium)
                            .foregroundStyle(theme.text.primaryContainer)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(theme.background.inversePrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    } else {
                        Text("MEMBER")
                            .font(AppFont.smallMedium)
                            .foregroundStyle(theme.text.onTertiary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                }

                Divider()

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Fund balance".localized)
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)

                        HStack(spacing: 4) {
                            Text(fund.balanceFormatted)
                                .font(AppFont.heading3)
                                .foregroundStyle(theme.text.onSurface)
                            Text("TJS")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }

                    Spacer()

                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(theme.text.onSurface)
                        .padding(12)
                        .background(theme.background.secondaryContainer)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
