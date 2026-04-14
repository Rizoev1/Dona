//
//  CommunityFundCard.swift
//  Dona
//
//  Created by Damir Rizoev on 14/04/26.
//

import SwiftUI

struct CommunityFundCard: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.amazonMock)
                .resizable()
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 4) {
                Text("Community name")
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onSurface)
                HStack(spacing: 4) {
                    Text("1 293.19")
                        .font(AppFont.xxLargeBold)
                        .foregroundStyle(theme.text.onSurface)
                    Text("TJS")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onTertiaryContainer)
                }
            }
            Text("Earns 4.2% APY")
                .font(AppFont.smallRegular)
                .foregroundStyle(theme.text.onTertiary)
        }
        .padding()
        .frame(width: 165, height: 165, alignment: .leading)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
