//
//  FundAmountSetting.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI

struct FundAmountSetting: View {
    @Environment(\.theme) var theme
    @State private var amount: String = ""
    @State private var percent: String = ""

    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Contribution")
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Monthly Amount")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)

                        HStack(spacing: 4) {
                            TextField("0", text: $amount)
                                .font(AppFont.mediumMedium)
                                .foregroundColor(theme.text.onSurface)
                                .tint(theme.text.onSurface)
                                .keyboardType(.numberPad)
                                .fixedSize()

                            Text("TJS")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onTertiaryContainer)
                        }
                    }

                    Spacer()

                    Image(.moneys)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.text.onTertiary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The fixed amount each member contributes to the savings pool every month.")
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            .padding(12)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Fund Allocation")
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Current Account")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)

                        HStack(spacing: 4) {
                            TextField("0", text: $percent)
                                .font(AppFont.mediumMedium)
                                .foregroundColor(theme.text.onSurface)
                                .tint(theme.text.onSurface)
                                .keyboardType(.numberPad)
                                .fixedSize()

                            Text("%")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onTertiaryContainer)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                HStack(alignment: .top, spacing: 8) {
                    Image(.infoCircle)
                        .resizable()
                        .frame(width: 18, height: 18)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Allocation: 100%")
                            .font(AppFont.mediumSemibold)
                            .foregroundStyle(theme.text.onSurface)
                        Text("All funds go to Current Account. You can allocate to Depository after creating the community.")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.background.inversePrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(12)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
            
            AppButton(title: "Continue", state: .default, action: {})
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Create fund")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FundAmountSetting()
}
