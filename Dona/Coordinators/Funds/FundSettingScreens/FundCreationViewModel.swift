//
//  FundCreationViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class FundCreationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func createFund(name: String, apy: Double?, onSuccess: @escaping (Int) -> Void) {
        isLoading = true
        APIManager.shared.createFund(name: name, apy: apy)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                onSuccess(response.payload.id)
            }
            .store(in: &cancellables)
    }
}
