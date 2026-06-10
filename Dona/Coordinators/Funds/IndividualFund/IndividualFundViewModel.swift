//
//  IndividualFundViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class IndividualFundViewModel: ObservableObject {
    @Published var activity: [Transaction] = []
    @Published var members: [FundMemberListResponse.FundMember] = []
    @Published var pendingWithdrawals: Int = 0
    @Published var isLoadingActivity = false

    private var cancellables = Set<AnyCancellable>()

    func onAppear(fundId: Int) {
        loadActivity(fundId: fundId)
        loadMembers(fundId: fundId)
        loadWithdrawals(fundId: fundId)
    }

    private func loadActivity(fundId: Int) {
        isLoadingActivity = true
        APIManager.shared.getFundActivity(fundId: fundId)
            .sink { [weak self] _ in self?.isLoadingActivity = false }
            receiveValue: { [weak self] response in
                self?.activity = Array(response.payload.prefix(3))
            }
            .store(in: &cancellables)
    }

    private func loadMembers(fundId: Int) {
        APIManager.shared.listFundMembers(fundId: fundId)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.members = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadWithdrawals(fundId: Int) {
        APIManager.shared.listWithdrawals(fundId: fundId)
            .sink { _ in } receiveValue: { [weak self] response in
                self?.pendingWithdrawals = response.payload.filter { $0.status == .pending }.count
            }
            .store(in: &cancellables)
    }
}
