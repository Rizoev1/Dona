//
//  FundSelectionScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI
import FlowStacks

struct FundSelectionScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var navigator: FlowNavigator<HomeRouter>

    let type: PaymentScreenType

    var navigationTitle: String {
        switch type {
        case .request: return "Select Fund to Request"
        case .send: return "Select Fund to Send"
        default: return "Select Fund"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(0 ..< 4, id: \.self) { _ in
                    Button {
                        navigator.push(.payment(type))
                    } label: {
                        makeFund()
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .navigationTitle(navigationTitle)
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
    FundSelectionScreen(type: .request)
}
