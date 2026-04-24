//
//  ProfileScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 24/04/26.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 40)
            VStack(spacing: 12) {
                Image(.profileMock)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                VStack(spacing: 4) {
                    Text("Damir Rizoev")
                        .font(AppFont.xLargeSemibold)
                        .foregroundStyle(theme.text.onSurface)
                    Text("example@example.com")
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
    }
    
    @ViewBuilder func makeOptions() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {} label: {
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
                }
            }
            Divider()
                .padding(.leading, 48)
            Button {} label: {
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
                }
            }
            Divider()
                .padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.card)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Payment metod")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            Divider()
                .padding(.leading, 48)
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
            AuthenticationService.shared.status = .unauthenticated
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
