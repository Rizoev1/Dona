//
//  FundSelectionScreen.swift
//
//  Created by Damir Rizoev on 17/04/26.
//

import SwiftUI
import FlowStacks
import Combine

@MainActor
final class FundSelectionViewModel: ObservableObject {
    @Published var funds: [Fund] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func onAppear() {
        isLoading = true
        APIManager.shared.listFunds()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.funds = response.payload
            }
            .store(in: &cancellables)
    }
}

struct FundSelectionScreen: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var navigator: FlowNavigator<HomeRouter>
    @StateObject private var viewModel = FundSelectionViewModel()

    let type: FundSelectionType

    var navigationTitle: String {
        switch type {
        case .request: return "Select Fund to Request"
        case .send: return "Select Fund to Send"
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if viewModel.isLoading && viewModel.funds.isEmpty {
                    ForEach(0..<3, id: \.self) { _ in makeFundCardSkeleton() }
                } else if !viewModel.isLoading && viewModel.funds.isEmpty {
                    EmptyStateView(
                        icon: "person.3",
                        title: "No communities",
                        subtitle: "You don't belong to any savings community yet"
                    )
                } else {
                    ForEach(viewModel.funds) { fund in
                        Button {
                            switch type {
                            case .request:
                                navigator.push(.payment(.request(fund: fund)))
                            case .send:
                                navigator.push(.payment(.send(fund: fund)))
                            }
                        } label: {
                            makeFundCard(fund)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear { viewModel.onAppear() }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .background(theme.background.surface)
    }

    @ViewBuilder func makeFundCardSkeleton() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ShimmerBox(width: 45, height: 45, cornerRadius: 12)
                VStack(alignment: .leading, spacing: 6) {
                    ShimmerBox(width: 130, height: 16)
                    ShimmerBox(width: 75, height: 12)
                }
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    ShimmerBox(width: 80, height: 12)
                    ShimmerBox(width: 110, height: 22)
                }
                Spacer()
                ShimmerBox(width: 46, height: 46, cornerRadius: 23)
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeFundCard(_ fund: Fund) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                Image(.amazonMock)
                    .resizable()
                    .frame(width: 45, height: 45)
                VStack(alignment: .leading, spacing: 2) {
                    Text(fund.name)
                        .font(AppFont.xLargeBold)
                        .foregroundStyle(theme.text.onSurface)
                    Text("\(fund.memberCount) Members")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                }
            }
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Fund balance")
                        .font(AppFont.smallRegular)
                        .foregroundStyle(theme.text.onTertiary)
                    HStack(spacing: 4) {
                        Text(fund.balanceFormatted)
                            .font(AppFont.heading3)
                            .foregroundStyle(theme.text.onSurface)
                        Text("TJS")
                            .font(AppFont.largeMedium)
                            .foregroundStyle(theme.text.onTertiaryContainer)
                    }
                }
                Spacer()
                Image(.arrowRight)
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(theme.text.onSurface)
                    .padding(12)
                    .background(theme.background.secondaryContainer)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    FundSelectionScreen(type: .request)
}
