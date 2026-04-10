//
//  LogInScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import SwiftUI

struct LogInScreen: View {
    @Environment(\.theme) private var theme
    @State private var phoneNumber: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer().frame(height: 100)
            HStack(spacing: 12) {
                Image(.appLogo)
                    .resizable()
                    .frame(width: 28, height: 28)
                Text("Logo")
                    .font(AppFont.heading4)
                    .foregroundStyle(theme.text.onSurface)
            }
            VStack(spacing: 6) {
                Text("Login or Sign up")
                    .font(AppFont.heading2)
                    .foregroundStyle(theme.text.onSurface)
                Text("Enter your phone number")
                    .font(AppFont.largeRegular)
                    .foregroundStyle(theme.text.onSecondary)
            }

            HStack(spacing: 0) {
                Text("+992 ")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .padding(.leading, 16)

                TextField("", text: $phoneNumber)
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onSurface)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 14)
                    .onChange(of: phoneNumber) { newValue in
                        phoneNumber = format(newValue)
                    }
            }
            .background(theme.background.secondaryContainer)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Group {
                    Text("By continuing, you agree to the ")
                    .foregroundColor(theme.text.onSecondary)
                    + Text("Terms of Use")
                    .foregroundColor(theme.text.primaryContainer)
                }
            .font(AppFont.mediumRegular)
                .multilineTextAlignment(.center)
                .onTapGesture {
                    // открыть Terms of Use
                }
            
            Spacer()
            AppButton(title: "Log In", state: .default) {
                
            }
        }
        .padding(.horizontal)
        .appBackground()
    }
    
    func format(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }.prefix(9)
        var result = ""
        for (i, char) in digits.enumerated() {
            switch i {
            case 2, 5, 7: result += " \(char)"
            default:       result += "\(char)"
            }
        }
        return result
    }
}

#Preview {
    LogInScreen()
}
