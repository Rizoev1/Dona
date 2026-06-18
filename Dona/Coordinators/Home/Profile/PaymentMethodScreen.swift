//
//  PaymentMethodScreen.swift
//  Dona

import SwiftUI
import Combine
import FlowStacks

@MainActor
private final class PaymentMethodViewModel: ObservableObject {
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    func onAppear() {
        guard paymentMethods.isEmpty else { return }
        isLoading = true
        APIManager.shared.listPaymentMethods()
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                self?.paymentMethods = response.payload
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }

    func formattedBalance(_ card: PaymentMethod) -> String {
        let tjs = Double(card.balance) / 100.0
        let formatted = String(format: "%.2f", tjs).replacingOccurrences(of: ".", with: ",")
        return "\(formatted) TJS"
    }
}

struct PaymentMethodScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>
    @StateObject private var viewModel = PaymentMethodViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    shimmerSection
                } else if !viewModel.paymentMethods.isEmpty {
                    cardSection(withBalance: true)
//                    cardSection(withBalance: false)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(theme.background.surface)
        .safeAreaInset(edge: .bottom) {
            addCardButton
        }
        .navigationTitle("Payment method".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder
    private func cardSection(withBalance: Bool) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.paymentMethods.enumerated()), id: \.element.id) { index, card in
                Button {
                    navigator.push(.cardDetail(card))
                } label: {
                    if withBalance {
                        cardRowWithBalance(card)
                    } else {
                        cardRow(card)
                    }
                }
                if index < viewModel.paymentMethods.count - 1 {
                    Divider().padding(.leading, 72)
                }
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func cardRowWithBalance(_ card: PaymentMethod) -> some View {
        HStack(spacing: 12) {
            Image(.cardMock)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            VStack(alignment: .leading, spacing: 2) {
                Text("Корти милли **\(card.cardSuffix)")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Text(viewModel.formattedBalance(card))
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onTertiary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func cardRow(_ card: PaymentMethod) -> some View {
        HStack(spacing: 12) {
            Image(.cardMock)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 32)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            Text("Корти милли **\(card.cardSuffix)")
                .font(AppFont.largeMedium)
                .foregroundStyle(theme.text.onSurface)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    private var shimmerSection: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                HStack(spacing: 12) {
                    ShimmerBox(width: 48, height: 32, cornerRadius: 6)
                    VStack(alignment: .leading, spacing: 6) {
                        ShimmerBox(width: 130, height: 14)
                        ShimmerBox(width: 80, height: 12)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                if index < 2 {
                    Divider().padding(.leading, 72)
                }
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var addCardButton: some View {
        Button {} label: {
            Text("Add card".localized)
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
}

#Preview {
    NavigationView { PaymentMethodScreen() }
}
