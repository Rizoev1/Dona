//
//  PaymentViewModel.swift
//  Dona
//
//  Created by mac on 2026-05-13.
//


import Foundation
import Combine

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var wallet: WalletResponse.Wallet?

    @Published var selectedPaymentMethod: PaymentMethod?
    @Published var selectedFund: Fund?

    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?

    var walletBalanceFormatted: String {
        guard let balance = wallet?.balance else { return "0.00 TJS" }
        let tjs = Double(balance) / 100.0
        return String(format: "%.2f TJS", tjs)
    }

    var walletCardSuffix: String {
        wallet.map { "•• \($0.cardSuffix)" } ?? "—"
    }

    var selectedFundBalanceFormatted: String {
        guard let fund = selectedFund else { return "—" }
        return fund.balanceFormatted + " TJS"
    }

    private let type: PaymentScreenType
    private var cancellables = Set<AnyCancellable>()

    init(type: PaymentScreenType) {
        self.type = type
        self.selectedFund = type.preselectedFund
    }

    func onAppear() {
        loadWallet()

        switch type {
        case .topUp:
            loadPaymentMethods()
        default:
            break
        }
    }

    func topUp(amount: String) {
        guard let selectedPaymentMethod else {
            errorMessage = "Выберите карту для пополнения"
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Введите корректную сумму"
            return
        }

        isLoading = true
        APIManager.shared.topUpWallet(paymentMethodId: selectedPaymentMethod.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }

    func send(phone: String, amount: String) {
        guard !phone.isEmpty else {
            errorMessage = "Введите номер телефона"
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Введите корректную сумму"
            return
        }

        isLoading = true
        let fullPhone = "992\(phone)"
        APIManager.shared.sendWallet(phone: fullPhone, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }
    
    func sendToFund(amount: String) {
        guard let selectedFund else {
            errorMessage = "Выберите фонд"
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Введите корректную сумму"
            return
        }

        isLoading = true
        APIManager.shared.topUpFund(fundId: selectedFund.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }

    func requestWithdrawal(amount: String) {
        guard let selectedFund else {
            errorMessage = "Выберите фонд"
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Введите корректную сумму"
            return
        }

        isLoading = true
        APIManager.shared.createWithdrawal(fundId: selectedFund.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }

    private func loadWallet() {
        APIManager.shared.getWallet()
            .sink { _ in } receiveValue: { [weak self] response in
                self?.wallet = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadPaymentMethods() {
        APIManager.shared.listPaymentMethods()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.paymentMethods = response.payload
                self?.selectedPaymentMethod = response.payload.first
            }
            .store(in: &cancellables)
    }

    private func parseAmount(_ string: String) -> Int? {
        guard let tjs = Double(string.replacingOccurrences(of: ",", with: ".")),
              tjs > 0 else { return nil }
        return Int(tjs * 100)
    }
}
