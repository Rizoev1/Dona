//
//  NotificationsScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 15/04/26.
//

import SwiftUI

struct NotificationsScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel = NotificationsViewModel()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                if viewModel.isLoading && viewModel.notifications.isEmpty {
                    notificationSectionSkeleton()
                } else if !viewModel.isLoading && viewModel.notifications.isEmpty {
                    EmptyStateView(
                        icon: Image(systemName: "bell.slash"),
                        title: "No notifications",
                        subtitle: "You're all caught up! New alerts will appear here"
                    )
                } else {
                    if !viewModel.thisMonthNotifications.isEmpty {
                        makeMonthSection(title: "This Month", notifications: viewModel.thisMonthNotifications)
                    }
                    ForEach(viewModel.groupedByMonth, id: \.title) { group in
                        makeMonthSection(title: group.title, notifications: group.notifications)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
        .background(theme.background.surface)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            CustomSheet(height: .fitContent) {
                VStack(spacing: 24) {
                    Image(.notificationMock)
                        .resizable()
                        .frame(width: 190, height: 190)
                    VStack(spacing: 6) {
                        Text(viewModel.selectedNotification?.title ?? "")
                            .font(AppFont.heading2)
                            .foregroundStyle(theme.text.onSurface)
                        Text(viewModel.selectedNotification?.body ?? "")
                            .font(AppFont.largeRegular)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    AppButton(title: "Close", state: .default) {
                        viewModel.isSheetPresented = false
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 24)
                .padding(.bottom, 8)
            }
        }
    }

    @ViewBuilder func notificationSectionSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ShimmerBox(width: 90, height: 16)
            ForEach(0..<4, id: \.self) { _ in
                HStack(spacing: 8) {
                    ShimmerBox(width: 52, height: 52, cornerRadius: 12)
                    VStack(alignment: .leading, spacing: 6) {
                        ShimmerBox(width: 140, height: 13)
                        ShimmerBox(width: 200, height: 11)
                        ShimmerBox(width: 160, height: 11)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeMonthSection(title: String, notifications: [AppNotification]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFont.largeSemibold)
                .foregroundStyle(theme.text.onSurface)

            ForEach(notifications) { notification in
                Button {
                    viewModel.selectNotification(notification)
                } label: {
                    HStack(spacing: 8) {
                        Image(.notificationMock)
                            .resizable()
                            .frame(width: 52, height: 52)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .opacity(notification.isRead ? 0.7 : 1.0)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(notification.title)
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text(notification.body)
                                .font(AppFont.smallRegular)
                                .foregroundStyle(theme.text.onTertiary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        if !notification.isRead {
                            Text("New")
                                .font(AppFont.smallRegular)
                                .foregroundStyle(theme.text.onErrorContainer)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 8)
                                .background(theme.background.errorContainer)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
#Preview {
    NotificationsScreen()
}
