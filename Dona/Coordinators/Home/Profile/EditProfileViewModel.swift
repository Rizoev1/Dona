//
//  EditProfileViewModel.swift
//  Dona
//

import Foundation
import Combine
import UIKit

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published var editName: String = ""
    @Published var phone: String = ""
    @Published var selectedImage: UIImage?
    @Published var isSaving = false
    @Published var saveSuccess = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func onAppear() {
        APIManager.shared.getProfile()
            .sink { _ in } receiveValue: { [weak self] response in
                let profile = response.payload
                self?.phone = profile.phone
                self?.editName = profile.fullName
            }
            .store(in: &cancellables)
    }

    func save(completion: @escaping () -> Void) {
        let name = editName.trimmingCharacters(in: .whitespaces)
        isSaving = true
        errorMessage = nil
        APIManager.shared.updateProfile(fullName: name.isEmpty ? nil : name, email: nil)
            .sink { [weak self] result in
                self?.isSaving = false
                if case .failure(let error) = result {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.saveSuccess = true
                completion()
            }
            .store(in: &cancellables)
    }
}
