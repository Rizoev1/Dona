//
//  VerificationViewModel.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Foundation
import Combine
import Moya

final class VerificationViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isResending: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let apiManager = APIManager.shared
    private let phone: String

    init(phone: String) {
        self.phone = phone
    }

    func verifyOtp(code: String, onSuccess: @escaping (String, PinCommand) -> Void) {
        isLoading = true
        errorMessage = nil

        apiManager.verifyOtp(phone: phone, code: code)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = Self.extractMessage(from: error)
                }
            } receiveValue: { response in
                let sessionToken = response.payload.sessionToken
                // For CHECK_PIN the PIN already exists — save now so PinViewModel.verify() can read it.
                // For SET_PIN we save only after setPin succeeds, to avoid showing the PIN screen
                // on relaunch before the user has actually set their PIN.
                if response.payload.command == .checkPin {
                    KeychainService.shared.sessionToken = sessionToken
                }
                onSuccess(sessionToken, response.payload.command)
            }
            .store(in: &cancellables)
    }

    private static func extractMessage(from error: MoyaError) -> String {
        if case .statusCode(let response) = error,
           let decoded = try? JSONDecoder().decode(MessageResponse.self, from: response.data) {
            return decoded.message
        }
        return error.userMessage
    }

    func resendOtp(onSuccess: (() -> Void)? = nil) {
        isResending = true
        errorMessage = nil

        apiManager.sendOtp(phone: phone)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isResending = false
                if case .failure(let error) = completion {
                    self.errorMessage = Self.extractMessage(from: error)
                }
            } receiveValue: { _ in
                onSuccess?()
            }
            .store(in: &cancellables)
    }
}
