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
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)
                    GeometryReader { geo in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "2A8AE4"), Color(hex: "3A49F9")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: step < currentStep
                                    ? geo.size.width
                                    : step == currentStep
                                        ? geo.size.width
                                        : 0,
                                height: 4
                            )
                            .animation(
                                .easeInOut(duration: 0.3).delay(step == currentStep ? 0.1 : 0),
                                value: currentStep
                            )
                    }
                    .frame(height: 4)
                }
            }
        }
    }
}
