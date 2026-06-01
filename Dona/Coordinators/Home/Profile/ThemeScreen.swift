//
//  ThemeScreen.swift
//  Dona
//

import SwiftUI

struct ThemeScreen: View {
    @Environment(\.theme) private var theme
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.system.rawValue
    @AppStorage("appLanguage") private var _language: String = "en"

    private func themeImage(for mode: ThemeMode) -> Image {
        switch mode {
        case .system: return Image(.mobileFill)
        case .light:  return Image(.sun)
        case .dark:   return Image(.moon)
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(Array(ThemeMode.allCases.enumerated()), id: \.offset) { index, mode in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            themeMode = mode.rawValue
                        }
                    } label: {
                        HStack(spacing: 12) {
                            themeImage(for: mode)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(theme.stroke.scrim)
                            Text(mode.title)
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Spacer()
                            if themeMode == mode.rawValue {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(theme.stroke.scrim)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    if index < ThemeMode.allCases.count - 1 {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 16)
        }
        .background(theme.background.surface)
        .navigationTitle("Theme".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView { ThemeScreen() }
}
