//
//  ActivityViewModel.swift
//  Dona
//

import Foundation
import Combine
import Moya

@MainActor
final class ActivityViewModel: ObservableObject {
    @Published var transactions: [TransactionListResponse.Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let fundId: Int?

    init(fundId: Int? = nil) {
        self.fundId = fundId
    }

    func onAppear() {
        isLoading = true
        let publisher: AnyPublisher<TransactionListResponse, MoyaError> = fundId.map {
            APIManager.shared.getFundActivity(fundId: $0)
        } ?? APIManager.shared.getWalletActivity()

        publisher
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.transactions = response.payload
            }
            .store(in: &cancellables)
    }

    var groupedByDate: [(title: String, transactions: [TransactionListResponse.Transaction])] {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM.yyyy"

        var groups: [(title: String, transactions: [TransactionListResponse.Transaction])] = []
        var seen: [String: Int] = [:]

        for tx in transactions {
            let title: String
            if let date = iso.date(from: tx.createdAt) {
                title = Calendar.current.isDateInToday(date) ? "Today" : fmt.string(from: date)
            } else {
                title = tx.createdAt
            }

            if let index = seen[title] {
                groups[index].transactions.append(tx)
            } else {
                seen[title] = groups.count
                groups.append((title: title, transactions: [tx]))
            }
        }

        return groups
    }
}
