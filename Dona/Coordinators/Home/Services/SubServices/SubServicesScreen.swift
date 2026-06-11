//
//  SubServicesScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 21/04/26.
//

import SwiftUI
import Combine

@MainActor
final class SubServicesViewModel: ObservableObject {
    @Published var subServices: [SubService] = []
    @Published var isLoading = false

    private let serviceId: Int
    private var cancellables = Set<AnyCancellable>()

    init(serviceId: Int) {
        self.serviceId = serviceId
        load()
    }

    private func load() {
        isLoading = true
        APIManager.shared.listSubServices(serviceId: serviceId)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                self?.subServices = response.payload
            }
            .store(in: &cancellables)
    }
}

struct SubServicesScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel: SubServicesViewModel

    let title: String
    let onSubServiceTap: (SubService) -> Void

    private let skeletonWidths: [CGFloat] = [110, 90, 145, 80, 125]

    init(serviceId: Int, title: String, onSubServiceTap: @escaping (SubService) -> Void) {
        self.title = title
        self.onSubServiceTap = onSubServiceTap
        _viewModel = StateObject(wrappedValue: SubServicesViewModel(serviceId: serviceId))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if viewModel.isLoading && viewModel.subServices.isEmpty {
                    subServicesSkeleton()
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.subServices.enumerated()), id: \.element.id) { index, sub in
                            Button {
                                onSubServiceTap(sub)
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: sub.imageName)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 36, height: 36)
                                                .clipShape(Circle())
                                        default:
                                            ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                                        }
                                    }
                                    Text(sub.name)
                                        .font(AppFont.largeMedium)
                                        .foregroundStyle(theme.text.onSurface)
                                    Spacer()
                                    Image(.right)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(theme.text.onTertiary)
                                }
                            }
                            if index != viewModel.subServices.count - 1 {
                                Divider().padding(.leading, 46)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 21)
                    .background(theme.background.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
        }
        .background(theme.background.surface)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder private func subServicesSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(skeletonWidths.enumerated()), id: \.offset) { index, width in
                HStack(spacing: 12) {
                    ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                    ShimmerBox(width: width, height: 14)
                    Spacer()
                }
                if index < skeletonWidths.count - 1 {
                    Divider().padding(.leading, 46)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 21)
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
