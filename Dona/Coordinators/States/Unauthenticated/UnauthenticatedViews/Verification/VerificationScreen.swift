//
//  VerificationScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import SwiftUI

struct VerificationScreen: View {
    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool
    @State private var code: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 100)
            VStack(alignment: .leading, spacing: 6) {
                Text("Enter the SMS code")
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)
                Text("We sent it to your phone number")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onSecondary)
            }
            makeCodeField()
            Text("Resend code")
                .font(AppFont.mediumMedium)
                .foregroundStyle(theme.text.primaryContainer)
            Spacer()
        }
        .padding(.horizontal)
        .appBackground()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
        .onDisappear {
            isFocused = false
        }
    }

    @ViewBuilder
    func makeCodeField() -> some View {
        ZStack {
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    let digitsOnly = code.filter { $0.isNumber }
                    let character = index < digitsOnly.count
                        ? String(digitsOnly[digitsOnly.index(digitsOnly.startIndex, offsetBy: index)])
                        : ""
                    let isActive = isFocused && (digitsOnly.count == index || (digitsOnly.count == 6 && index == 5))

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(theme.background.secondaryContainer)
                            .frame(width: 54, height: 54)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(theme.stroke.scrim, lineWidth: isActive ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.2), value: isActive)
                            }

                        Text(character)
                            .font(AppFont.heading4)
                            .foregroundStyle(theme.text.onSurface)
                    }
                }
            }

            TextField("", text: Binding(
                get: { code },
                set: { newValue in
                    let digits = newValue.filter { $0.isNumber }
                    code = String(digits.prefix(6))

                    if code.count == 6 {
                        // код введён полностью
                    }
                }
            ))
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .foregroundColor(.clear)
            .accentColor(.clear)
            .focused($isFocused)
            .frame(width: 0, height: 0)
            .opacity(0.01)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }
}


#Preview {
    VerificationScreen()
}
