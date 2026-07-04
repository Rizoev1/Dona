//
//  EditProfileViewModel.swift
//  Dona
//

import Foundation
import Combine
import UIKit
import Moya

@MainActor
final class EditProfileViewModel: ObservableObject {
    @Published var editName: String = ""
    @Published var phone: String = ""
    @Published var avatarUrl: String = ""
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
                self?.avatarUrl = profile.avatarUrl
            }
            .store(in: &cancellables)
    }

    func save(completion: @escaping () -> Void) {
        let name = editName.trimmingCharacters(in: .whitespaces)
        isSaving = true
        errorMessage = nil

        // Server writes the uploaded avatar into the profile itself,
        // so the name update just follows the upload
        let uploadStep: AnyPublisher<Void, MoyaError>
        if let image = selectedImage, let data = image.jpegData(compressionQuality: 0.8) {
            uploadStep = APIManager.shared.uploadAvatar(imageData: data)
                .map { _ in () }
                .eraseToAnyPublisher()
        } else {
            uploadStep = Just(())
                .setFailureType(to: MoyaError.self)
                .eraseToAnyPublisher()
        }

        uploadStep
            .flatMap { _ in
                APIManager.shared.updateProfile(fullName: name.isEmpty ? nil : name, email: nil)
            }
            .sink { [weak self] result in
                self?.isSaving = false
                if case .failure(let error) = result {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                self?.saveSuccess = true
                completion()
            }
            .store(in: &cancellables)
    }
}
