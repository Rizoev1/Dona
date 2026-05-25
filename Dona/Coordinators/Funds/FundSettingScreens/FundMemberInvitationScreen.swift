//
//  FundMemberInvitationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundMemberInvitationScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @StateObject private var viewModel = FundInvitationViewModel()

    let fundId: Int

    @State private var animatedStep: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)
                .padding(.vertical, 12)

            makeSearchBar()
                .padding(.bottom, 12)

            if viewModel.invitedCount > 0 {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(theme.text.foregroundSuccess1)
                    Text("\(viewModel.invitedCount) invitation(s) sent!")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.foregroundSuccess1)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.background.backgroundSuccess)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Group {
                if viewModel.isLoadingContacts {
                    makeSkeletons()
                } else if viewModel.permissionDenied {
                    makePermissionDenied()
                } else if viewModel.filteredContacts.isEmpty {
                    EmptyStateView(
                        icon: "person.2",
                        title: viewModel.searchQuery.isEmpty ? "No contacts" : "No results",
                        subtitle: viewModel.searchQuery.isEmpty
                            ? "No contacts available to invite"
                            : "Try a different name or number"
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(Array(viewModel.filteredContacts.enumerated()), id: \.element.id) { index, contact in
                                makeContactRow(contact, isLast: index == viewModel.filteredContacts.count - 1)
                            }
                        }
                        .background(theme.background.background)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 8)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)

            VStack(spacing: 6) {
                AppButton(
                    title: viewModel.selectedCount > 0 ? "Invite (\(viewModel.selectedCount))" : "Invite",
                    state: viewModel.isLoading ? .loading : (viewModel.selectedCount == 0 ? .disabled : .default)
                ) {
                    viewModel.inviteSelected(fundId: fundId)
                }
                AppButton(title: "Skip now", state: .white) {
                    routes = []
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Create fund")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadContacts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) { animatedStep = 4 }
            }
        }
    }

    @ViewBuilder func makeSearchBar() -> some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(theme.text.onTertiary)
            TextField("Search contacts", text: $viewModel.searchQuery)
                .font(AppFont.mediumRegular)
                .foregroundStyle(theme.text.onSurface)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeContactRow(_ contact: ContactItem, isLast: Bool) -> some View {
        let isSelected = viewModel.selectedIds.contains(contact.id)
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                viewModel.toggleSelection(contact.id)
            }
        } label: {
            HStack(spacing: 12) {
                Text(viewModel.initials(contact.fullName))
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.primaryContainer)
                    .frame(width: 40, height: 40)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(contact.fullName)
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Text(contact.displayPhone)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? theme.text.primaryContainer : theme.text.onTertiaryContainer)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)

        if !isLast {
            Divider().padding(.leading, 68)
        }
    }

    @ViewBuilder func makeSkeletons() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<6, id: \.self) { index in
                HStack(spacing: 12) {
                    ShimmerBox(width: 40, height: 40, cornerRadius: 20)
                    VStack(alignment: .leading, spacing: 6) {
                        ShimmerBox(width: 130, height: 13)
                        ShimmerBox(width: 90, height: 11)
                    }
                    Spacer()
                    ShimmerBox(width: 22, height: 22, cornerRadius: 11)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                if index < 5 { Divider().padding(.leading, 68) }
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makePermissionDenied() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.xmark")
                .font(.system(size: 48))
                .foregroundStyle(theme.text.onTertiaryContainer)
            Text("Contacts access denied")
                .font(AppFont.largeSemibold)
                .foregroundStyle(theme.text.onSurface)
            Text("Allow contacts access in Settings to invite members")
                .font(AppFont.mediumRegular)
                .foregroundStyle(theme.text.onTertiary)
                .multilineTextAlignment(.center)
            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.primaryContainer)
            }
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
    }
}
