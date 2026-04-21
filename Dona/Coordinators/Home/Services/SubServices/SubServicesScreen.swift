//
//  SubServicesScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 21/04/26.
//

import SwiftUI
import FlowStacks

struct SubServicesScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var navigator: FlowNavigator<HomeRouter>

    let title: String

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0 ..< 5, id: \.self) { index in
                    Button {
                        navigator.push(.payment(.services(title: title)))
                    } label: {
                        HStack(spacing: 12) {
                            Image(.tcellMock)
                                .resizable()
                                .frame(width: 36, height: 36)
                            Text("Tcell")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Spacer()
                            Image(.right)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                    if index != 4 {
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    SubServicesScreen(title: "")
}
