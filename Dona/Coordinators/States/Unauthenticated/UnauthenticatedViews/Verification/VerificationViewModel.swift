//
//  VerificationViewModel.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//


import Foundation
import Combine

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
        
    func verifyOtp(code: String, onSuccess: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        apiManager.verifyOtp(phone: phone, code: code)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                KeychainService.shared.saveTokens(
                    access: response.payload.accessToken,
                    refresh: response.payload.refreshToken
                )
                onSuccess()
            }
            .store(in: &cancellables)
    }
    
    func resendOtp(onSuccess: (() -> Void)? = nil) {
        isResending = true
        errorMessage = nil
        
        apiManager.sendOtp(phone: phone)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isResending = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                onSuccess?()
            }
            .store(in: &cancellables)
    }
}
