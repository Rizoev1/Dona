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
    private let apiManager = APIManager.shared
        
    func sendOtp(phone: String, onSuccess: @escaping () -> Void) {
        let fullPhone = "992" + phone.filter { $0.isNumber }
        
        isLoading = true
        errorMessage = nil
        
        apiManager.sendOtp(phone: fullPhone)
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
