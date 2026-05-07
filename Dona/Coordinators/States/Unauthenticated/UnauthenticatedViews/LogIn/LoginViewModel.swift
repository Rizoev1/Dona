//
//  LoginViewModel.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func sendOtp(phone: String, onSuccess: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil
        
        APIManager.shared.sendOtp(phone: phone)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                onSuccess()
            }
            .store(in: &cancellables)
    }
}
