//
//  LoginViewModel.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Foundation
import Combine
import Moya

final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    private static func extractMessage(from error: MoyaError) -> String {
        if case .statusCode(let response) = error,
           let decoded = try? JSONDecoder().decode(MessageResponse.self, from: response.data) {
            return decoded.message
        }
        return error.localizedDescription
    }

    func sendOtp(phone: String, onSuccess: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil

        APIManager.shared.sendOtp(phone: phone)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = Self.extractMessage(from: error)
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }
}
