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

    var body: some View {
        ScrollView(showsIndicators: false) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 100)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(viewModel.services.enumerated()), id: \.element.id) { index, service in
                        Button {
                            navigator.push(.subServices(serviceId: service.id, title: service.serviceName))
                        } label: {
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: service.imageName)) { image in
                                    image.resizable().frame(width: 20, height: 20)
                                } placeholder: {
                                    Image(.mobile)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(theme.stroke.scrim)
                                }
                                .padding(6)
                                .background(theme.background.inversePrimary)
                                .clipShape(Circle())
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
            }
        }
        .padding(.horizontal, 16)
        .background(theme.background.surface)
        .navigationTitle("Payments".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PaymentsScreen()
}
