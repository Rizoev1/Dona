//
//  QuickPayCard.swift
//  Dona
//
//  Created by Damir Rizoev on 14/04/26.
//

import SwiftUI

struct QuickPayCard: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.add)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(8)
                .background(theme.background.secondaryContainer)
                .clipShape(Circle())
            Text("Top up")
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.onSurface)
        }
        .padding()
        .frame(width: 120, height: 100, alignment: .leading)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
