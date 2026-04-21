//
//  ServicesScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 21/04/26.
//

import SwiftUI
import FlowStacks

struct ServicesScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var navigator: FlowNavigator<HomeRouter>

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0 ..< 8, id: \.self) { index in
                    Button {
                        navigator.push(.subServices(title: "Mobile Top-up"))
                    } label: {
                        HStack(spacing: 12) {
                            Image(.mobile)
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(theme.stroke.scrim)
                                .padding(6)
                                .background(theme.background.inversePrimary)
                                .clipShape(Circle())

                            Text("Mobile Top-up")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)

                            Spacer()

                            Image(.right)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }

                    if index != 7 {
                        Divider()
                            .padding(.leading, 46)
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
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    ServicesScreen()
}
