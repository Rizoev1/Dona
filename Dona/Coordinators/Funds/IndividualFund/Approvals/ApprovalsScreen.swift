//
//  ApprovalsScreen.swift
//  Dona
//
//  Created by Damir.Rizoev on 05/05/26.
//

import SwiftUI

struct ApprovalsScreen: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                makeJoinRequestView()
                makeDisbursementView()
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Approvals")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder func makeJoinRequestView() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("MK")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.primaryContainer)
                    .padding(10)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Maftuna Kholova")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Text("JOIN REQUEST")
                        .font(AppFont.smallMedium)
                        .foregroundStyle(theme.text.foregroundSuccess1)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(theme.background.backgroundSuccess)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                Spacer()
                Text("2 hours ago")
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            Divider()
            HStack(spacing: 10) {
                AppButton(title: "Reject", state: .default, action: { })
                AppButton(title: "Approve", state: .default, action: { })
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 8)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder func makeDisbursementView() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("MK")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.primaryContainer)
                    .padding(10)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Maftuna Kholova")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Text("JOIN REQUEST")
                        .font(AppFont.smallMedium)
                        .foregroundStyle(theme.text.foregroundSuccess1)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(theme.background.backgroundSuccess)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
                Spacer()
                Text("2 hours ago")
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Amount")
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Spacer()
                    HStack(spacing: 4) {
                        Text("2 145.00")
                            .font(AppFont.heading4)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Text("Medical emergency — hospital visit for my daughter")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(16)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            HStack(spacing: 10) {
                AppButton(title: "Reject", state: .default, action: { })
                AppButton(title: "Approve", state: .default, action: { })
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
    ApprovalsScreen()
}
