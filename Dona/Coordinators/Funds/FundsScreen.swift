//
//  FundsScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 28/04/26.
//

import SwiftUI

enum UserStatus {
    case member
    case admin
}

struct FundsScreen: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                HStack(spacing: 16) {
                    makeOptionsBlock(text: "Create Community", icon: Image(.add))
                    makeOptionsBlock(text: "Migrate Existing Community", icon: Image(.refresh))
                }
                VStack(spacing: 16) {
                    makeSavings(status: .admin)
                    makeSavings(status: .member)
                    makeSavings(status: .admin)
                    makeSavings(status: .member)
                }
            }
        }
        .padding(.horizontal, 12)
        .appBackground()
        .navigationTitle("Funds")
        .navigationBarTitleDisplayMode(.large)
    }
    
    @ViewBuilder func makeOptionsBlock(text: String, icon: Image) -> some View {
        VStack(alignment: .leading) {
            icon
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle( LinearGradient(
                    colors: [
                        Color(hex: "#2A8AE4"),
                        Color(hex: "#3A49F9")
                    ],
                    startPoint: .trailing,
                    endPoint: .leading
                ))
                .padding(8)
                .background(theme.background.inversePrimary)
                .clipShape(Circle())
            Spacer()
            Text(text)
                .font(AppFont.largeSemibold)
                .foregroundStyle(theme.text.onSurface)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(width: 180, height: 128, alignment: .leading)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder func makeSavings(status: UserStatus) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(.amazonMock)
                    .resizable()
                    .frame(width: 45, height: 45)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Family Savings")
                        .font(AppFont.xLargeBold)
                        .foregroundStyle(theme.text.onSurface)
                    Text("4 Members")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                }
                
                Spacer()
                
                if status == .admin {
                    Text("ADMIN")
                        .font(AppFont.smallMedium)
                        .foregroundStyle(theme.text.primaryContainer)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(theme.background.inversePrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                } else {
                    Text("MEMBER")
                        .font(AppFont.smallMedium)
                        .foregroundStyle(theme.text.onTertiary)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(theme.background.secondaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 60))
                }
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Fund balance")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        Text("1 293.19")
                            .font(AppFont.heading3)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                Image(.arrowRight)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(theme.text.onSurface)
                    .padding(12)
                    .background(theme.background.secondaryContainer)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    FundsScreen()
}
