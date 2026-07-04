//
//  ActivityViewModel.swift
//  Dona
//

import Foundation
import Combine
import Moya

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let fundId: Int?

    init(fundId: Int? = nil) {
        self.fundId = fundId
    }

    func onAppear() {
        guard !isLoading && transactions.isEmpty else { return }
        load()
    }

    func reload() {
        load()
    }

    private func load() {
        isLoading = true
        let publisher: AnyPublisher<TransactionListResponse, MoyaError> = fundId.map {
            APIManager.shared.getFundActivity(fundId: $0)
        } ?? APIManager.shared.getWalletActivity()

        publisher
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.transactions = response.payload
            }
            .store(in: &cancellables)
    }

    var groupedByDate: [(title: String, date: Date?, transactions: [Transaction])] {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM.yyyy"

        var groups: [(title: String, date: Date?, transactions: [Transaction])] = []
        var seen: [String: Int] = [:]

        for tx in transactions {
            let parsed = Self.parseDate(tx.createdAt)
            let title: String
            if let date = parsed {
                title = Calendar.current.isDateInToday(date) ? "Today" : fmt.string(from: date)
            } else {
                title = tx.createdAt
            }

            if let index = seen[title] {
                groups[index].transactions.append(tx)
            } else {
                seen[title] = groups.count
                groups.append((title: title, date: parsed, transactions: [tx]))
            }
        }

        return groups.sorted { lhs, rhs in
            switch (lhs.date, rhs.date) {
            case let (l?, r?): return l > r
            default: return lhs.date != nil
            }
        }
    }

    private static func parseDate(_ string: String) -> Date? {
        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = withFractional.date(from: string) { return date }
        let standard = ISO8601DateFormatter()
        standard.formatOptions = [.withInternetDateTime]
        return standard.date(from: string)
    }
}
