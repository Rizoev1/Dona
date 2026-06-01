//
//  FundsViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class FundsViewModel: ObservableObject {
    @Published var funds: [Fund] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private var hasLoaded = false

    func onAppear() {
        guard !hasLoaded else { return }
        hasLoaded = true
        isLoading = true
        APIManager.shared.listFunds()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.funds = response.payload
            }
            .store(in: &cancellables)
    }
}
