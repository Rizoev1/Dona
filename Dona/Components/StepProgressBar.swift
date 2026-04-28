//
//  StepProgressBar.swift
//  Dona
//
//  Created by Damir Rizoev on 28/04/26.
//

import SwiftUI

struct StepProgressBar: View {
    @Environment(\.theme) var theme
    let totalSteps: Int
    let currentStep: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...totalSteps, id: \.self) { step in
                Capsule()
                    .fill(
                        step <= currentStep
                        ? LinearGradient(
                            colors: [Color(hex: "2A8AE4"), Color(hex: "3A49F9")],
                            startPoint: .leading,
                            endPoint: .trailing
                          )
                        : LinearGradient(
                            colors: [Color(.systemGray5), Color(.systemGray5)],
                            startPoint: .leading,
                            endPoint: .trailing
                          )
                    )
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .padding(.horizontal, 20)
    }
}
