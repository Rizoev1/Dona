//
//  IndividualFundScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import SwiftUI
import FlowStacks

struct IndividualFundScreen: View {
    @Binding var routes: Routes<FundsRouter>
    @Environment(\.theme) var theme
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                makeTopVIew()
                makeMembers()
                
                Button {
                    routes.push(.approvals)
                } label: {
                HStack(spacing: 12) {
                    Image(.signature)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("Approvals")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onSurface)
                            
                            PulsingDot(color: theme.text.onErrorContainer)
                        }
                        Text("2 requests Pending")
                            .font(AppFont.mediumMedium)
                            .foregroundStyle(theme.text.onErrorContainer)
                    }
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
                .padding(16)
                .background(theme.background.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
                
                makeOptions()
                makeRecentActivity()
            }
        }
        .padding(.horizontal, 12)
        .background(theme.background.surface)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { } label: {
                    Image(.search)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
        }
    }
    
    @ViewBuilder func makeTopVIew() -> some View {
        VStack(spacing: 16) {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Family Savings")
                            .font(AppFont.heading1)
                            .foregroundStyle(theme.text.onSurface)
                        HStack(spacing: 4) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(theme.text.foregroundSuccess1)
                                    .frame(width: 4, height: 4)
                                Text("ADMIN")
                                    .font(AppFont.smallMedium)
                                    .foregroundStyle(theme.text.foregroundSuccess1)
                            }
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(theme.background.backgroundSuccess)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                            
                            Text("ADMIN")
                                .font(AppFont.smallMedium)
                                .foregroundStyle(theme.text.primaryContainer)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(theme.background.inversePrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 60))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fund balance")
                            .font(AppFont.mediumRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        HStack(spacing: 4) {
                            Text("2 145.00")
                                .font(AppFont.heading2)
                                .foregroundStyle(theme.text.onSurface)
                            Text("TJS")
                                .font(AppFont.largeMedium)
                                .foregroundStyle(theme.text.onTertiaryContainer)
                        }
                    }
                }
                .padding(.vertical, 16).padding(.horizontal, 18)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(.amazonMock)
                    .resizable()
                    .frame(width: 144, height: 144)
                    .offset(x: 15, y: 28)
            }
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            HStack(spacing: 16) {
                VStack(spacing: 6) {
                    Button {
                        routes.push(.payment(.topUp))
                    } label: {
                        Image(.add)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.foregroundStaticWhite)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 46)
                            .background(LinearGradient(colors:
                                [Color(hex: "#2A8AE4"), Color(hex: "#3A49F9")],
                                    startPoint: .trailing,
                                    endPoint: .leading))
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Top up")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
                VStack(spacing: 6) {
                    Button {
                        
                    } label: {
                        Image(.arrowDown)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(theme.text.onSurface)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 46)
                            .background(theme.background.background)
                            .clipShape(RoundedRectangle(cornerRadius: 60))
                    }
                    Text("Request")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onSurface)
                }
            }
        }
    }
    
    @ViewBuilder func makeMembers() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text("Members")
                    .font(AppFont.heading3)
                    .foregroundColor(theme.text.onSurface)
                Text("12")
                    .font(AppFont.heading3)
                    .foregroundColor(theme.text.onTertiaryContainer)
                Spacer()
                Button {
                    routes.push(.members)
                } label: {
                    HStack(spacing: 5) {
                        Text("View All")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        Image(.arrowRight)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0 ..< 7) { _ in
                        Button { } label: {
                            VStack(spacing: 8) {
                                ZStack(alignment: .bottomTrailing) {
                                    Text("MK")
                                        .font(AppFont.largeMedium)
                                        .foregroundStyle(theme.text.primaryContainer)
                                        .padding(10)
                                        .background(theme.background.inversePrimary)
                                        .clipShape(Circle())
                                    
                                    Image(.moneyRed)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .offset(x: 2, y: 2)
                                }
                                
                                Text("Maftuna K.")
                                    .font(AppFont.smallSemibold)
                                    .foregroundStyle(theme.text.onSurface)
                            }
                        }
                    }
                }
                .padding()
            }
            .clipped()
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    @ViewBuilder func makeOptions() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.clockBlue)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("View my history")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider()
                .padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.chart)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    Text("Fund report")
                        .font(AppFont.largeMedium)
                        .foregroundStyle(theme.text.onSurface)
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider()
                .padding(.leading, 48)
            Button {} label: {
                HStack(spacing: 12) {
                    Image(.document)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(theme.background.inversePrimary)
                        .clipShape(Circle())
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Community Guidelines")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onSurface)
                        Text("Read rules and policies")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                    
                    Spacer()
                    Image(.right)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder func makeRecentActivity() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(AppFont.heading3)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Button {
                } label: {
                    HStack(spacing: 5) {
                        Text("View All")
                            .font(AppFont.smallRegular)
                            .foregroundStyle(theme.text.onTertiary)
                        Image(.arrowRight)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(theme.text.onTertiary)
                    }
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0 ..< 3, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(.amazonMock)
                            .resizable()
                            .frame(width: 36, height: 36)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Community name")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text("Monthly Contribution")
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("- 42.2 TJS")
                                .font(AppFont.mediumMedium)
                                .foregroundStyle(theme.text.onSurface)
                            Text("12.01")
                                .font(AppFont.mediumRegular)
                                .foregroundStyle(theme.text.onTertiary)
                        }
                    }
                    if index < 2 {
                        Divider()
                            .padding(.leading, 48)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 26)
            .background(theme.background.background)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .cardShadow()
        }
    }
}

struct PulsingDot: View {
    let color: Color
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true)
                ) {
                    scale = 1.4
                }
            }
    }
}

