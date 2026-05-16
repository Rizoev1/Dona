//
//  ApprovalsViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class ApprovalsViewModel: ObservableObject {
    @Published var withdrawals: [WithdrawalRequest] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let fundId: Int

    init(fundId: Int) {
        self.fundId = fundId
    }

    func onAppear() {
        isLoading = true
        APIManager.shared.listWithdrawals(fundId: fundId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.withdrawals = response.payload.filter { $0.status == .pending }
            }
            .store(in: &cancellables)
    }

    func approve(_ request: WithdrawalRequest) {
        APIManager.shared.approveWithdrawal(fundId: fundId, requestId: request.id)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.withdrawals.removeAll { $0.id == request.id }
            }
            .store(in: &cancellables)
    }

    func reject(_ request: WithdrawalRequest) {
        APIManager.shared.rejectWithdrawal(fundId: fundId, requestId: request.id)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.withdrawals.removeAll { $0.id == request.id }
            }
            .store(in: &cancellables)
    }
}
