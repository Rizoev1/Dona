//
//  PaymentScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI

enum PaymentScreenType: Hashable {
    case topUp
    case request
    case send
    case services(title: String)

    var navigationTitle: String {
        switch self {
        case .topUp: return "Top Up"
        case .request: return "Request"
        case .send: return "Send"
        case .services(let title): return title
        }
    }

    var buttonTitle: String {
        switch self {
        case .topUp: return "Top Up"
        case .request: return "Continue"
        case .send: return "Send"
        case .services: return "Top-up"
        }
    }
}

struct PaymentScreen: View {
    @Environment(\.theme) private var theme
    @State private var amount: String = ""
    @State private var phoneNumber: String = ""
    @FocusState private var focusedField: PaymentField?

    enum PaymentField {
        case phone
        case amount
    }

    let type: PaymentScreenType

    var body: some View {
        VStack(spacing: 24) {
            switch type {
            case .topUp:
                makeTopUpLayout()
            case .request:
                makeRequestLayout()
            case .send:
                makeSendLayout()
            case .services:
                makeServicesLayout()
            }
        }
        .padding(.horizontal)
        .background(theme.background.surface)
        .navigationTitle(type.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                switch type {
                case .services:
                    focusedField = .phone
                default:
                    focusedField = .amount
                }
            }
        }
    }

    @ViewBuilder func makeTopUpLayout() -> some View {
        makeWalletCard(label: "Send to", name: "Personal Wallet", number: "•• 4092", balance: "2 145.00 TJS", showChange: false)
        makeAmountField()
        Spacer()
        makeTopUpCard()
        AppButton(title: type.buttonTitle, state: .default, action: {})
    }

    @ViewBuilder func makeRequestLayout() -> some View {
        makeWalletCard(label: "From fund", name: "Family Savings", number: "2 145.00 TJS", balance: "", showChange: true)
        makeAmountField()
        Spacer()
        makeWalletCard(label: "To", name: "Personal Wallet", number: "•• 4092", balance: "2 145.00 TJS", showChange: false)
        AppButton(title: type.buttonTitle, state: .default, action: {})
    }

    @ViewBuilder func makeSendLayout() -> some View {
        makeWalletCard(label: "From", name: "Personal Wallet", number: "•• 4092", balance: "2 145.00 TJS", showChange: false)
        makeAmountField()
        Spacer()
        makeWalletCard(label: "To", name: "Family Savings", number: "2 145.00 TJS", balance: "", showChange: true)
        AppButton(title: type.buttonTitle, state: .default, action: {})
    }

    @ViewBuilder func makeServicesLayout() -> some View {
        VStack(spacing: 4) {
            makePhoneField()
            makeWalletCard(label: "From", name: "Personal Wallet", number: "•• 4092", balance: "2 145.00 TJS", showChange: false)
        }
        makeAmountField()
        Spacer()
        AppButton(title: type.buttonTitle, state: .default, action: {})
    }
    
    @ViewBuilder func makeTopUpCard() -> some View {
        VStack(spacing: 4) {
            HStack {
                Text("Dona Wallet Top-Up")
                    .font(AppFont.mediumSemibold)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Text("2090 4821 0037 5516")
                    .font(AppFont.mediumSemibold)
                    .foregroundStyle(theme.text.onSurface)
            }
            HStack {
                Text("Humo Bank")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onTertiary)
                Spacer()
                Text("DON-L8GESX")
                    .font(AppFont.mediumMedium)
                    .foregroundStyle(theme.text.onTertiary)
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeWalletCard(
        label: String,
        name: String,
        number: String,
        balance: String,
        showChange: Bool
    ) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text(label)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
                VStack { Divider() }
            }
            HStack(spacing: 12) {
                Image(.wallet)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .padding(9)
                    .background(theme.background.tertiaryContainer)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(AppFont.largeSemibold)
                        .foregroundStyle(theme.text.onSurface)
                    Text(number)
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                }
                Spacer()
                if showChange {
                    Button(action: { }) {
                        Text("Change")
                            .font(AppFont.smallSemibold)
                            .foregroundStyle(theme.text.onSecondary)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(theme.background.secondaryContainer)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                } else {
                    Text(balance)
                        .font(AppFont.smallSemibold)
                        .foregroundStyle(theme.text.onSecondary)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(theme.background.secondaryContainer)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeAmountField() -> some View {
           HStack(spacing: 6) {
               TextField("0", text: $amount)
                   .keyboardType(.decimalPad)
                   .font(AppFont.heading1)
                   .foregroundStyle(theme.text.onSurface)
                   .multilineTextAlignment(.center)
                   .fixedSize()
                   .focused($focusedField, equals: .amount)
               Text("TJS")
                   .font(AppFont.xxLargeMedium)
                   .foregroundStyle(theme.text.onTertiaryContainer)
           }
           .frame(maxWidth: .infinity, minHeight: 56)
       }

       @ViewBuilder func makePhoneField() -> some View {
           HStack(spacing: 12) {
               Image(.call)
                   .resizable()
                   .frame(width: 20, height: 20)
                   .foregroundStyle(theme.text.onTertiary)
               VStack(alignment: .leading, spacing: 4) {
                   Text("Phone number")
                       .font(AppFont.smallRegular)
                       .foregroundStyle(theme.text.onTertiary)
                   HStack(spacing: 0) {
                       Text("+992 ")
                           .font(AppFont.mediumMedium)
                           .foregroundStyle(theme.text.onSurface)
                       TextField("00 000 00 00", text: $phoneNumber)
                           .keyboardType(.phonePad)
                           .font(AppFont.mediumMedium)
                           .foregroundStyle(theme.text.onSurface)
                           .focused($focusedField, equals: .phone)
                           .onChange(of: phoneNumber) { newValue in
                               let digits = newValue.filter { $0.isNumber }
                               let limited = String(digits.prefix(9))
                               if limited != newValue {
                                   phoneNumber = limited
                               }
                               if limited.count == 9 {
                                   focusedField = .amount
                               }
                           }
                   }
               }
           }
           .padding(.vertical, 8)
           .padding(.horizontal, 14)
           .background(theme.background.secondaryContainer)
           .clipShape(RoundedRectangle(cornerRadius: 20))
           .padding(12)
           .background(theme.background.background)
           .clipShape(RoundedRectangle(cornerRadius: 20))
       }
   }

#Preview {
    NavigationView {
        PaymentScreen(type: .topUp)
    }
}
