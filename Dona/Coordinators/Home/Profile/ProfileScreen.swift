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
    @AppStorage("appLanguage") private var _language: String = "en"

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
                    Text("+\(viewModel.displayPhone)")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onTertiary)
                }
                Button {
                    navigator.push(.editProfile)
                } label: {
                    Text("Edit profile".localized)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 4)
                        .background(theme.background.background)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                }
            }
            makeOptions()
            makeLogoutButton()
            Spacer()
        }
        .padding(.horizontal)
        .background(theme.background.surface)
        .onAppear { viewModel.onAppear() }
    }

    @ViewBuilder func makeOptions() -> some View {
        VStack(alignment: .leading, spacing: 14) {
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
                    Text("Language".localized)
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
                    Text("Theme".localized)
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
                navigator.push(.paymentMethod)
            } label: {
                HStack(spacing: 12) {
                    Image(.card)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("\("Payment method".localized) (\(viewModel.paymentMethods.count))")
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
                    Text("Notifications".localized)
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
                Text("Log out".localized)
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
}

#Preview {
    ProfileScreen()
}
