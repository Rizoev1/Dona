//
//  FundReportScreen.swift
//  Dona
//

import SwiftUI
import Combine

@MainActor
final class FundReportViewModel: ObservableObject {
    @Published var report: ReportResponse.Report?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func onAppear(fundId: Int) {
        isLoading = true
        APIManager.shared.getFundReport(fundId: fundId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.report = response.payload
            }
            .store(in: &cancellables)
    }
}

struct FundReportScreen: View {
    @Environment(\.theme) private var theme
    @StateObject private var viewModel = FundReportViewModel()

    let fundId: Int

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    reportSkeleton()
                } else if let report = viewModel.report {
                    makeReportCard(report)
                } else if let error = viewModel.errorMessage {
                    EmptyStateView(
                        icon: "exclamationmark.triangle",
                        title: "Failed to load report",
                        subtitle: error
                    )
                }
            }
            .padding(.horizontal, 12)
        }
        .background(theme.background.surface)
        .navigationTitle("Fund Report")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.onAppear(fundId: fundId) }
    }

    @ViewBuilder func makeReportCard(_ report: ReportResponse.Report) -> some View {
        VStack(spacing: 1) {
            makeRow(
                icon: "arrow.down.circle.fill",
                iconColor: theme.text.foregroundSuccess1,
                title: "Total Contributions",
                value: formatAmount(report.contributions),
                valueColor: theme.text.foregroundSuccess1
            )
            makeRow(
                icon: "arrow.up.circle.fill",
                iconColor: theme.text.onErrorContainer,
                title: "Total Disbursements",
                value: formatAmount(report.disbursements),
                valueColor: theme.text.onErrorContainer
            )
            makeRow(
                icon: "chart.line.uptrend.xyaxis",
                iconColor: theme.stroke.scrim,
                title: "Net Growth",
                value: formatAmount(report.netGrowth),
                valueColor: report.netGrowth >= 0
                    ? theme.text.foregroundSuccess1
                    : theme.text.onErrorContainer
            )
            makeRow(
                icon: "percent",
                iconColor: theme.text.foregroundWarning1,
                title: "Growth",
                value: String(format: "%.2f%%", report.growthPercent),
                valueColor: report.growthPercent >= 0
                    ? theme.text.foregroundSuccess1
                    : theme.text.onErrorContainer,
                isLast: true
            )
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    @ViewBuilder func makeRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: String,
        valueColor: Color,
        isLast: Bool = false
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
                    .frame(width: 20)
                Text(title)
                    .font(AppFont.largeMedium)
                    .foregroundStyle(theme.text.onSurface)
                Spacer()
                Text(value)
                    .font(AppFont.largeSemibold)
                    .foregroundStyle(valueColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)

            if !isLast {
                Divider().padding(.leading, 48)
            }
        }
    }

    @ViewBuilder func reportSkeleton() -> some View {
        VStack(spacing: 1) {
            ForEach(0..<4, id: \.self) { index in
                HStack(spacing: 12) {
                    ShimmerBox(width: 20, height: 20, cornerRadius: 10)
                    ShimmerBox(width: 140, height: 14)
                    Spacer()
                    ShimmerBox(width: 80, height: 14)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 18)
                if index < 3 { Divider().padding(.leading, 48) }
            }
        }
        .background(theme.background.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func formatAmount(_ dirams: Int) -> String {
        let tjs = Double(dirams) / 100.0
        return String(format: "%.2f TJS", tjs)
    }
}

#Preview {
    FundReportScreen(fundId: 1)
}
