//
//  AppTheme.swift
//  Dona
//
//  Created by Damir Rizoev on 08/04/26.
//

import SwiftUI

struct AppTheme {

    struct Text {
        let onSurface:             Color
        let onBackground:          Color
        let onSecondary:           Color
        let onTertiary:            Color
        let onTertiaryContainer:   Color
        let primaryContainer:      Color
        let onSecondaryContainer:  Color
        let foregroundStaticWhite: Color
        let foregroundStaticBlack: Color
        let inverseOnSurface:      Color
        let onErrorContainer:      Color
        let foregroundWarning1:    Color
        let foregroundSuccess1:    Color
    }

    struct Background {
        let surface:                  Color
        let background:               Color
        let secondaryContainer:       Color
        let tertiaryContainer:        Color
        let primaryContainer:         Color
        let inversePrimary:           Color
        let inverseSurface:           Color
        let errorContainer:           Color
        let backgroundWarning:        Color
        let backgroundSuccess:        Color
        let backgroundTransparent:    Color
        let backgroundBrandTransparent: Color
    }

    struct Stroke {
        let outline:           Color
        let outlineVariant:    Color
        let scrim:             Color
        let strokeStaticBlack: Color
        let strokeStaticWhite: Color
        let error:             Color
        let strokeWarning:     Color
        let strokeSuccess:     Color
    }

    let text:       Text
    let background: Background
    let stroke:     Stroke
    let colorScheme: ColorScheme
}

extension AppTheme {
    static let light = AppTheme(
        text: Text(
            onSurface:             Color(hex: "#0D0D10"),
            onBackground:          Color(hex: "#242429"),
            onSecondary:           Color(hex: "#42424B"),
            onTertiary:            Color(hex: "#6E6E77"),
            onTertiaryContainer:   Color(hex: "#9E9EA7"),
            primaryContainer:      Color(hex: "#2168ED"),
            onSecondaryContainer:  Color(hex: "#4B9BE5"),
            foregroundStaticWhite: Color(hex: "#FFFFFF"),
            foregroundStaticBlack: Color(hex: "#0D0D10"),
            inverseOnSurface:      Color(hex: "#FFFFFF"),
            onErrorContainer:      Color(hex: "#F31260"),
            foregroundWarning1:    Color(hex: "#F5A524"),
            foregroundSuccess1:    Color(hex: "#17C964")
        ),
        background: Background(
            surface:                   Color(hex: "#F6F7F9"),
            background:                Color(hex: "#FFFFFF"),
            secondaryContainer:        Color(hex: "#F6F7F9"),
            tertiaryContainer:         Color(hex: "#E4E9F1"),
            primaryContainer:          Color(hex: "#2168ED"),
            inversePrimary:            Color(hex: "#F0F8FF"),
            inverseSurface:            Color(hex: "#1B1B1E"),
            errorContainer:            Color(hex: "#F31260").opacity(0.10),
            backgroundWarning:         Color(hex: "#F5A524").opacity(0.10),
            backgroundSuccess:         Color(hex: "#17C964").opacity(0.10),
            backgroundTransparent:     Color(hex: "#3F3F46").opacity(0.20),
            backgroundBrandTransparent: Color(hex: "#2168ED").opacity(0.08)
        ),
        stroke: Stroke(
            outline:           Color(hex: "#E4E9F1"),
            outlineVariant:    Color(hex: "#DAE1EC"),
            scrim:             Color(hex: "#2168ED"),
            strokeStaticBlack: Color(hex: "#1B1B1E"),
            strokeStaticWhite: Color(hex: "#FFFFFF"),
            error:             Color(hex: "#F31260"),
            strokeWarning:     Color(hex: "#F5A524"),
            strokeSuccess:     Color(hex: "#17C964")
        ),
        colorScheme: .light
    )
}

extension AppTheme {
    static let dark = AppTheme(
        text: Text(
            onSurface:             Color(hex: "#FFFFFF"),
            onBackground:          Color(hex: "#F6F7F9"),
            onSecondary:           Color(hex: "#E4E9F1"),
            onTertiary:            Color(hex: "#9E9EA7"),
            onTertiaryContainer:   Color(hex: "#6E6E77"),
            primaryContainer:      Color(hex: "#4B9BE5"),
            onSecondaryContainer:  Color(hex: "#C3DDF5"),
            foregroundStaticWhite: Color(hex: "#FFFFFF"),
            foregroundStaticBlack: Color(hex: "#0D0D10"),
            inverseOnSurface:      Color(hex: "#0D0D10"),
            onErrorContainer:      Color(hex: "#F31260"),
            foregroundWarning1:    Color(hex: "#F5A524"),
            foregroundSuccess1:    Color(hex: "#17C964")
        ),
        background: Background(
            surface:                   Color(hex: "#1B1B1E"),
            background:                Color(hex: "#0D0D10"),
            secondaryContainer:        Color(hex: "#1B1B1E"),
            tertiaryContainer:         Color(hex: "#242429"),
            primaryContainer:          Color(hex: "#4B9BE5"),
            inversePrimary:            Color(hex: "#242429"),
            inverseSurface:            Color(hex: "#F6F7F9"),
            errorContainer:            Color(hex: "#F31260").opacity(0.10),
            backgroundWarning:         Color(hex: "#F5A524").opacity(0.10),
            backgroundSuccess:         Color(hex: "#17C964").opacity(0.10),
            backgroundTransparent:     Color(hex: "#3F3F46").opacity(0.20),
            backgroundBrandTransparent: Color(hex: "#2168ED").opacity(0.08)
        ),
        stroke: Stroke(
            outline:           Color(hex: "#42424B"),
            outlineVariant:    Color(hex: "#242429"),
            scrim:             Color(hex: "#4B9BE5"),
            strokeStaticBlack: Color(hex: "#1B1B1E"),
            strokeStaticWhite: Color(hex: "#FFFFFF"),
            error:             Color(hex: "#F31260"),
            strokeWarning:     Color(hex: "#F5A524"),
            strokeSuccess:     Color(hex: "#17C964")
        ),
        colorScheme: .dark
    )
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = .light
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

struct ThemeProvider<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .environment(\.theme, colorScheme == .dark ? .dark : .light)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
