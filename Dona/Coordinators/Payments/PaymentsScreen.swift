//
//  PaymentsScreen.swift
//  Dona
//
//  Created by Damir Rizoev on 30/04/26.
//

import SwiftUI
import FlowStacks
import Combine

@MainActor
final class PaymentsViewModel: ObservableObject {
    @Published var services: [Service] = []
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() { load() }

    private func load() {
        isLoading = true
        APIManager.shared.listServices()
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                self?.services = response.payload
            }
            .store(in: &cancellables)
    }
}

struct PaymentsScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: FlowNavigator<PaymentsRouter>
    @AppStorage("appLanguage") private var _language: String = "en"
    @StateObject private var viewModel = PaymentsViewModel()

    private let skeletonWidths: [CGFloat] = [120, 95, 140, 85, 110, 130]

    var body: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if viewModel.isLoading && viewModel.services.isEmpty {
                    servicesSkeleton()
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.services.enumerated()), id: \.element.id) { index, service in
                            Button {
                                navigator.push(.subServices(serviceId: service.id, title: service.serviceName))
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: service.imageName)) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 20, height: 20)
                                                .padding(6)
                                                .background(theme.background.inversePrimary)
                                                .clipShape(Circle())
                                        default:
                                            ShimmerBox(width: 32, height: 32, cornerRadius: 16)
                                        }
                                    }
                                    Text(service.serviceName)
                                        .font(AppFont.largeMedium)
                                        .foregroundStyle(theme.text.onSurface)
                                    Spacer()
                                    Image(.right)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(theme.text.onTertiary)
                                }
                            }
                            if index != viewModel.services.count - 1 {
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
        .navigationTitle("Payments".localized)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder private func servicesSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(skeletonWidths.enumerated()), id: \.offset) { index, width in
                HStack(spacing: 12) {
                    ShimmerBox(width: 32, height: 32, cornerRadius: 16)
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

#Preview {
    PaymentsScreen()
}
