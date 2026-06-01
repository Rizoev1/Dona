//
//  PaymentsScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import SwiftUI
import FlowStacks

struct PaymentsScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<PaymentsRouter>

    private let services: [(title: String, icon: ImageResource)] = [
        ("Mobile Top-up",  .mobile),
        ("Electricity",    .mobile),
        ("Internet",       .mobile),
        ("Gas",            .mobile),
        ("Water",          .mobile),
        ("TV",             .mobile),
        ("Loan",           .mobile),
        ("Insurance",      .mobile),
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(services.enumerated()), id: \.offset) { index, service in
                    Button {
                        navigator.push(.subServices(title: service.title))
                    } label: {
                        HStack(spacing: 12) {
                            Image(service.icon)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(theme.stroke.scrim)
                                .padding(6)
                                .background(theme.background.inversePrimary)
                                .clipShape(Circle())
                            Text(service.title)
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Spacer()
                            Image(.right)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                    if index != services.count - 1 {
                        Divider().padding(.leading, 46)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 21)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 16)
        .background(theme.background.surface)
        .navigationTitle("Payments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PaymentsScreen()
}
