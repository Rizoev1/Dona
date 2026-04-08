//
//  Token.swift
//  Dona
//
//  Created by Damir Rizoev on 08/04/26.
//

import SwiftUI

extension Color {
    enum Token {}
}

extension Color.Token {
    /// #FFFFFF
    static let grayscale0   = Color(red: 1.000, green: 1.000, blue: 1.000)
    /// #F6F7F9
    static let grayscale50  = Color(red: 0.964, green: 0.968, blue: 0.976)
    /// #E4E9F1
    static let grayscale100 = Color(red: 0.893, green: 0.913, blue: 0.947)
    /// #DAE1EC
    static let grayscale200 = Color(red: 0.853, green: 0.881, blue: 0.927)
    /// #D4D4D8
    static let grayscale300 = Color(red: 0.831, green: 0.831, blue: 0.847)
    /// #9E9EA7
    static let grayscale400 = Color(red: 0.620, green: 0.620, blue: 0.655)
    /// #6E6E77
    static let grayscale500 = Color(red: 0.431, green: 0.431, blue: 0.467)
    /// #42424B
    static let grayscale600 = Color(red: 0.259, green: 0.259, blue: 0.294)
    /// #242429
    static let grayscale700 = Color(red: 0.141, green: 0.141, blue: 0.159)
    /// #1B1B1E
    static let grayscale800 = Color(red: 0.106, green: 0.106, blue: 0.118)
    /// #0D0D10
    static let grayscale900 = Color(red: 0.051, green: 0.051, blue: 0.063)
}

// MARK: - Brand (Blue)
extension Color.Token {
    /// #F0F8FF
    static let brand50  = Color(red: 0.941, green: 0.973, blue: 1.000)
    /// #C3DDF5
    static let brand100 = Color(red: 0.765, green: 0.867, blue: 0.961)
    /// #C3DDF5
    static let brand200 = Color(red: 0.765, green: 0.867, blue: 0.961)
    /// #C3DDF5
    static let brand300 = Color(red: 0.765, green: 0.867, blue: 0.961)
    /// #4B9BE5
    static let brand400 = Color(red: 0.294, green: 0.608, blue: 0.898)
    /// #2168ED
    static let brand500 = Color(red: 0.129, green: 0.408, blue: 0.929)
    /// #2168ED
    static let brand600 = Color(red: 0.129, green: 0.408, blue: 0.929)
    /// #2168ED
    static let brand700 = Color(red: 0.129, green: 0.408, blue: 0.929)
    /// #2168ED
    static let brand800 = Color(red: 0.129, green: 0.408, blue: 0.929)
    /// #2168ED
    static let brand900 = Color(red: 0.129, green: 0.408, blue: 0.929)
}

// MARK: - Yellow (Warning)
extension Color.Token {
    /// #FEFCE8
    static let yellow50  = Color(red: 0.996, green: 0.988, blue: 0.910)
    /// #FDEDD3
    static let yellow100 = Color(red: 0.992, green: 0.929, blue: 0.827)
    /// #FBDBA7
    static let yellow200 = Color(red: 0.984, green: 0.859, blue: 0.655)
    /// #F9C97C
    static let yellow300 = Color(red: 0.976, green: 0.788, blue: 0.486)
    /// #F7B750
    static let yellow400 = Color(red: 0.969, green: 0.718, blue: 0.314)
    /// #F5A524
    static let yellow500 = Color(red: 0.961, green: 0.647, blue: 0.141)
    /// #C4841D
    static let yellow600 = Color(red: 0.769, green: 0.518, blue: 0.114)
    /// #936316
    static let yellow700 = Color(red: 0.576, green: 0.388, blue: 0.086)
    /// #62420E
    static let yellow800 = Color(red: 0.384, green: 0.259, blue: 0.055)
    /// #312107
    static let yellow900 = Color(red: 0.192, green: 0.129, blue: 0.027)
}

// MARK: - Red (Danger)
extension Color.Token {
    /// #FEE7EF
    static let red50  = Color(red: 0.996, green: 0.906, blue: 0.937)
    /// #FDD0DF
    static let red100 = Color(red: 0.992, green: 0.816, blue: 0.875)
    /// #FAA0BF
    static let red200 = Color(red: 0.980, green: 0.627, blue: 0.749)
    /// #F871A0
    static let red300 = Color(red: 0.973, green: 0.443, blue: 0.627)
    /// #F54180
    static let red400 = Color(red: 0.961, green: 0.255, blue: 0.502)
    /// #F31260
    static let red500 = Color(red: 0.953, green: 0.071, blue: 0.376)
    /// #C20E4D
    static let red600 = Color(red: 0.761, green: 0.055, blue: 0.302)
    /// #920B3A
    static let red700 = Color(red: 0.573, green: 0.043, blue: 0.227)
    /// #610726
    static let red800 = Color(red: 0.380, green: 0.027, blue: 0.149)
    /// #310413
    static let red900 = Color(red: 0.192, green: 0.016, blue: 0.075)
}

// MARK: - Green (Success)
extension Color.Token {
    /// #E8FAF0
    static let green50  = Color(red: 0.910, green: 0.980, blue: 0.941)
    /// #D1F4E0
    static let green100 = Color(red: 0.820, green: 0.957, blue: 0.878)
    /// #A2E9C1
    static let green200 = Color(red: 0.635, green: 0.914, blue: 0.757)
    /// #74DFA2
    static let green300 = Color(red: 0.455, green: 0.875, blue: 0.635)
    /// #45D483
    static let green400 = Color(red: 0.271, green: 0.831, blue: 0.514)
    /// #17C964
    static let green500 = Color(red: 0.090, green: 0.788, blue: 0.392)
    /// #12A150
    static let green600 = Color(red: 0.071, green: 0.631, blue: 0.314)
    /// #0E793C
    static let green700 = Color(red: 0.055, green: 0.475, blue: 0.235)
    /// #095028
    static let green800 = Color(red: 0.035, green: 0.314, blue: 0.157)
    /// #052814
    static let green900 = Color(red: 0.020, green: 0.157, blue: 0.078)
}

// MARK: - Transparent
extension Color.Token {
    /// #D4D4D8 @ 40% — разделители, рамки
    static let transparentGrayscale = Color(red: 0.831, green: 0.831, blue: 0.847).opacity(0.4)
    /// #3F3F46 @ 20% — оверлеи, тени
    static let transparentBlack     = Color(red: 0.247, green: 0.247, blue: 0.275).opacity(0.2)
    /// #2168ED @ 8% — фон активных/выбранных элементов
    static let transparentBrand     = Color(red: 0.129, green: 0.408, blue: 0.929).opacity(0.08)
    /// #17C964 @ 10% — фон статуса success
    static let transparentSuccess   = Color(red: 0.090, green: 0.788, blue: 0.392).opacity(0.1)
    /// #F5A524 @ 10% — фон статуса warning
    static let transparentWarning   = Color(red: 0.961, green: 0.647, blue: 0.141).opacity(0.1)
    /// #F31260 @ 10% — фон статуса danger
    static let transparentDanger    = Color(red: 0.953, green: 0.071, blue: 0.376).opacity(0.1)
}
