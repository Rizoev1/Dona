//
//  FundNamingScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI

struct FundNamingScreen: View {
    @Environment(\.theme) var theme
    @State private var fundName: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 140)
            
            TextField("Fund name", text: $fundName)
                .font(AppFont.heading1)
                .foregroundColor(theme.text.onSurface)
                .tint(theme.text.onSurface)
                .multilineTextAlignment(.center)
                .focused($isFocused)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            theme.text.onSurface.opacity(0.3),
                            theme.text.onSurface.opacity(0.3),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            Spacer()
            
            AppButton(title: "Continue", state: .default, action: {})
        }
        .padding(.horizontal)
        .navigationTitle("Create fund")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.background.surface)
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    FundNamingScreen()
}
