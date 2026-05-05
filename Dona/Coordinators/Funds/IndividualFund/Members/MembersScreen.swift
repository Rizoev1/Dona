//
//  MembersScreen.swift
//  Dona
//
//  Created by Damir.Rizoev on 05/05/26.
//

import SwiftUI

struct MembersScreen: View {
    @Environment(\.theme) var theme
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(0 ..< 8) { _ in
                        HStack(spacing: 12) {
                            Text("MK")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.primaryContainer)
                                .padding(10)
                                .background(theme.background.inversePrimary)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Maftuna Kholova")
                                    .font(AppFont.largeMedium)
                                    .foregroundStyle(theme.text.onSurface)
                                Text("+992 98 765 43 21")
                                    .font(AppFont.mediumRegular)
                                    .foregroundStyle(theme.text.onTertiary)
                            }
                            Spacer()
                            
                            Text("ADMIN")
                                .font(AppFont.smallMedium)
                                .foregroundStyle(theme.text.primaryContainer)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(theme.background.inversePrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }
                        Divider()
                            .padding(.leading, 58)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            Spacer()
            AppButton(title: "Add Member", state: .default, action: {})
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .navigationTitle("Members")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MembersScreen()
}
