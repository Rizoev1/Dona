//
//  FundNamingScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 29/04/26.
//

import SwiftUI
import FlowStacks

struct FundNamingScreen: View {
    @Environment(\.theme) var theme
    @Binding var routes: Routes<FundsRouter>
    @State private var fundName: String = ""
    @FocusState private var isFocused: Bool
    @State private var animatedStep: Int = 0

    var body: some View {
        VStack(spacing: 16) {
            StepProgressBar(totalSteps: 5, currentStep: animatedStep)

            Spacer().frame(height: 100)

            TextField("Fund name", text: $fundName)
                .font(AppFont.heading1)
                .foregroundColor(theme.text.onSurface)
                .tint(theme.text.onSurface)
                .multilineTextAlignment(.center)
                .focused($isFocused)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, theme.text.onSurface.opacity(0.3), theme.text.onSurface.opacity(0.3), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)

            Spacer()

            AppButton(title: "Continue", state: fundName.isEmpty ? .disabled : .default) {
                routes.push(.fundAmount)
            }
        }
        .padding(.horizontal)
        .navigationTitle("Create fund")
        .navigationBarTitleDisplayMode(.inline)
        .background(theme.background.surface)
        .onAppear {
            isFocused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animatedStep = 1
                }
            }
        }
    }
}

