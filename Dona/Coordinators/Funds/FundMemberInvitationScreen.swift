//
//  FundMemberInvitationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI

struct FundMemberInvitationScreen: View {
    @Environment(\.theme) var theme

    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Invite Community Members")
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)
                Text("Search and invite Dona users to join your fund. They will receive a notification.")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
    }
    
    @ViewBuilder func makeContact() -> some View {
        HStack(spacing: 12) {
            Text("MK")
                .font(AppFont.largeMedium)
        }
    }
}

#Preview {
    FundMemberInvitationScreen()
}
