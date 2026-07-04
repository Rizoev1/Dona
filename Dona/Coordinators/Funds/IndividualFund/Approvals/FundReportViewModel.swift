//
//  FundReportViewModel.swift
//  Dona
//

import Foundation
import Combine

@MainActor
final class FundReportViewModel: ObservableObject {
    @Published var report: ReportResponse.Report?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func onAppear(fundId: Int) {
        isLoading = true
        APIManager.shared.getFundReport(fundId: fundId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.report = response.payload
            }
            .store(in: &cancellables)
    }
}
