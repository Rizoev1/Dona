//
//  SuccessStatusSheet.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI

struct SuccessStatusSheet: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer().frame(height: 60)
            Image(.checkMark)
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
                Gradient.Stop(color: Color(hex: "#E9FDE9"), location: 0.00),
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
            Text("Your wallet will be credited once the transfer is confirmed. This usually takes a few minutes")
                .font(AppFont.mediumRegular)
                .foregroundStyle(theme.text.onTertiary)
                .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder func makeInfo() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Bank")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("Humo Bank")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Account Name")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("Dona Wallet Top-Up")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Account Number")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("2090 4821 0037 5516")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Reference")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("DON-L8GESX")
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
    SuccessStatusSheet()
}
