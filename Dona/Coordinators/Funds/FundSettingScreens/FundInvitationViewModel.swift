//
//  FundInvitationViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class FundInvitationViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccess = false

    private var cancellables = Set<AnyCancellable>()

    func invite(fundId: Int) {
        let digits = phone.filter { $0.isNumber }
        guard digits.count == 9 else {
            errorMessage = "Enter a valid 9-digit phone number"
            return
        }
        isLoading = true
        errorMessage = nil
        APIManager.shared.inviteFundMember(fundId: fundId, phone: "992\(digits)")
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.isSuccess = true
                self?.phone = ""
            }
            .store(in: &cancellables)
    }
}
