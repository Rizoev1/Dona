//
//  CardDetailScreen.swift
//  Dona

import SwiftUI
import FlowStacks

struct CardDetailScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>

    let card: PaymentMethod

    @State private var isCardNumberVisible = false
    @State private var showDeleteSheet = false

    private var formattedBalance: String {
        let tjs = Double(card.balance) / 100.0
        let formatted = String(format: "%.2f", tjs).replacingOccurrences(of: ".", with: ",")
        return formatted
    }

    private var maskedNumber: String {
        isCardNumberVisible
            ? "•••• •••• •••• \(card.cardSuffix)"
            : "•••• •••• •••• \(card.cardSuffix)"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                balanceSection
                cardInfoSection
                actionsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(theme.background.surface)
        .navigationTitle("Корти милли **\(card.cardSuffix)")
        .navigationBarTitleDisplayMode(.inline)
        .halfSheet(isPresented: $showDeleteSheet) {
            deleteSheetContent
        }
    }

    private var deleteSheetContent: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to delete card?".localized)
                .font(AppFont.heading4)
                .foregroundStyle(theme.text.onSurface)
                .multilineTextAlignment(.center)
                .padding(.top, 8)

            AppButton(title: "Delete card".localized, state: .default) {
                showDeleteSheet = false
                navigator.pop()
            }

            Button {
                showDeleteSheet = false
            } label: {
                Text("Cancel".localized)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    private var balanceSection: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Available balance".localized)
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(formattedBalance)
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.xxLargeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                Image(.cardMock)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            HStack(spacing: 14) {
                actionButton(
                    icon: .add,
                    label: "Top up".localized,
                    isPrimary: true
                ) {
                    navigator.push(.payment(.topUp))
                }
                actionButton(
                    icon: .arrowDown,
                    label: "Request".localized,
                    isPrimary: false
                ) {}
                actionButton(
                    icon: .arrowRight,
                    label: "Send".localized,
                    isPrimary: false
                ) {}
            }
        }
        .padding(16)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var cardInfoSection: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Номер карты".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("•••• •••• •••• \(card.cardSuffix)")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
                Spacer()
                Button {
                    isCardNumberVisible.toggle()
                } label: {
                    Image(systemName: isCardNumberVisible ? "eye.slash" : "eye")
                        .font(.system(size: 18))
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)

            Rectangle()
                .fill(theme.stroke.outlineVariant)
                .frame(height: 0.5)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Срок действия".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("••/••")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)

                Rectangle()
                    .fill(theme.stroke.outlineVariant)
                    .frame(width: 0.5)
                    .padding(.vertical, 12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("CVV")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("•••")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var actionsSection: some View {
        VStack(spacing: 0) {
            optionRow(
                icon: .edit,
                iconBg: Color(hex: "#EEF2FF"),
                iconFg: Color(hex: "#4F46E5"),
                title: "Rename card".localized
            ) {
                navigator.push(.renameCard(card))
            }

            Divider().padding(.leading, 52)

            optionRow(
                icon: .clockBlue,
                iconBg: Color(hex: "#EFF6FF"),
                iconFg: Color(hex: "#2563EB"),
                title: "Payment history".localized
            ) {}

            Divider().padding(.leading, 52)

            optionRow(
                icon: .tagCross,
                iconBg: Color(hex: "#FFF1F2"),
                iconFg: Color(hex: "#E11D48"),
                title: "Delete card".localized
            ) {
                showDeleteSheet = true
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder
    private func actionButton(
        icon: ImageResource,
        label: String,
        isPrimary: Bool,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 6) {
            Button(action: action) {
                Image(icon)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(isPrimary ? theme.text.foregroundStaticWhite : theme.text.onSurface)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background {
                        if isPrimary {
                            LinearGradient(
                                colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                                startPoint: .trailing,
                                endPoint: .leading
                            )
                        } else {
                            theme.background.secondaryContainer
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 60))
            }
            Text(label)
                .font(AppFont.smallRegular)
                .foregroundStyle(theme.text.onSurface)
        }
    }

    @ViewBuilder
    private func optionRow(
        icon: ImageResource,
        iconBg: Color,
        iconFg: Color,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(iconFg)
                    .padding(8)
                    .background(iconBg)
                    .clipShape(Circle())
                Text(title)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}
