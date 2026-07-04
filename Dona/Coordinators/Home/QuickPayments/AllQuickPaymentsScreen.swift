//
//  AllQuickPaymentsScreen.swift
//  Dona
//

import SwiftUI
import Combine

@MainActor
private final class AllQuickPaymentsViewModel: ObservableObject {
    @Published var quickPayments: [QuickPayment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        load()
    }

    private func load() {
        isLoading = true
        APIManager.shared.listQuickPayments()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] response in
                self?.quickPayments = response.payload
            }
            .store(in: &cancellables)
    }

    func delete(_ item: QuickPayment) {
        APIManager.shared.deleteQuickPayment(id: item.id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.userMessage
                }
            } receiveValue: { [weak self] _ in
                self?.quickPayments.removeAll { $0.id == item.id }
            }
            .store(in: &cancellables)
    }
}

struct AllQuickPaymentsScreen: View {
    @Environment(\.theme) private var theme
    @AppStorage("appLanguage") private var _language: String = "en"
    @StateObject private var viewModel = AllQuickPaymentsViewModel()

    let onQuickPaymentTap: (QuickPayment) -> Void

    private let skeletonWidths: [CGFloat] = [120, 95, 140, 85, 110]

    var body: some View {
        ScrollView(showsIndicators: false) {
            Group {
                if viewModel.isLoading && viewModel.quickPayments.isEmpty {
                    listSkeleton()
                } else if viewModel.quickPayments.isEmpty {
                    EmptyStateView(
                        icon: Image(systemName: "bolt.fill"),
                        title: "No quick payments yet".localized,
                        subtitle: "Pay a service to save it here".localized
                    )
                    .padding(.top, 32)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.quickPayments.enumerated()), id: \.element.id) { index, item in
                            Button {
                                onQuickPaymentTap(item)
                            } label: {
                                row(item)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.delete(item)
                                } label: {
                                    Label("Delete".localized, systemImage: "trash")
                                }
                            }
                            if index != viewModel.quickPayments.count - 1 {
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
            .padding(.top, 16)
        }
        .background(theme.background.surface)
        .navigationTitle("Quick Pay".localized)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error".localized, isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    @ViewBuilder private func row(_ item: QuickPayment) -> some View {
        HStack(spacing: 12) {
            TransactionIconView(urlString: item.iconUrl)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.label)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Text(item.account)
                    .font(AppFont.smallRegular)
                    .foregroundStyle(theme.text.onTertiary)
            }
            Spacer()
            Image(.right)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundStyle(theme.text.onTertiary)
        }
    }

    @ViewBuilder private func listSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(skeletonWidths.enumerated()), id: \.offset) { index, width in
                HStack(spacing: 12) {
                    ShimmerBox(width: 36, height: 36, cornerRadius: 18)
                    VStack(alignment: .leading, spacing: 6) {
                        ShimmerBox(width: width, height: 14)
                        ShimmerBox(width: 80, height: 11)
                    }
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
