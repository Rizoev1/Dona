//
//  RequestStatusSheet.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI

struct RequestStatusSheet: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer().frame(height: 60)
            Image(.clock)
                .resizable()
                .frame(width: 120, height: 120)
            makeDescription()
                .padding(.horizontal, 16)
            makeInfo()
                .padding(.horizontal, 12)
            Spacer()
            AppButton(title: "Main page", state: .default, action: { })
                .padding(.horizontal, 12)
        }
        .background(LinearGradient(
            stops: [
                Gradient.Stop(color: Color(hex: "#FCFDE9"), location: 0.00),
                Gradient.Stop(color: Color(hex: "#F6F7F9"), location: 0.32)
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        ))
    }
    
    @ViewBuilder func makeDescription() -> some View {
        VStack(spacing: 8) {
            Text("Transfer Initiated")
                .font(AppFont.heading1)
                .foregroundStyle(theme.text.onSurface)
            Text("Send $200 to the account details provided")
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.onSecondary)
                .multilineTextAlignment(.center)
            Text("We will notify you as soon as your request for funds is approved")
                .font(AppFont.mediumRegular)
                .foregroundStyle(theme.text.onTertiary)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder func makeInfo() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Send to")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("Family Savings")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Wallet")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("Personal Wallet  •• 4092")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Funds requested")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("10290 TJS")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RequestStatusSheet()
}
