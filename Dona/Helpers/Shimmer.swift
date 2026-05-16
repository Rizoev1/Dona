//
//  Shimmer.swift
//  Dona
//

import SwiftUI

// MARK: - Shimmer animation layer

private struct ShimmerLayer: View {
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            LinearGradient(
                colors: [.clear, .white.opacity(0.55), .clear],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: w * 0.6)
            .offset(x: isAnimating ? w * 1.1 : -w * 0.6)
            .animation(
                .linear(duration: 1.4).repeatForever(autoreverses: false),
                value: isAnimating
            )
        }
        .onAppear { isAnimating = true }
    }
}

// MARK: - ShimmerBox

struct ShimmerBox: View {
    @Environment(\.theme) private var theme

    var width: CGFloat? = nil
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 8

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.background.tertiaryContainer)
            .frame(width: width, height: height)
            .overlay(ShimmerLayer())
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Adaptive presentation detents (iOS 16+)

private struct AdaptiveSheetModifier: ViewModifier {
    let height: CGFloat

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDetents([.height(height)])
                .presentationDragIndicator(.visible)
        } else {
            content
        }
    }
}

extension View {
    func adaptivePresentationDetents(height: CGFloat) -> some View {
        modifier(AdaptiveSheetModifier(height: height))
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    @Environment(\.theme) private var theme

    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(theme.text.onTertiaryContainer)

            VStack(spacing: 6) {
                Text(title)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(theme.text.onSurface)
                Text(subtitle)
                    .font(AppFont.mediumRegular)
                    .foregroundStyle(theme.text.onTertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 52)
        .padding(.horizontal, 32)
    }
}
