//
//  HomeScreen.swift
//  Dona
//
//  Created by mac on 2026-04-11.
//

import SwiftUI
import FlowStacks

struct HomeScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var navigator: FlowNavigator<HomeRouter>
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                colors: [
                    theme.background.inversePrimary,
                    theme.background.background
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            Image(.homeGradient)
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .offset(y: -40)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Group {
                        if viewModel.isLoadingWallet && viewModel.wallet == nil {
                            balanceCardSkeleton()
                        } else {
                            balanceCardView()
                        }
                    }
                    .padding(.horizontal, 12)

                    if viewModel.isLoadingFunds && viewModel.funds.isEmpty {
                        communityFundSkeleton()
                    } else {
                        makeCommunityFund()
                    }

                    makeQuickPay()

                    Group {
                        if viewModel.isLoadingActivity && viewModel.recentActivity.isEmpty {
                            activitySkeleton()
                        } else {
                            makeRecentActivity()
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
        }
        .onAppear { viewModel.onAppear() }
        .refreshable { viewModel.refresh() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigator.push(.profile)
                } label: {
                    HStack(spacing: 10) {
                        Image(.profileMock)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                        Text(viewModel.displayName)
                            .font(AppFont.xLargeSemibold)
                            .foregroundStyle(theme.text.onSurface)
                            .fixedSize()
                    }
                    .fixedSize()
                    .padding(2)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    navigator.push(.notifications)
                } label: {
                    Image(.notification)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.stroke.scrim)
                }
            }
        }
    }

    @ViewBuilder func balanceCardView() -> some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Available balance")
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        Text(viewModel.balanceFormatted)
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.xxLargeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Personal wallet")
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text(viewModel.cardSuffix)
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
            
            HStack(spacing: 14) {
                VStack(spacing: 6) {
                    Button {
                        navigator.push(.payment(.topUp))
                    } label: {
                        Image(.add)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.foregroundStaticWhite)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 36)
                            .background(LinearGradient(colors:
                                [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                                    startPoint: .trailing,
                                    endPoint: .leading))
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Top up")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
                VStack(spacing: 6) {
                    Button {
                        navigator.push(.fundSelection(.request))
                    } label: {
                        Image(.arrowDown)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.onSurface)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 36)
                            .background(theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Request")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
                VStack(spacing: 6) {
                    Button {
                        navigator.push(.fundSelection(.send))
                    } label: {
                        Image(.arrowRight)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.onSurface)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 36)
                            .background(theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Send")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .cardShadow()
    }
    
    @ViewBuilder func makeCommunityFund() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Community fund")
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                HStack(spacing: 5) {
                    Text("View All")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Image(.arrowRight)
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.funds) { fund in
                        Button {
                            navigator.push(.fundDetails(fund: fund))
                        } label: {
                            CommunityFundCard(fund: fund)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
    
    @ViewBuilder func makeQuickPay() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Quick Pay")
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Button {
                    navigator.push(.services)
                } label: {
                    HStack(spacing: 5) {
                        Text("View All")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        Image(.arrowRight)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(0 ..< 5, id: \.self) { _ in
                        QuickPayCard()
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }
    
    @ViewBuilder func makeRecentActivity() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Button {
                    navigator.push(.activity)
                } label: {
                    HStack(spacing: 5) {
                        Text("View All")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        Image(.arrowRight)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(viewModel.topRecentActivity.enumerated()), id: \.element.id) { index, activity in
                    HStack(spacing: 12) {
                        Image(.amazonMock)
                            .resizable()
                            .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Community name")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text(activity.typeLabel)
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(activity.amountFormatted)
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(activity.isIncoming ? theme.text.foregroundSuccess1 : theme.text.onErrorContainer)
                            Text(activity.shortDate)
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                    if index < viewModel.topRecentActivity.count - 1 {
                        Divider()
                            .padding(.leading, 48)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 26)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .cardShadow()
        }
    }

    // MARK: - Skeletons

    @ViewBuilder func balanceCardSkeleton() -> some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBox(width: 110, height: 13)
                    ShimmerBox(width: 160, height: 30)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    ShimmerBox(width: 90, height: 13)
                    ShimmerBox(width: 65, height: 16)
                }
            }
            HStack(spacing: 14) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: 6) {
                        ShimmerBox(height: 46, cornerRadius: 60)
                        ShimmerBox(width: 42, height: 13)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .cardShadow()
    }

    @ViewBuilder func communityFundSkeleton() -> some View {
        VStack(spacing: 12) {
            HStack {
                ShimmerBox(width: 130, height: 20)
                Spacer()
                ShimmerBox(width: 60, height: 20, cornerRadius: 12)
            }
            .padding(.horizontal, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: 16) {
                            ShimmerBox(width: 32, height: 32, cornerRadius: 8)
                            VStack(alignment: .leading, spacing: 6) {
                                ShimmerBox(width: 80, height: 12)
                                ShimmerBox(width: 100, height: 22)
                            }
                            ShimmerBox(width: 95, height: 12)
                        }
                        .padding()
                        .frame(width: 165, height: 165, alignment: .leading)
                        .background(theme.background.background)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(.horizontal, 12)
            }
        }
    }

    @ViewBuilder func activitySkeleton() -> some View {
        VStack(spacing: 12) {
            HStack {
                ShimmerBox(width: 130, height: 20)
                Spacer()
                ShimmerBox(width: 60, height: 20, cornerRadius: 12)
            }
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    HStack(spacing: 12) {
                        ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                        VStack(alignment: .leading, spacing: 6) {
                            ShimmerBox(width: 110, height: 13)
                            ShimmerBox(width: 75, height: 11)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            ShimmerBox(width: 65, height: 13)
                            ShimmerBox(width: 35, height: 11)
                        }
                    }
                    if index < 2 {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 26)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .cardShadow()
        }
    }
}

#Preview {
    HomeScreen()
}
