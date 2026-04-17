//
//  FundSelectionScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI

struct FundSelectionScreen: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(0 ..< 4) { _ in
                    makeFund()
                }
            }
        }
        .navigationTitle("Select Fund to Send")
        .navigationBarTitleDisplayMode(.large)
        .background(theme.background.surface)
    }
    
    @ViewBuilder func makeFund() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
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
                    .padding()
                    .background(theme.background.secondaryContainer)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}

#Preview {
    FundSelectionScreen()
}
