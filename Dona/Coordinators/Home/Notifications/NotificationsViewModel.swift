//
//  NotificationsViewModel.swift
//  Dona
//
//  Created by mac on 2026-05-09.
//


import Foundation
import Combine

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var selectedNotification: AppNotification?
    @Published var isSheetPresented = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    var thisMonthNotifications: [AppNotification] {
        let calendar = Calendar.current
        let now = Date()
        return notifications.filter {
            guard let date = Self.parseDate($0.createdAt) else { return false }
            return calendar.isDate(date, equalTo: now, toGranularity: .month)
        }
    }

    var groupedByMonth: [(title: String, notifications: [AppNotification])] {
        let calendar = Calendar.current
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"

        let older = notifications.filter {
            guard let date = Self.parseDate($0.createdAt) else { return false }
            return !calendar.isDate(date, equalTo: now, toGranularity: .month)
        }

        var groups: [(title: String, notifications: [AppNotification])] = []
        var seen: [String: Int] = [:]

        for notification in older {
            guard let date = Self.parseDate(notification.createdAt) else { continue }
            let monthTitle = formatter.string(from: date)
            if let index = seen[monthTitle] {
                groups[index].notifications.append(notification)
            } else {
                seen[monthTitle] = groups.count
                groups.append((title: monthTitle, notifications: [notification]))
            }
        }

        return groups
    }

    func onAppear() {
        loadNotifications()
    }

    func selectNotification(_ notification: AppNotification) {
        selectedNotification = notification
        isSheetPresented = true

        if !notification.isRead {
            markAsRead(notification)
        }
    }

    private func loadNotifications() {
        isLoading = true
        APIManager.shared.listNotifications()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.notifications = response.payload
            }
            .store(in: &cancellables)
    }

    private func markAsRead(_ notification: AppNotification) {
        APIManager.shared.markNotificationRead(id: notification.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                if let index = self.notifications.firstIndex(where: { $0.id == notification.id }) {
                    let old = self.notifications[index]
                    self.notifications[index] = AppNotification(
                        id: old.id,
                        userId: old.userId,
                        title: old.title,
                        body: old.body,
                        isRead: true,
                        createdAt: old.createdAt
                    )
                }
            }
            .store(in: &cancellables)
    }

    private static func parseDate(_ string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return iso.date(from: string)
    }

    private var cancellables = Set<AnyCancellable>()
}
