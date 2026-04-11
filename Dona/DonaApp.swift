//
//  DonaApp.swift
//  Dona
//
//  Created by Damir Rizoev on 08/04/26.
//

import SwiftUI

@main
struct DonaApp: App {
    var body: some Scene {
        WindowGroup {
            ThemeProvider {
                AppCoordinator()
            }
        }
    }
}
