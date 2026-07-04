//
//  CommunityFundCard.swift
//  Dona
//
//  Created by Damir Rizoev on 14/04/26.
//

import SwiftUI

struct CommunityFundCard: View {
    @Environment(\.theme) private var theme
    @AppStorage("appLanguage") private var _language: String = "en"
    let fund: Fund

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FundLogoView(urlString: fund.logoUrl, size: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text(fund.name)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onSurface)
                HStack(spacing: 4) {
                    Text(fund.balanceFormatted)
                        .font(AppFont.xxLargeBold)
                        .foregroundStyle(theme.text.onSurface)
                    Text("TJS")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Text(fund.apyFormatted)
                .font(AppFont.smallRegular)
                .foregroundStyle(theme.text.onTertiary)
        }
        .padding()
        .frame(width: 165, height: 165, alignment: .leading)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
