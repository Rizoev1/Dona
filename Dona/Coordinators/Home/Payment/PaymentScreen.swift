//
//  PaymentScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI

struct PaymentScreen: View {
    @Environment(\.theme) private var theme
    @State private var amount: String = ""
    @State private var isOverviewSheetPresented: Bool = false
    var navigationTitle: String = "Payment"
    
    var body: some View {
        VStack(spacing: 54) {
            makeTopCard()
            makeAmountField()
            Spacer()
            VStack(spacing: 16) {
                makeTopCard()
                AppButton(title: "Top up", state: .default) {
                    isOverviewSheetPresented = true
                }
            }
        }
        .padding(.horizontal)
        .background(theme.background.surface)
        .navigationTitle(navigationTitle)
        .sheet(isPresented: $isOverviewSheetPresented) {
            CustomSheet(height: .fitContent) {
                makeOverivewSheet()
            }
        }
    }
    
    @ViewBuilder func makeTopCard() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("Send to")
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
                VStack {
                    Divider()
                }
            }
            HStack(spacing: 12) {
                Image(.wallet)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(9)
                    .background(theme.background.tertiaryContainer)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Personal Wallet")
                        .font(AppFont.largeSemibold)
                        .foregroundStyle(theme.text.onSurface)
                    Text(" •• 4092")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                }
                Spacer()
                Text("2 145.00 TJS")
                    .font(AppFont.smallSemibold)
                    .foregroundStyle(theme.text.onSecondary)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(theme.background.secondaryContainer)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder func makeAmountField() -> some View {
        HStack(spacing: 6) {
            TextField("0", text: $amount)
                .keyboardType(.decimalPad)
                .font(AppFont.heading3)
                .foregroundStyle(theme.text.onSurface)
                .multilineTextAlignment(.center)
                .fixedSize()

            Text("TJS")
                .font(AppFont.xxLargeMedium)
                .foregroundStyle(theme.text.onTertiaryContainer)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
    }
    
    @ViewBuilder func makeOverivewSheet() -> some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text("200")
                        .font(AppFont.heading1)
                        .foregroundStyle(theme.text.onSurface)
                    Text("TJS")
                        .font(AppFont.xxLargeMedium)
                        .foregroundStyle(theme.text.onTertiaryContainer)
                }
                HStack(spacing: 8) {
                    Text("Fee")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("0 TJS")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
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
            
            AppButton(title: "Top up", state: .default, action: { })
        }
        .padding()
    }
}

#Preview {
    PaymentScreen()
}
