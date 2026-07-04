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
    @Published var isAdding = false
    @Published var errorMessage: String?

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

    func addCard(number: String, balance: String, onSuccess: @escaping () -> Void) {
        let digits = number.filter { $0.isNumber }
        guard digits.count == 16 else { return }
        let suffix = String(digits.suffix(4))
        let type = digits.hasPrefix("4") ? "visa" : "mastercard"
        let balanceDirams = Double(balance.replacingOccurrences(of: ",", with: ".")).map { Int($0 * 100) }

        isAdding = true
        APIManager.shared.addPaymentMethod(cardSuffix: suffix, cardType: type, balance: balanceDirams)
            .sink { [weak self] completion in
                self?.isAdding = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.paymentMethods.append(response.payload)
                onSuccess()
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
    @AppStorage("appLanguage") private var _language: String = "en"

    @State private var showAddCard = false
    @State private var newCardNumber = ""
    @State private var newCardBalance = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                if viewModel.isLoading {
                    shimmerSection
                } else if viewModel.paymentMethods.isEmpty {
                    EmptyStateView(
                        icon: Image(systemName: "creditcard"),
                        title: "No cards yet".localized,
                        subtitle: "Add a card to see it here".localized
                    )
                    .padding(.top, 32)
                } else {
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
        .navigationTitle("Payment methods".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $showAddCard) {
            addCardSheet
        }
        .alert("Error".localized, isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
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
                Text("\("Korti milli".localized) **\(card.cardSuffix)")
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
            Text("\("Korti milli".localized) **\(card.cardSuffix)")
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

    private var addCardSheet: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(theme.stroke.scrim.opacity(0.3))
                .frame(width: 36, height: 4)
                .padding(.top, 8)

            Text("Add card".localized)
                .font(AppFont.xLargeSemibold)
                .foregroundStyle(theme.text.onSurface)

            VStack(alignment: .leading, spacing: 4) {
                Text("Card number".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                TextField("0000 0000 0000 0000", text: $newCardNumber)
                    .keyboardType(.numberPad)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .onChange(of: newCardNumber) { newValue in
                        let digits = String(newValue.filter { $0.isNumber }.prefix(16))
                        if digits != newValue { newCardNumber = digits }
                    }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 4) {
                Text("Initial balance (optional)".localized)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
                TextField("0.00", text: $newCardBalance)
                    .keyboardType(.decimalPad)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()

            AppButton(
                title: "Add card".localized,
                state: viewModel.isAdding ? .loading : (newCardNumber.count == 16 ? .default : .disabled)
            ) {
                viewModel.addCard(number: newCardNumber, balance: newCardBalance) {
                    showAddCard = false
                    newCardNumber = ""
                    newCardBalance = ""
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .background(theme.background.surface)
        .adaptivePresentationDetents(height: 360)
    }

    private var addCardButton: some View {
        Button { showAddCard = true } label: {
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
