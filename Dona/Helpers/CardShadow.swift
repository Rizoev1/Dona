//
//  CardShadow.swift
//  Dona
//
//  Created by Damir Rizoev on 14/04/26.
//

import SwiftUI

struct CardShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color(hex: "#A3A3A3").opacity(0.15), radius: 11, x: 0, y: 5)
            .shadow(color: Color(hex: "#A3A3A3").opacity(0.13), radius: 19, x: 0, y: 19)
            .shadow(color: Color(hex: "#A3A3A3").opacity(0.08), radius: 26, x: 0, y: 43)
            .shadow(color: Color(hex: "#A3A3A3").opacity(0.02), radius: 31, x: 0, y: 77)
            .shadow(color: Color(hex: "#A3A3A3").opacity(0.00), radius: 34, x: 0, y: 121)
    }
}

extension View {
    func cardShadow() -> some View {
        self.modifier(CardShadow())
    }
}
