//
//  QuickPayCard.swift
//  Dona
//
//  Created by Damir Rizoev on 14/04/26.
//

import SwiftUI

struct QuickPayCard: View {
    @Environment(\.theme) private var theme
    @AppStorage("appLanguage") private var _language: String = "en"

    let quickPayment: QuickPayment

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: quickPayment.iconUrl.apiImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.secondaryContainer)
                        .clipShape(Circle())
                default:
                    Image(.add)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.secondaryContainer)
                        .clipShape(Circle())
                }
            }
            Text(quickPayment.label)
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.onSurface)
                .lineLimit(1)
        }
        .padding()
        .frame(width: 120, height: 100, alignment: .leading)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
