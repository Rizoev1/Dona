//
//  MembersViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class MembersViewModel: ObservableObject {
    @Published var members: [FundMemberListResponse.FundMember] = []
    @Published var isLoading = false
    @Published var isInviting = false
    @Published var invitePhone: String = ""
    @Published var inviteSuccess = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var fundId: Int = 0

    func onAppear(fundId: Int) {
        self.fundId = fundId
        isLoading = true
        APIManager.shared.listFundMembers(fundId: fundId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.members = response.payload
            }
            .store(in: &cancellables)
    }

    func inviteMember() {
        let digits = invitePhone.filter { $0.isNumber }
        guard digits.count == 9 else {
            errorMessage = "Enter a valid 9-digit phone number".localized
            return
        }
        isInviting = true
        errorMessage = nil
        APIManager.shared.inviteFundMember(fundId: fundId, phone: "992\(digits)")
            .sink { [weak self] completion in
                self?.isInviting = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                self?.inviteSuccess = true
                self?.invitePhone = ""
            }
            .store(in: &cancellables)
    }
}
