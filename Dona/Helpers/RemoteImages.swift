//
//  RemoteImages.swift
//  Dona
//

import SwiftUI

enum APIHost {
    static let base = URL(string: "https://api.dona.finance")!
}

extension String {
    /// API отдаёт пути к картинкам относительно хоста (например "/static/services/tcell.png")
    var apiImageURL: URL? {
        guard !isEmpty else { return nil }
        if hasPrefix("http") { return URL(string: self) }
        return URL(string: APIHost.base.absoluteString + (hasPrefix("/") ? self : "/\(self)"))
    }
}

struct FundLogoView: View {
    let urlString: String?
    var size: CGFloat = 45

    var body: some View {
        AsyncImage(url: (urlString ?? "").apiImageURL) { phase in
            if case .success(let image) = phase {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size / 5))
            } else {
                Image(.amazonMock)
                    .resizable()
                    .frame(width: size, height: size)
            }
        }
    }
}

struct TransactionIconView: View {
    @Environment(\.theme) private var theme
    let urlString: String?
    var size: CGFloat = 36

    var body: some View {
        AsyncImage(url: (urlString ?? "").apiImageURL) { phase in
            if case .success(let image) = phase {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: size * 0.4, weight: .medium))
                    .foregroundStyle(theme.text.onTertiary)
                    .frame(width: size, height: size)
                    .background(theme.background.secondaryContainer)
                    .clipShape(Circle())
            }
        }
    }
}

struct ProfileAvatarView: View {
    let urlString: String?
    var size: CGFloat = 80

    var body: some View {
        AsyncImage(url: (urlString ?? "").apiImageURL) { phase in
            if case .success(let image) = phase {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Image(.profileMock)
                    .resizable()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
