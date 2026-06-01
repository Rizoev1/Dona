//
//  ActivityScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 15/04/26.
//

import SwiftUI

struct ActivityScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: ActivityViewModel

    init(fundId: Int? = nil) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(fundId: fundId))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                if viewModel.isLoading && viewModel.transactions.isEmpty {
                    activityGroupSkeleton()
                    activityGroupSkeleton()
                } else if !viewModel.isLoading && viewModel.transactions.isEmpty {
                    EmptyStateView(
                        icon: Image(systemName: "clock.arrow.circlepath"),
                        title: "No transactions yet".localized,
                        subtitle: "Your wallet activity will appear here".localized
                    )
                } else {
                    ForEach(viewModel.groupedByDate, id: \.title) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.title)
                                .font(AppFont.heading3)
                                .foregroundStyle(theme.text.onSurface)
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(group.transactions.enumerated()), id: \.element.id) { index, tx in
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
                                    if index < group.transactions.count - 1 {
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
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .background(theme.background.surface)
        .navigationTitle("Activity".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder func activityGroupSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerBox(width: 80, height: 18)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    HStack(spacing: 12) {
                        ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                        VStack(alignment: .leading, spacing: 6) {
                            ShimmerBox(width: 110, height: 13)
                            ShimmerBox(width: 70, height: 11)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            ShimmerBox(width: 65, height: 13)
                            ShimmerBox(width: 35, height: 11)
                        }
                    }
                    if index < 2 { Divider().padding(.leading, 48) }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 26)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    ActivityScreen()
}
