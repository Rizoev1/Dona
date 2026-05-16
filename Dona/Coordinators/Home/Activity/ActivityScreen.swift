//
//  ActivityScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 15/04/26.
//

import SwiftUI
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

struct ActivityScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: ActivityViewModel

    init(fundId: Int? = nil) {
        _viewModel = StateObject(wrappedValue: ActivityViewModel(fundId: fundId))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                if viewModel.isLoading && viewModel.transactions.isEmpty {
                    activityGroupSkeleton()
                    activityGroupSkeleton()
                } else if !viewModel.isLoading && viewModel.transactions.isEmpty {
                    EmptyStateView(
                        icon: "clock.arrow.circlepath",
                        title: "No transactions yet",
                        subtitle: "Your wallet activity will appear here"
                    )
                } else {
                    ForEach(viewModel.groupedByDate, id: \.title) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.title)
                                .font(AppFont.heading3)
                                .foregroundStyle(theme.text.onSurface)
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(group.transactions.enumerated()), id: \.element.id) { index, tx in
                                    HStack(spacing: 12) {
                                        Image(.amazonMock)
                                            .resizable()
                                            .frame(width: 36, height: 36)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(tx.typeLabel)
                                                .font(AppFont.mediumMedium)
                                                .foregroundStyle(theme.text.onSurface)
                                            Text(tx.description)
                                                .font(AppFont.mediumRegular)
                                                .foregroundStyle(theme.text.onTertiary)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text(tx.amountFormatted)
                                                .font(AppFont.mediumMedium)
                                                .foregroundStyle(theme.text.onSurface)
                                            Text(tx.shortDate)
                                                .font(AppFont.mediumRegular)
                                                .foregroundStyle(theme.text.onTertiary)
                                        }
                                    }
                                    if index < group.transactions.count - 1 {
                                        Divider().padding(.leading, 48)
                                    }
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 26)
                            .background(theme.background.background)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .background(theme.background.surface)
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder func activityGroupSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmerBox(width: 80, height: 18)
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    HStack(spacing: 12) {
                        ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                        VStack(alignment: .leading, spacing: 6) {
                            ShimmerBox(width: 110, height: 13)
                            ShimmerBox(width: 70, height: 11)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            ShimmerBox(width: 65, height: 13)
                            ShimmerBox(width: 35, height: 11)
                        }
                    }
                    if index < 2 { Divider().padding(.leading, 48) }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 26)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    ActivityScreen()
}
