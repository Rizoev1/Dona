//
//  HomeViewModel.swift
//  Dona
//
//  Created by mac on 2026-05-09.
//


import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var profile: ProfileResponse.Profile?
    @Published var wallet: WalletResponse.Wallet?
    @Published var funds: [Fund] = []
    @Published var recentActivity: [TransactionListResponse.Transaction] = []

    @Published var isLoadingWallet = false
    @Published var isLoadingFunds = false
    @Published var isLoadingActivity = false

    @Published var errorMessage: String?
    
    var balanceFormatted: String {
        guard let balance = wallet?.balance else { return "—" }
        let tjs = Double(balance) / 100.0
        return String(format: "%.2f", tjs)
    }
    
    var displayName: String {
        guard let profile = profile else { return "—" }
        return profile.fullName.isEmpty ? profile.phone : profile.fullName
    }

    var cardSuffix: String {
        wallet.map { "•• \($0.cardSuffix)" } ?? "—"
    }

    var topRecentActivity: [TransactionListResponse.Transaction] {
        Array(recentActivity.prefix(3))
    }

    private var cancellables = Set<AnyCancellable>()

    func onAppear() {
        loadAll()
    }

    func refresh() {
        loadAll()
    }

    private func loadAll() {
        loadProfile()
        loadWallet()
        loadFunds()
        loadActivity()
    }

    private func loadProfile() {
        APIManager.shared.getProfile()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.profile = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadWallet() {
        isLoadingWallet = true
        APIManager.shared.getWallet()
            .sink { [weak self] completion in
                self?.isLoadingWallet = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.wallet = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadFunds() {
        isLoadingFunds = true
        APIManager.shared.listFunds()
            .sink { [weak self] completion in
                self?.isLoadingFunds = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.funds = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadActivity() {
        isLoadingActivity = true
        APIManager.shared.getWalletActivity()
            .sink { [weak self] completion in
                self?.isLoadingActivity = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.recentActivity = response.payload
            }
            .store(in: &cancellables)
    }
}

extension TransactionListResponse.Transaction: Identifiable {

    var isIncoming: Bool {
        type == .topup || type == .disbursement
    }

    var amountFormatted: String {
        let tjs = Double(amount) / 100.0
        let sign = isIncoming ? "+" : "-"
        return String(format: "%@ %.1f TJS", sign, tjs)
    }

    var typeLabel: String {
        switch type {
        case .topup:        return "Top up"
        case .send:         return "Sent"
        case .contribution: return "Monthly Contribution"
        case .disbursement: return "Received"
        }
    }

    var shortDate: String {
        let date = parseISO(createdAt)
        guard let date else { return createdAt }
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM"
        return fmt.string(from: date)
    }

    private func parseISO(_ string: String) -> Date? {
        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFractional.date(from: string) { return date }
        let standard = ISO8601DateFormatter()
        standard.formatOptions = [.withInternetDateTime]
        return standard.date(from: string)
    }
}

extension Fund: Identifiable {
    var balanceFormatted: String {
        let tjs = Double(balance) / 100.0
        return String(format: "%.2f", tjs)
    }

    var apyFormatted: String {
        String(format: "Earns %.1f%% APY", apy)
    }
}
