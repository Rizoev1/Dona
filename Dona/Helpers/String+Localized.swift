//
//  String+Localized.swift
//  Dona
//

import Foundation

private final class LocalizationManager {
    static let shared = LocalizationManager()

    private var cache: [String: [String: String]] = [:]

    func string(for key: String) -> String {
        let lang = resolvedLanguage()
        if cache[lang] == nil { load(lang) }
        return cache[lang]?[key] ?? fallback(key: key)
    }

    private func resolvedLanguage() -> String {
        let stored = UserDefaults.standard.string(forKey: "appLanguage") ?? ""
        if ["en", "ru", "tg"].contains(stored) { return stored }
        let system = Locale.current.languageCode ?? "en"
        return ["en", "ru", "tg"].contains(system) ? system : "en"
    }

    private func load(_ lang: String) {
        guard let url = Bundle.main.url(
            forResource: lang,
            withExtension: "strings",
            subdirectory: "Localization"
        ),
        let dict = NSDictionary(contentsOf: url) as? [String: String] else {
            cache[lang] = [:]
            return
        }
        cache[lang] = dict
    }

    // If key not found in current language, try English, then return the key itself
    private func fallback(key: String) -> String {
        if cache["en"] == nil { load("en") }
        return cache["en"]?[key] ?? key
    }

    func invalidateCache() {
        cache.removeAll()
    }
}

extension String {
    var localized: String {
        LocalizationManager.shared.string(for: self)
    }
}

// Call this after the user changes the language so all views re-render with fresh strings
func invalidateLocalizationCache() {
    LocalizationManager.shared.invalidateCache()
}
