//
//  CustomSheet.swift
//  Dona
//
//  Created by Damir Rizoev on 10/04/26.
//

import Foundation
import SwiftUI

enum SheetHeight: Equatable {
    case small
    case medium
    case large
    case custom(CGFloat)
    case fitContent
    
    func getDetents() -> [UISheetPresentationController.Detent] {
        switch self {
        case .small:
            if #available(iOS 16.0, *) {
                return [.custom { _ in 200 }]
            } else {
                return [.medium()]
            }
        case .medium:
            return [.medium()]
        case .large:
            return [.large()]
        case .custom(let percentage):
            if #available(iOS 16.0, *) {
                return [.custom { context in
                    return context.maximumDetentValue * percentage
                }]
            } else {
                return percentage > 0.5 ? [.large()] : [.medium()]
            }
        case .fitContent:
            if #available(iOS 16.0, *) {
                return [.custom { _ in 300 }]
            } else {
                return [.medium()]
            }
        }
    }
}

class HalfSheetController<Content>: UIHostingController<Content> where Content: View {
    var sheetHeight: SheetHeight = .fitContent
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if sheetHeight == .fitContent {
            updateFitContentHeight()
        }
    }
    
    fileprivate func updateFitContentHeight() {
        guard #available(iOS 16.0, *),
              let presentation = sheetPresentationController else { return }
        
        let targetSize = CGSize(
            width: view.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = sizeThatFits(in: targetSize)
        
        let maxHeight = UIScreen.main.bounds.height * 0.9
        let contentHeight = min(fittingSize.height, maxHeight)
        
        presentation.detents = [.custom { _ in contentHeight }]
        presentation.selectedDetentIdentifier = presentation.detents.first?.identifier
    }
    
    func configureSheet() {
        guard let presentation = sheetPresentationController else { return }
        
        if sheetHeight == .fitContent {
            if #available(iOS 16.0, *) {
                presentation.detents = [.medium()]
            } else {
                presentation.detents = [.medium()]
            }
        } else {
            presentation.detents = sheetHeight.getDetents()
        }
        
        view.backgroundColor = .clear
    }
}

struct CustomSheet<Content>: UIViewControllerRepresentable where Content: View {
    @Environment(\.theme) private var theme
    private let content: Content
    private let sheetHeight: SheetHeight
    
    init(
        height: SheetHeight = .fitContent,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.sheetHeight = height
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        let controller = HalfSheetController(rootView: content)
        controller.sheetHeight = sheetHeight
        return controller
    }
    
    func updateUIViewController(_ uiViewController: HalfSheetController<Content>, context: Context) {
        uiViewController.rootView = content
        uiViewController.sheetHeight = sheetHeight
        
        uiViewController.view.setNeedsLayout()
        uiViewController.view.layoutIfNeeded()
        
        if sheetHeight == .fitContent {
            DispatchQueue.main.async {
                uiViewController.updateFitContentHeight()
            }
        } else {
            uiViewController.configureSheet()
        }
    }
}

extension View {
    func halfSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            CustomSheet(height: .fitContent, content: content)
        }
    }
}
