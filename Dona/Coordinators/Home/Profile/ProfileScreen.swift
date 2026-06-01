//
//  ProfileScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 24/04/26.
//

import SwiftUI
import FlowStacks

struct ProfileScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>
    @StateObject private var viewModel = ProfileViewModel()
    @State private var isEditSheetPresented = false
    @State private var editName: String = ""
    @State private var editEmail: String = ""

    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 10)
            VStack(spacing: 12) {
                Image(.profileMock)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                VStack(spacing: 4) {
                    Text(viewModel.displayName)
                        .font(AppFont.xLargeSemibold)
                        .foregroundStyle(theme.text.onSurface)
                    Text(viewModel.displayEmail)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            makeOptions()
            makeLogoutButton()
            Spacer()
        }
        .padding(.horizontal)
        .background(theme.background.surface)
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $isEditSheetPresented) {
            editSheet()
        }
    }

    @ViewBuilder func makeOptions() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {
                editName = viewModel.profile?.fullName ?? ""
                editEmail = viewModel.profile?.email ?? ""
                viewModel.saveSuccess = false
                viewModel.errorMessage = nil
                isEditSheetPresented = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.stroke.scrim)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Edit Profile")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {
                navigator.push(.language(current: viewModel.currentLanguage))
            } label: {
                HStack(spacing: 12) {
                    Image(.languageCircle)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Language")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {
                navigator.push(.theme)
            } label: {
                HStack(spacing: 12) {
                    Image(.moon)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Theme")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.card)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Payment method (\(viewModel.paymentMethods.count))")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider().padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.notificationFilled)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Notifications")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeLogoutButton() -> some View {
        Button {
            viewModel.logout()
        } label: {
            HStack(spacing: 12) {
                Image(.logout)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(theme.text.onSurface)
                    .padding(8)
                    .background(theme.background.inversePrimary)
                    .clipShape(Circle())
                Text("Log out")
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Image(.right)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(theme.text.onTertiary)
            }
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    @ViewBuilder func editSheet() -> some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(AppFont.heading3)
                .foregroundStyle(theme.text.onSurface)
                .padding(.top, 8)

            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Full name")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    TextField("Your name", text: $editName)
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onSurface)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(theme.background.secondaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    TextField("your@email.com", text: $editEmail)
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.onSurface)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(theme.background.secondaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onErrorContainer)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if viewModel.saveSuccess {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(theme.text.foregroundSuccess1)
                    Text("Profile updated!")
                        .font(AppFont.mediumMedium)
                        .foregroundStyle(theme.text.foregroundSuccess1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(theme.background.backgroundSuccess)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            AppButton(
                title: "Save",
                state: viewModel.isSaving ? .loading : .default
            ) {
                viewModel.updateProfileInfo(fullName: editName, email: editEmail)
            }

            AppButton(title: "Cancel", state: .white) {
                isEditSheetPresented = false
            }
        }
        .padding(.horizontal, 24)
        .adaptivePresentationDetents(height: 420)
    }
}

#Preview {
    ProfileScreen()
}
