//
//  DonaApp.swift
//  Dona
//
//  Created by Damir Rizoev on 08/04/26.
//

import SwiftUI

@main
struct DonaApp: App {
    @AppStorage("themeMode") private var themeMode: String = ThemeMode.system.rawValue

    private var preferredColorScheme: ColorScheme? {
        ThemeMode(rawValue: themeMode)?.colorScheme
    }

    var body: some Scene {
        WindowGroup {
            ThemeProvider {
                AppCoordinator()
            }
            .preferredColorScheme(preferredColorScheme)
        }
    }
}
