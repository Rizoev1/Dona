//
//  FundAmountSetting.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundAmountSetting: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>

    let fundName: String

    @State private var amount: String = ""
    @State private var apyText: String = ""
    @State private var animatedStep: Int = 1

    private var apy: Double? {
        guard let v = Double(apyText.replacingOccurrences(of: ",", with: ".")), v > 0 else { return nil }
        return v
    }

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)
                .padding(.vertical, 12)

            ScrollView(showsIndicators: false) {
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
                        Text("Fund APY")
                            .font(AppFont.largeSemibold)
                            .foregroundStyle(theme.text.onSurface)

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Annual Percentage Yield")
                                    .font(AppFont.smallRegular)
                                    .foregroundStyle(theme.text.onTertiary)
                                HStack(spacing: 4) {
                                    TextField("0", text: $apyText)
                                        .font(AppFont.mediumMedium)
                                        .foregroundColor(theme.text.onSurface)
                                        .tint(theme.text.onSurface)
                                        .keyboardType(.decimalPad)
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
                            Text("Optional. Leave empty if your community doesn't offer interest on deposits.")
                                .font(AppFont.smallRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(theme.background.inversePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .padding(12)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.bottom, 16)
            }

            AppButton(title: "Continue", state: .default) {
                routes.push(.fundRules(name: fundName, apy: apy))
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Create fund")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) { animatedStep = 2 }
            }
        }
    }
}
