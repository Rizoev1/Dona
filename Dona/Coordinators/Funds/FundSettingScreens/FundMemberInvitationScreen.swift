//
//  FundMemberInvitationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundMemberInvitationScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @State private var animatedStep: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)
                .padding(.vertical, 12)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Invite Community Members")
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("Search and invite Dona users to join your fund. They will receive a notification.")
                            .font(AppFont.largeRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    makeContact()
                }
                .padding(.bottom, 16)
            }

            VStack(spacing: 6) {
                AppButton(title: "Invite member", state: .default, action: { })
                AppButton(title: "Skip now", state: .white, action: { })
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedStep = 4
                }
            }
        }
    }
    
    @ViewBuilder func makeContact() -> some View {
        HStack(spacing: 12) {
            Text("MK")
                .font(AppFont.largeMedium)
                .foregroundStyle(theme.text.primaryContainer)
                .padding(8)
                .background(theme.background.inversePrimary)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Maftuna Kholova")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Text("+992 98 765 43 21")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            Spacer()
            
            Text("ADMIN")
                .font(AppFont.smallMedium)
                .foregroundStyle(theme.text.primaryContainer)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(theme.background.inversePrimary)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
