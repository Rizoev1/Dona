//
//  RenameCardScreen.swift
//  Dona

import SwiftUI
import FlowStacks

struct RenameCardScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>

    let card: PaymentMethod

    @State private var cardName: String = ""
    @FocusState private var isFocused: Bool

    init(card: PaymentMethod) {
        self.card = card
        _cardName = State(initialValue: "Корти милли **\(card.cardSuffix)")
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Card name".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                TextField("", text: $cardName)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .focused($isFocused)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
            .padding(.top, 16)

            Spacer()
        }
        .background(theme.background.surface)
        .safeAreaInset(edge: .bottom) {
            Button {
                navigator.pop()
            } label: {
                Text("Save".localized)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.foregroundStaticWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                            startPoint: .trailing,
                            endPoint: .leading
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 40))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .background(theme.background.surface)
        }
        .navigationTitle("Rename card".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { isFocused = true }
    }
}
