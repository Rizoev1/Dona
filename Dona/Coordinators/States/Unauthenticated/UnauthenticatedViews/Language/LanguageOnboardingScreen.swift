//
//  LanguageOnboardingScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 08/04/26.
//

import SwiftUI
import FlowStacks

struct LanguageOnboardingScreen: View {
    @EnvironmentObject var navigator: FlowNavigator<UnauthenticatedRouter>
    @Environment(\.theme) private var theme
    @State private var selectedLanguage: Language? = .tajik

    enum Language: CaseIterable {
        case tajik, russian, english

        var flag: ImageResource {
            switch self {
            case .tajik:   .tajikistan
            case .russian: .russia
            case .english: .unitedStates
            }
        }

        var title: String {
            switch self {
            case .tajik:   "Тоҷикӣ"
            case .russian: "Русский"
            case .english: "English"
            }
        }
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(.languageIcon)
                .resizable()
                .frame(width: 280, height: 280)

            VStack(alignment: .center, spacing: 6) {
                Text("Choose a language")
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)

                Text("You can change it later in settings")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }

            VStack(alignment: .center, spacing: 8) {
                ForEach(Language.allCases, id: \.self) { language in
                    makeLanguageRow(language)
                }
            }
            Spacer()
            AppButton(title: "Continue", state: .default) {
                navigator.push(.login)
            }
        }
        .padding(.horizontal)
        .appBackground()
    }

    @ViewBuilder
    func makeLanguageRow(_ language: Language) -> some View {
        let isSelected = selectedLanguage == language

        HStack(spacing: 12) {
            Image(language.flag)
                .resizable()
                .frame(width: 32, height: 32)
            Text(language.title)
                .font(AppFont.xLargeMedium)
                .foregroundStyle(theme.text.onSurface)
            Spacer()
        }
        .padding(16)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(theme.stroke.scrim, lineWidth: isSelected ? 1 : 0)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(theme.stroke.scrim, lineWidth: isSelected ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedLanguage = language
            }
        }
    }
}

#Preview {
    LanguageOnboardingScreen()
}
