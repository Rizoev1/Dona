//
//  PaymentViewModel.swift
//  Dona
//
//  Created by mac on 2026-05-13.
//


import Foundation
import Combine
import Moya

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
            errorMessage = "Select a card to top up".localized
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Enter a valid amount".localized
            return
        }

        isLoading = true
        APIManager.shared.topUpWallet(paymentMethodId: selectedPaymentMethod.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    HapticManager.notification(.error)
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                HapticManager.notification(.success)
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }

    func payService(account: String, amount: String) {
        guard case .services(let serviceId, let subServiceId, _, _, _) = type else { return }
        guard !account.isEmpty else {
            errorMessage = "Enter a phone number".localized
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Enter a valid amount".localized
            return
        }

        isLoading = true
        let fullAccount = "992\(account)"
        APIManager.shared.payService(serviceId: serviceId, subServiceId: subServiceId, account: fullAccount, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    HapticManager.notification(.error)
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                HapticManager.notification(.success)
                self?.saveQuickPaymentThenFinish(subServiceId: subServiceId, account: fullAccount)
            }
            .store(in: &cancellables)
    }

    // Remembers a paid provider/account as a Quick Pay shortcut (skipping duplicates),
    // then signals success. isSuccess dismisses the screen and cancels in-flight requests,
    // so it must not be set before the save completes.
    private func saveQuickPaymentThenFinish(subServiceId: Int, account: String) {
        APIManager.shared.listQuickPayments()
            .flatMap { response -> AnyPublisher<Void, MoyaError> in
                let alreadySaved = response.payload.contains { $0.subServiceId == subServiceId && $0.account == account }
                if alreadySaved {
                    return Just(()).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
                }
                return APIManager.shared.createQuickPayment(subServiceId: subServiceId, account: account)
                    .map { _ in () }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                // The payment itself succeeded — a failed shortcut save must not block success
                self?.isSuccess = true
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func sendToFund(amount: String) {
        guard let selectedFund else {
            errorMessage = "Select a fund".localized
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Enter a valid amount".localized
            return
        }

        isLoading = true
        APIManager.shared.topUpFund(fundId: selectedFund.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    HapticManager.notification(.error)
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                HapticManager.notification(.success)
                self?.isSuccess = true
            }
            .store(in: &cancellables)
    }

    func requestWithdrawal(amount: String) {
        guard let selectedFund else {
            errorMessage = "Select a fund".localized
            return
        }
        guard let amountInt = parseAmount(amount) else {
            errorMessage = "Enter a valid amount".localized
            return
        }

        isLoading = true
        APIManager.shared.createWithdrawal(fundId: selectedFund.id, amount: amountInt)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    HapticManager.notification(.error)
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                HapticManager.notification(.success)
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
                    HapticManager.notification(.error)
                    self?.errorMessage = error.userMessage
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
