//
//  HapticManager.swift
//  Dona
//

import UIKit

enum HapticManager {
    enum Notification { case success, warning, error }
    enum Impact { case light, medium, heavy, soft, rigid }

    static func impact(_ style: Impact = .light) {
        let uiStyle: UIImpactFeedbackGenerator.FeedbackStyle
        switch style {
        case .light:  uiStyle = .light
        case .medium: uiStyle = .medium
        case .heavy:  uiStyle = .heavy
        case .soft:   uiStyle = .soft
        case .rigid:  uiStyle = .rigid
        }
        let gen = UIImpactFeedbackGenerator(style: uiStyle)
        gen.prepare()
        gen.impactOccurred()
    }

    static func notification(_ type: Notification) {
        let uiType: UINotificationFeedbackGenerator.FeedbackType
        switch type {
        case .success: uiType = .success
        case .warning: uiType = .warning
        case .error:   uiType = .error
        }
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(uiType)
    }

    static func selection() {
        let gen = UISelectionFeedbackGenerator()
        gen.prepare()
        gen.selectionChanged()
    }
}
