//
//  IndividualFundScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import SwiftUI
import FlowStacks

struct IndividualFundScreen: View {
    @Environment(\.theme) var theme
    @StateObject private var viewModel = IndividualFundViewModel()
    @AppStorage("appLanguage") private var _language: String = "en"

    let fund: Fund
    var onTopUp: () -> Void = {}
    var onRequest: (Fund) -> Void = { _ in }
    var onMembers: (Int) -> Void = { _ in }
    var onApprovals: (Int) -> Void = { _ in }
    var onActivity: (Int) -> Void = { _ in }
    var onReport: (Int) -> Void = { _ in }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                makeTopView()
                makeMembers()

                if fund.role == .admin {
                    Button {
                        onApprovals(fund.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(.signature)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(8)
                                .background(theme.background.inversePrimary)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 4) {
                                    Text("Approvals".localized)
                                        .font(AppFont.largeMedium)
                                        .foregroundStyle(theme.text.onSurface)
                                    if viewModel.pendingWithdrawals > 0 {
                                        PulsingDot(color: theme.text.onErrorContainer)
                                    }
                                }
                                if viewModel.pendingWithdrawals > 0 {
                                    Text("\(viewModel.pendingWithdrawals) request(s) pending")
                                        .font(AppFont.mediumMedium)
                                        .foregroundStyle(theme.text.onErrorContainer)
                                } else {
                                    Text("No pending requests".localized)
                                        .font(AppFont.mediumMedium)
                                        .foregroundStyle(theme.text.onTertiary)
                                }
                            }
                            Spacer()
                            Image(.right)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                        .padding(16)
                        .background(theme.background.background)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }

                makeOptions()
                makeRecentActivity()
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .background(theme.background.surface)
        .navigationTitle(fund.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear(fundId: fund.id) }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { } label: {
                    Image(.search)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
        }
    }

    @ViewBuilder func makeTopView() -> some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(fund.name)
                            .font(AppFont.heading1)
                            .foregroundStyle(theme.text.onSurface)
                        HStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(fund.role == .admin
                                          ? theme.text.foregroundSuccess1
                                          : theme.text.onTertiaryContainer)
                                    .frame(width: 4, height: 4)
                                Text(fund.role == .admin ? "ACTIVE" : "MEMBER")
                                    .font(AppFont.smallMedium)
                                    .foregroundStyle(fund.role == .admin
                                                     ? theme.text.foregroundSuccess1
                                                     : theme.text.onTertiaryContainer)
                            }
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(fund.role == .admin
                                        ? theme.background.backgroundSuccess
                                        : theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 60))

                            if fund.role == .admin {
                                Text("ADMIN")
                                    .font(AppFont.smallMedium)
                                    .foregroundStyle(theme.text.primaryContainer)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(theme.background.inversePrimary)
                                    .clipShape(RoundedRectangle(cornerRadius: 60))
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fund balance".localized)
                            .font(AppFont.mediumRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        HStack(spacing: 4) {
                            Text(fund.balanceFormatted)
                                .font(AppFont.heading2)
                                .foregroundStyle(theme.text.onSurface)
                            Text("TJS")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                }
                .padding(.vertical, 16).padding(.horizontal, 18)
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(.amazonMock)
                    .resizable()
                    .frame(width: 144, height: 144)
                    .offset(x: 15, y: 28)
            }
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Button {
                        onTopUp()
                    } label: {
                        Image(.add)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.foregroundStaticWhite)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 46)
                            .background(LinearGradient(
                                colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                                startPoint: .trailing, endPoint: .leading))
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Top up".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
                VStack(spacing: 6) {
                    Button {
                        onRequest(fund)
                    } label: {
                        Image(.arrowDown)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.onSurface)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 46)
                            .background(theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Request".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
        }
    }

    @ViewBuilder func makeMembers() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text("Members".localized)
                    .font(AppFont.heading3)
                    .foregroundColor(theme.text.onSurface)
                Text("\(fund.memberCount)")
                    .font(AppFont.heading3)
                    .foregroundColor(theme.text.onTertiaryContainer)
                Spacer()
                Button {
                    onMembers(fund.id)
                } label: {
                    HStack(spacing: 5) {
                        Text("View All".localized)
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(viewModel.members, id: \.userId) { member in
                        VStack(spacing: 8) {
                            ZStack(alignment: .bottomTrailing) {
                                Text(initials(member.fullName))
                                    .font(AppFont.largeMedium)
                                    .foregroundStyle(theme.text.primaryContainer)
                                    .padding(10)
                                    .background(theme.background.inversePrimary)
                                    .clipShape(Circle())

                                if member.role == .admin {
                                    Image(.moneyRed)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .offset(x: 2, y: 2)
                                }
                            }
                            Text(shortName(member.fullName))
                                .font(AppFont.smallSemibold)
                                .foregroundStyle(theme.text.onSurface)
                        }
                    }
                }
                .padding()
            }
            .clipped()
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder func makeOptions() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {
                onActivity(fund.id)
            } label: {
                HStack(spacing: 12) {
                    Image(.clockBlue)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("View my history".localized)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {
                onReport(fund.id)
            } label: {
                HStack(spacing: 12) {
                    Image(.chart)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Fund report".localized)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.document)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Community Guidelines".localized)
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onSurface)
                        Text("Read rules and policies".localized)
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeRecentActivity() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Recent Activity".localized)
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
            }
            if viewModel.isLoadingActivity && viewModel.activity.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        HStack(spacing: 12) {
                            ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                            VStack(alignment: .leading, spacing: 6) {
                                ShimmerBox(width: 110, height: 13)
                                ShimmerBox(width: 70, height: 11)
                            }
                            Spacer()
                            ShimmerBox(width: 65, height: 13)
                        }
                        if index < 2 { Divider().padding(.leading, 48) }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 26)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            } else if viewModel.activity.isEmpty {
                EmptyStateView(
                    icon: Image(systemName: "clock.arrow.circlepath"),
                    title: "No activity yet".localized,
                    subtitle: "Fund transactions will appear here".localized
                )
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(viewModel.activity.enumerated()), id: \.element.id) { index, tx in
                        HStack(spacing: 12) {
                            Image(.amazonMock)
                                .resizable()
                                .frame(width: 36, height: 36)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tx.typeLabel)
                                    .font(AppFont.mediumMedium)
                                    .foregroundStyle(theme.text.onSurface)
                                Text(tx.description)
                                    .font(AppFont.mediumRegular)
                                    .foregroundStyle(theme.text.onTertiary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(tx.amountFormatted)
                                    .font(AppFont.mediumMedium)
                                    .foregroundStyle(tx.isIncoming ? theme.text.foregroundSuccess1 : theme.text.onErrorContainer)
                                Text(tx.shortDate)
                                    .font(AppFont.mediumRegular)
                                    .foregroundStyle(theme.text.onTertiary)
                            }
                        }
                        if index < viewModel.activity.count - 1 {
                            Divider().padding(.leading, 48)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 26)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }

    private func initials(_ name: String) -> String {
        let parts = name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }

    private func shortName(_ name: String) -> String {
        let parts = name.split(separator: " ")
        guard let first = parts.first else { return name }
        if parts.count > 1, let last = parts.last?.first {
            return "\(first) \(last)."
        }
        return String(first)
    }
}

struct PulsingDot: View {
    let color: Color
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                ) {
                    scale = 1.4
                }
            }
    }
}
