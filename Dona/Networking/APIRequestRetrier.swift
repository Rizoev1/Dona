//
//  APIRequestRetrier.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Alamofire
import Foundation

final class APIRequestRetrier: RequestInterceptor {

    private let maxRetryCount: Int
    private let retryDelay: TimeInterval

    init(maxRetryCount: Int = 3, retryDelay: TimeInterval = 1.0) {
        self.maxRetryCount = maxRetryCount
        self.retryDelay = retryDelay
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        let isAuthEndpoint = request.url?.path.contains("/auth/") == true
        if !isAuthEndpoint, let token = KeychainService.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // Handles only network-level errors (connection lost, timeout, etc.)
    // 401 token refresh is handled in APIManager via Combine operators.
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard shouldRetry(error: error), request.retryCount < maxRetryCount else {
            completion(.doNotRetry)
            return
        }

        let delay = retryDelay * pow(2.0, Double(request.retryCount))
        completion(.retryWithDelay(delay))
    }

    private func shouldRetry(error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        switch urlError.code {
        case .timedOut, .networkConnectionLost,
             .notConnectedToInternet, .cannotConnectToHost, .cannotFindHost:
            return true
        default:
            return false
        }
    }
}
