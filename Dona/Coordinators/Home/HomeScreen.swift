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
                    balanceCardView()
                        .padding(.horizontal, 12)
                    makeCommunityFund()
                    makeQuickPay()
                    makeRecentActivity()
                        .padding(.horizontal, 12)
                }
                .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 10) {
                    Image(.profileMock)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    Text("Дамир. Р")
                        .font(AppFont.xLargeSemibold)
                        .foregroundStyle(theme.text.onSurface)
                        .fixedSize()
                }
                .fixedSize()
                .padding(2)
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
                        Text("1 293.19")
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
                    Text("•• 4092")
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
                    ForEach(0 ..< 5, id: \.self) { _ in
                        CommunityFundCard()
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
                ForEach(0 ..< 3, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(.amazonMock)
                            .resizable()
                            .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Community name")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text("Monthly Contribution")
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("- 42.2 TJS")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text("12.01")
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                    if index < 1 {
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
}

#Preview {
    HomeScreen()
}
