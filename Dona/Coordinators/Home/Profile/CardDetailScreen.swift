//
//  CardDetailScreen.swift
//  Dona

import SwiftUI
import Combine
import FlowStacks

@MainActor
private final class CardDetailViewModel: ObservableObject {
    @Published var card: PaymentMethod
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init(card: PaymentMethod) {
        self.card = card
    }

    func onAppear() {
        isLoading = true
        APIManager.shared.listPaymentMethods()
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                guard let self else { return }
                if let fresh = response.payload.first(where: { $0.id == self.card.id }) {
                    self.card = fresh
                }
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}

struct CardDetailScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>

    @StateObject private var viewModel: CardDetailViewModel

    @State private var isCardNumberVisible = false
    @State private var showDeleteSheet = false

    init(card: PaymentMethod) {
        _viewModel = StateObject(wrappedValue: CardDetailViewModel(card: card))
    }

    private var formattedBalance: String {
        let tjs = Double(viewModel.card.balance) / 100.0
        let formatted = String(format: "%.2f", tjs).replacingOccurrences(of: ".", with: ",")
        return formatted
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    shimmerBalanceSection
                    shimmerCardInfoSection
                } else {
                    balanceSection
                    cardInfoSection
                }
                actionsSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .appBackground()
        .navigationTitle("Корти милли **\(viewModel.card.cardSuffix)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
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
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Available balance".localized)
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        Text(formattedBalance)
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.xxLargeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Payment method".localized)
                        .font(AppFont.mediumRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("•••• \(viewModel.card.cardSuffix)")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
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
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .cardShadow()
    }

    private var cardInfoSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Card number".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("•••• •••• •••• \(viewModel.card.cardSuffix)")
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
            .padding(.vertical, 14)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expiry date".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    Text("••/••")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))

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
                .padding(.vertical, 14)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }

    private var actionsSection: some View {
        VStack(spacing: 0) {
            optionRow(
                icon: .editFilled,
                iconBg: theme.background.inversePrimary,
                iconFg: Color(hex: "#2563EB"),
                title: "Rename card".localized
            ) {
                navigator.push(.renameCard(viewModel.card))
            }

            Divider().padding(.leading, 52)

            optionRow(
                icon: .clockBlue,
                iconBg: theme.background.inversePrimary,
                iconFg: Color(hex: "#2563EB"),
                title: "Payment history".localized
            ) {}

            Divider().padding(.leading, 52)

            optionRow(
                icon: .closeCircle,
                iconBg: theme.background.inversePrimary,
                iconFg: Color(hex: "#2563EB"),
                title: "Delete card".localized
            ) {
                showDeleteSheet = true
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var shimmerBalanceSection: some View {
        VStack(spacing: 24) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBox(width: 110, height: 13)
                    ShimmerBox(width: 160, height: 30)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8) {
                    ShimmerBox(width: 90, height: 13)
                    ShimmerBox(width: 65, height: 16)
                }
            }
            HStack(spacing: 14) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: 6) {
                        ShimmerBox(height: 46, cornerRadius: 60)
                        ShimmerBox(width: 42, height: 13)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .cardShadow()
    }

    private var shimmerCardInfoSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBox(width: 80, height: 12)
                    ShimmerBox(width: 150, height: 16)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBox(width: 70, height: 12)
                    ShimmerBox(width: 50, height: 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 8) {
                    ShimmerBox(width: 30, height: 12)
                    ShimmerBox(width: 36, height: 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 32))
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
                    .padding(.horizontal, 36)
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
