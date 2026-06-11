//
//  EditProfileScreen.swift
//  Dona
//

import SwiftUI
import FlowStacks

struct EditProfileScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<HomeRouter>
    @StateObject private var viewModel = EditProfileViewModel()

    @State private var showAvatarSheet = false
    @State private var showCamera = false
    @State private var showGallery = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let img = viewModel.selectedImage {
                            Image(uiImage: img)
                                .resizable()
                        } else {
                            Image(.profileMock)
                                .resizable()
                        }
                    }
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())

                    Button { showAvatarSheet = true } label: {
                        Image(.edit)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(theme.text.onSurface)
                            .frame(width: 14, height: 14)
                            .frame(width: 26, height: 26)
                            .background(theme.background.surface)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(theme.background.background, lineWidth: 2))
                    }
                }
                .padding(.bottom, 16)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Name".localized)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    TextField("", text: $viewModel.editName)
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.background.secondaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(20)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onErrorContainer)
            }

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .background(theme.background.surface)
        .navigationTitle("Edit profile".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Button("Save".localized) {
                        viewModel.save { navigator.goBack() }
                    }
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .sheet(isPresented: $showAvatarSheet) {
            avatarSheet()
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraPickerView { image in
                viewModel.selectedImage = image
            }
            .ignoresSafeArea()
        }
        .sheet(isPresented: $showGallery) {
            GalleryPickerView { image in
                viewModel.selectedImage = image
            }
        }
    }

    @ViewBuilder private func avatarSheet() -> some View {
        VStack(spacing: 12) {
            avatarButton(title: "Take a photo".localized, asset: .camera, isPrimary: true) {
                showAvatarSheet = false
                showCamera = true
            }
            avatarButton(title: "Upload from gallery".localized, asset: .gallery, isPrimary: false) {
                showAvatarSheet = false
                showGallery = true
            }
        }
        .padding(.horizontal, 24)
        .adaptivePresentationDetents(height: 172)
    }

    @ViewBuilder private func avatarButton(
        title: String,
        asset: ImageResource,
        isPrimary: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(asset)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(AppFont.largeMedium)
            }
            .foregroundStyle(isPrimary ? theme.text.foregroundStaticWhite : theme.text.onSurface)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                if isPrimary {
                    LinearGradient(
                        colors: [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                } else {
                    theme.background.background
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
        }
    }
}
