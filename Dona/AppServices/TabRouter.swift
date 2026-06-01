//
//  TabRouter.swift
//  Dona
//

import Foundation
import Combine

final class TabRouter: ObservableObject {
    static let shared = TabRouter()
    @Published var selectedTab = 0
}
