//
//  ProfileViewModel.swift
//  Dona
//
//  Created by mac on 2026-05-09.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: ProfileResponse.Profile?
    @Published var paymentMethods: [PaymentMethod] = []

    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var saveSuccess = false

    var displayName: String {
        guard let profile else { return "—" }
        return profile.fullName.isEmpty ? profile.phone : profile.fullName
    }

    var displayPhone: String {
        guard let profile else { return "—" }
        return profile.phone.isEmpty ? "—" : profile.phone
    }

    var displayEmail: String {
        guard let profile else { return "—" }
        return profile.email.isEmpty ? "—" : profile.email
    }

    var currentLanguage: String {
        profile?.language ?? "—"
    }

    private var cancellables = Set<AnyCancellable>()

    func onAppear() {
        loadProfile()
        loadPaymentMethods()
    }

    func logout() {
        if let sessionToken = KeychainService.shared.sessionToken {
            APIManager.shared.logout(sessionToken: sessionToken)
                .sink { _ in } receiveValue: { _ in }
                .store(in: &cancellables)
        }
        KeychainService.shared.clear()
        AuthenticationService.shared.status = .unauthenticated
    }

    func updateProfileInfo(fullName: String, email: String) {
        let newName = fullName.trimmingCharacters(in: .whitespaces)
        let newEmail = email.trimmingCharacters(in: .whitespaces)
        isSaving = true
        errorMessage = nil
        saveSuccess = false
        APIManager.shared.updateProfile(
            fullName: newName.isEmpty ? nil : newName,
            email: newEmail.isEmpty ? nil : newEmail
        )
        .sink { [weak self] completion in
            self?.isSaving = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] _ in
            self?.saveSuccess = true
            self?.loadProfile()
        }
        .store(in: &cancellables)
    }

    func updateLanguage(_ language: String) {
        APIManager.shared.updateProfile(language: language)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.loadProfile()
            }
            .store(in: &cancellables)
    }

    private func loadProfile() {
        isLoading = true
        APIManager.shared.getProfile()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.profile = response.payload
            }
            .store(in: &cancellables)
    }

    private func loadPaymentMethods() {
        APIManager.shared.listPaymentMethods()
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.paymentMethods = response.payload
            }
            .store(in: &cancellables)
    }
}
