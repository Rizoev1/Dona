//
//  MembersScreen.swift
//  Dona
//
//  Created by Damir.Rizoev on 05/05/26.
//

import SwiftUI

struct MembersScreen: View {
    @Environment(\.theme) var theme
    @StateObject private var viewModel = MembersViewModel()
    @State private var isInviteSheetPresented = false

    let fundId: Int

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    if viewModel.isLoading && viewModel.members.isEmpty {
                        ForEach(0..<6, id: \.self) { _ in memberSkeleton() }
                    } else if !viewModel.isLoading && viewModel.members.isEmpty {
                        EmptyStateView(
                            icon: Image(.people),
                            title: "No members yet".localized,
                            subtitle: "Invite people to join this community".localized
                        )
                    } else {
                        ForEach(Array(viewModel.members.enumerated()), id: \.element.userId) { index, member in
                            memberRow(member)
                            if index < viewModel.members.count - 1 {
                                Divider().padding(.leading, 58)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
            AppButton(title: "Add Member".localized, state: .default) {
                viewModel.invitePhone = ""
                viewModel.inviteSuccess = false
                viewModel.errorMessage = nil
                isInviteSheetPresented = true
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Members".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear(fundId: fundId) }
        .sheet(isPresented: $isInviteSheetPresented) {
            inviteSheet()
        }
    }

    @ViewBuilder func inviteSheet() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("Invite Member".localized)
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Text("Enter their Dona phone number".localized)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            .padding(.top, 8)

            HStack(spacing: 0) {
                Text("+992 ")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .padding(.leading, 16)
                TextField("00 000 00 00", text: $viewModel.invitePhone)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .keyboardType(.phonePad)
                    .padding(.vertical, 17)
                    .onChange(of: viewModel.invitePhone) { newValue in
                        let digits = newValue.filter { $0.isNumber }
                        viewModel.invitePhone = String(digits.prefix(9))
                    }
            }
            .frame(height: 56)
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onErrorContainer)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if viewModel.inviteSuccess {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(theme.text.foregroundSuccess1)
                    Text("Invitation sent!".localized)
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.foregroundSuccess1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(theme.background.backgroundSuccess)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            AppButton(
                title: "Send Invitation".localized,
                state: viewModel.isInviting ? .loading : .default
            ) {
                viewModel.inviteMember()
            }

            AppButton(title: "Cancel".localized, state: .white) {
                isInviteSheetPresented = false
            }
        }
        .padding(.horizontal, 24)
        .adaptivePresentationDetents(height: 400)
    }

    @ViewBuilder func memberRow(_ member: FundMemberListResponse.FundMember) -> some View {
        HStack(spacing: 12) {
            Text(initials(member.fullName))
                .font(AppFont.largeMedium)
                .foregroundStyle(theme.text.primaryContainer)
                .padding(10)
                .background(theme.background.inversePrimary)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(member.fullName.isEmpty ? member.phone : member.fullName)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Text(member.phone)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            Spacer()

            Text(member.role == .admin ? "ADMIN" : "MEMBER")
                .font(AppFont.smallMedium)
                .foregroundStyle(member.role == .admin
                                 ? theme.text.primaryContainer
                                 : theme.text.onTertiary)
                .padding(.horizontal, 8).padding(.vertical, 4)
                .background(member.role == .admin
                            ? theme.background.inversePrimary
                            : theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 60))
        }
    }

    @ViewBuilder func memberSkeleton() -> some View {
        HStack(spacing: 12) {
            ShimmerBox(width: 44, height: 44, cornerRadius: 22)
            VStack(alignment: .leading, spacing: 6) {
                ShimmerBox(width: 130, height: 14)
                ShimmerBox(width: 100, height: 12)
            }
            Spacer()
            ShimmerBox(width: 55, height: 22, cornerRadius: 60)
        }
    }

    private func initials(_ name: String) -> String {
        name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}

#Preview {
    MembersScreen(fundId: 1)
}
