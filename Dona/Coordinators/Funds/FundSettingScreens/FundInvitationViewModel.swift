//
//  FundInvitationViewModel.swift
//  Dona
//

import Foundation
import Combine
import Contacts

struct ContactItem: Identifiable {
    let id: String
    let fullName: String
    let phone: String         // API format: 992XXXXXXXXX
    let displayPhone: String
}

@MainActor
final class FundInvitationViewModel: ObservableObject {
    @Published var contacts: [ContactItem] = []
    @Published var selectedIds: Set<String> = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var isLoadingContacts = false
    @Published var permissionDenied = false
    @Published var invitedCount: Int = 0

    var filteredContacts: [ContactItem] {
        guard !searchQuery.isEmpty else { return contacts }
        let q = searchQuery.lowercased()
        return contacts.filter {
            $0.fullName.lowercased().contains(q) || $0.displayPhone.contains(q)
        }
    }

    var selectedCount: Int { selectedIds.count }

    private var cancellables = Set<AnyCancellable>()

    func loadContacts() {
        isLoadingContacts = true
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, _ in
            guard granted else {
                DispatchQueue.main.async {
                    self?.isLoadingContacts = false
                    self?.permissionDenied = true
                }
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                var items: [ContactItem] = []
                let keysToFetch = [
                    CNContactGivenNameKey,
                    CNContactFamilyNameKey,
                    CNContactPhoneNumbersKey,
                    CNContactIdentifierKey
                ] as [CNKeyDescriptor]
                let request = CNContactFetchRequest(keysToFetch: keysToFetch)
                request.sortOrder = .givenName
                try? store.enumerateContacts(with: request) { contact, _ in
                    guard let phoneNumber = contact.phoneNumbers.first?.value else { return }
                    let digits = phoneNumber.stringValue.filter { $0.isNumber }
                    let normalized: String
                    if digits.hasPrefix("992") && digits.count == 12 {
                        normalized = digits
                    } else if digits.count == 9 {
                        normalized = "992\(digits)"
                    } else {
                        return
                    }
                    let name = [contact.givenName, contact.familyName]
                        .filter { !$0.isEmpty }
                        .joined(separator: " ")
                    guard !name.isEmpty else { return }
                    items.append(ContactItem(
                        id: contact.identifier,
                        fullName: name,
                        phone: normalized,
                        displayPhone: phoneNumber.stringValue
                    ))
                }
                DispatchQueue.main.async {
                    self?.contacts = items
                    self?.isLoadingContacts = false
                }
            }
        }
    }

    func toggleSelection(_ id: String) {
        if selectedIds.contains(id) {
            selectedIds.remove(id)
        } else {
            selectedIds.insert(id)
        }
    }

    func inviteSelected(fundId: Int) {
        let toInvite = contacts.filter { selectedIds.contains($0.id) }
        guard !toInvite.isEmpty else { return }
        isLoading = true

        let publishers = toInvite.map { contact in
            APIManager.shared.inviteFundMember(fundId: fundId, phone: contact.phone)
                .map { _ in 1 }
                .catch { _ in Just(0) }
                .eraseToAnyPublisher()
        }

        Publishers.MergeMany(publishers)
            .collect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.isLoading = false
                self?.invitedCount += results.reduce(0, +)
                self?.selectedIds = []
            }
            .store(in: &cancellables)
    }

    func initials(_ name: String) -> String {
        name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}
