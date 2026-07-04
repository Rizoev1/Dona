//
//  PinViewModel.swift
//  Dona
//

import Foundation
import Combine
import LocalAuthentication
import Moya

enum PinMode {
    case setup(sessionToken: String)
    case enter
}

enum PinScreenState {
    case create
    case confirm
    case enter
}

@MainActor
final class PinViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var biometryType: LABiometryType = .none

    private var cancellables = Set<AnyCancellable>()

    init() {
        let ctx = LAContext()
        var error: NSError?
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            biometryType = ctx.biometryType
        }
    }

    func authenticateWithBiometrics(onSuccess: @escaping () -> Void) {
        let ctx = LAContext()
        var error: NSError?
        guard ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return }
        ctx.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Log in to Dona"
        ) { [weak self] success, _ in
            guard success else { return }
            DispatchQueue.main.async {
                self?.refreshAfterBiometrics(onSuccess: onSuccess)
            }
        }
    }

    private func refreshAfterBiometrics(onSuccess: @escaping () -> Void) {
        guard let refreshToken = KeychainService.shared.refreshToken else {
            errorMessage = "Session expired. Please enter your PIN.".localized
            return
        }
        isLoading = true
        APIManager.shared.refreshTokens(refreshToken: refreshToken)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.errorMessage = "Biometric login failed. Please enter your PIN.".localized
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                KeychainService.shared.saveTokens(
                    access: response.payload.accessToken,
                    refresh: response.payload.refreshToken
                )
                onSuccess()
            }
            .store(in: &cancellables)
    }

    func setup(pin: String, sessionToken: String, onSuccess: @escaping () -> Void) {
        isLoading = true
        APIManager.shared.setPin(sessionToken: sessionToken, pin: pin)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                KeychainService.shared.sessionToken = sessionToken
                KeychainService.shared.saveTokens(
                    access: response.payload.accessToken,
                    refresh: response.payload.refreshToken
                )
                onSuccess()
            }
            .store(in: &cancellables)
    }

    func verify(pin: String, onSuccess: @escaping () -> Void) {
        guard let sessionToken = KeychainService.shared.sessionToken else {
            errorMessage = "Session expired. Please log in again.".localized
            return
        }
        isLoading = true
        APIManager.shared.verifyPin(sessionToken: sessionToken, pin: pin)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                KeychainService.shared.saveTokens(
                    access: response.payload.accessToken,
                    refresh: response.payload.refreshToken
                )
                onSuccess()
            }
            .store(in: &cancellables)
    }
}
