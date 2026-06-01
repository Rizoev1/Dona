//
//  LanguageScreen.swift
//  Dona
//

import SwiftUI
import Combine

@MainActor
private final class LanguageViewModel: ObservableObject {
    @Published var selected: String

    private var cancellables = Set<AnyCancellable>()

    init(current: String) {
        selected = current
    }

    func select(_ code: String) {
        selected = code
        APIManager.shared.updateProfile(language: code)
            .sink { _ in } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}

struct LanguageScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: LanguageViewModel

    private let languages: [(title: String, flag: ImageResource, code: String)] = [
        ("Тоҷикӣ",  .tajikistan,  "tg"),
        ("Русский",  .russia,      "ru"),
        ("English",  .unitedStates, "en"),
    ]

    init(current: String) {
        _viewModel = StateObject(wrappedValue: LanguageViewModel(current: current))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(languages.enumerated()), id: \.offset) { index, lang in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.select(lang.code)
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(lang.flag)
                                .resizable()
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                            Text(lang.title)
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Spacer()
                            if viewModel.selected == lang.code {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(theme.stroke.scrim)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    if index < languages.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
        }
        .background(theme.background.surface)
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView { LanguageScreen(current: "en") }
}
