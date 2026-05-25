//
//  APIManager.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Moya
import CombineMoya
import Combine
import Foundation

final class APIManager {
    static let shared = APIManager()

    private let networking: Networking<API> = .defaultNetworking()

    // MARK: - Core request with 401 → refresh → retry

    private func requestObject<T: Decodable>(
        _ target: API,
        type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, MoyaError> {
        executeRequest(target)
            .catch { [weak self] error -> AnyPublisher<Response, MoyaError> in
                guard let self,
                      case .statusCode(let response) = error,
                      response.statusCode == 401
                else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return self.refreshAndRetry(target)
            }
            .tryMap { try decoder.decode(T.self, from: $0.data) }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // Single request execution — throws MoyaError.statusCode on 401/5xx
    private func executeRequest(_ target: API) -> AnyPublisher<Response, MoyaError> {
        networking.provider.requestPublisher(target)
            .tryMap { response -> Response in
                if response.statusCode == 401 {
                    throw MoyaError.statusCode(response)
                }
                return try response.filterSuccessfulStatusCodes()
            }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .eraseToAnyPublisher()
    }

    // Refresh tokens, then retry original request once
    private func refreshAndRetry(_ target: API) -> AnyPublisher<Response, MoyaError> {
        guard let refreshToken = KeychainService.shared.refreshToken else {
            return handleAuthFailure()
        }

        return networking.provider.requestPublisher(.refreshTokens(refreshToken: refreshToken))
            .tryMap { response -> AuthTokensResponse in
                guard response.statusCode == 200,
                      let decoded = try? JSONDecoder().decode(AuthTokensResponse.self, from: response.data)
                else {
                    throw MoyaError.statusCode(response)
                }
                return decoded
            }
            .mapError { $0 as? MoyaError ?? MoyaError.underlying($0, nil) }
            .catch { [weak self] _ -> AnyPublisher<AuthTokensResponse, MoyaError> in
                // Refresh itself failed (expired/invalid refresh token) → force logout
                self?.handleAuthFailure()
                return Fail(error: MoyaError.underlying(URLError(.userAuthenticationRequired), nil))
                    .eraseToAnyPublisher()
            }
            .flatMap { [weak self] tokens -> AnyPublisher<Response, MoyaError> in
                guard let self else {
                    return Fail(error: MoyaError.underlying(URLError(.unknown), nil)).eraseToAnyPublisher()
                }
                KeychainService.shared.saveTokens(
                    access: tokens.payload.accessToken,
                    refresh: tokens.payload.refreshToken
                )
                return self.executeRequest(target)
            }
            .eraseToAnyPublisher()
    }

    private func handleAuthFailure() -> AnyPublisher<Response, MoyaError> {
        DispatchQueue.main.async {
            KeychainService.shared.clear()
            AuthenticationService.shared.status = .unauthenticated
        }
        return Fail(error: MoyaError.underlying(URLError(.userAuthenticationRequired), nil))
            .eraseToAnyPublisher()
    }

    private func requestVoid(_ target: API) -> AnyPublisher<Void, MoyaError> {
        return networking.provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Auth

extension APIManager {
    func sendOtp(phone: String) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.sendOtp(phone: phone), type: MessageResponse.self)
    }

    func verifyOtp(phone: String, code: String) -> AnyPublisher<OtpVerifyResponse, MoyaError> {
        requestObject(.verifyOtp(phone: phone, code: code), type: OtpVerifyResponse.self)
    }

    func setPin(sessionToken: String, pin: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        requestObject(.setPin(sessionToken: sessionToken, pin: pin), type: AuthTokensResponse.self)
    }

    func verifyPin(sessionToken: String, pin: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        requestObject(.verifyPin(sessionToken: sessionToken, pin: pin), type: AuthTokensResponse.self)
    }

    func refreshTokens(refreshToken: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        requestObject(.refreshTokens(refreshToken: refreshToken), type: AuthTokensResponse.self)
    }

    func logout(sessionToken: String) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.logout(sessionToken: sessionToken), type: MessageResponse.self)
    }
}

// MARK: - Profile

extension APIManager {
    func getProfile() -> AnyPublisher<ProfileResponse, MoyaError> {
        requestObject(.getProfile, type: ProfileResponse.self)
    }

    func updateProfile(
        fullName: String? = nil,
        email: String? = nil,
        language: String? = nil
    ) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(
            .updateProfile(fullName: fullName, email: email, language: language),
            type: MessageResponse.self
        )
    }
}

// MARK: - Wallet

extension APIManager {
    func getWallet() -> AnyPublisher<WalletResponse, MoyaError> {
        requestObject(.getWallet, type: WalletResponse.self)
    }

    func topUpWallet(paymentMethodId: Int, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.topUpWallet(paymentMethodId: paymentMethodId, amount: amount), type: MessageResponse.self)
    }

    func sendWallet(phone: String, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.sendWallet(phone: phone, amount: amount), type: MessageResponse.self)
    }

    func getWalletActivity() -> AnyPublisher<TransactionListResponse, MoyaError> {
        requestObject(.getWalletActivity, type: TransactionListResponse.self)
    }
}

// MARK: - Payment Methods

extension APIManager {
    func listPaymentMethods() -> AnyPublisher<PaymentMethodListResponse, MoyaError> {
        requestObject(.listPaymentMethods, type: PaymentMethodListResponse.self)
    }

    func addPaymentMethod(
        cardSuffix: String,
        cardType: String,
        balance: Int? = nil
    ) -> AnyPublisher<PaymentMethodResponse, MoyaError> {
        requestObject(
            .addPaymentMethod(cardSuffix: cardSuffix, cardType: cardType, balance: balance),
            type: PaymentMethodResponse.self
        )
    }

    func deletePaymentMethod(id: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.deletePaymentMethod(id: id), type: MessageResponse.self)
    }
}

// MARK: - Funds

extension APIManager {
    func createFund(name: String, apy: Double? = nil) -> AnyPublisher<FundResponse, MoyaError> {
        requestObject(.createFund(name: name, apy: apy), type: FundResponse.self)
    }

    func listFunds() -> AnyPublisher<FundListResponse, MoyaError> {
        requestObject(.listFunds, type: FundListResponse.self)
    }

    func getFund(id: Int) -> AnyPublisher<FundResponse, MoyaError> {
        requestObject(.getFund(id: id), type: FundResponse.self)
    }

    func listFundMembers(fundId: Int) -> AnyPublisher<FundMemberListResponse, MoyaError> {
        requestObject(.listFundMembers(fundId: fundId), type: FundMemberListResponse.self)
    }

    func inviteFundMember(fundId: Int, phone: String) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.inviteFundMember(fundId: fundId, phone: phone), type: MessageResponse.self)
    }

    func topUpFund(fundId: Int, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.topUpFund(fundId: fundId, amount: amount), type: MessageResponse.self)
    }

    func getFundActivity(fundId: Int) -> AnyPublisher<TransactionListResponse, MoyaError> {
        requestObject(.getFundActivity(fundId: fundId), type: TransactionListResponse.self)
    }

    func getFundReport(fundId: Int) -> AnyPublisher<ReportResponse, MoyaError> {
        requestObject(.getFundReport(fundId: fundId), type: ReportResponse.self)
    }
}

// MARK: - Withdrawal Requests

extension APIManager {
    func createWithdrawal(
        fundId: Int,
        amount: Int,
        toPaymentId: Int? = nil
    ) -> AnyPublisher<WithdrawalRequestResponse, MoyaError> {
        requestObject(
            .createWithdrawal(fundId: fundId, amount: amount, toPaymentId: toPaymentId),
            type: WithdrawalRequestResponse.self
        )
    }

    func listWithdrawals(fundId: Int) -> AnyPublisher<WithdrawalListResponse, MoyaError> {
        requestObject(.listWithdrawals(fundId: fundId), type: WithdrawalListResponse.self)
    }

    func approveWithdrawal(fundId: Int, requestId: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.approveWithdrawal(fundId: fundId, requestId: requestId), type: MessageResponse.self)
    }

    func rejectWithdrawal(fundId: Int, requestId: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.rejectWithdrawal(fundId: fundId, requestId: requestId), type: MessageResponse.self)
    }
}

// MARK: - Notifications

extension APIManager {
    func listNotifications() -> AnyPublisher<NotificationListResponse, MoyaError> {
        requestObject(.listNotifications, type: NotificationListResponse.self)
    }

    func markNotificationRead(id: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.markNotificationRead(id: id), type: MessageResponse.self)
    }
}

// MARK: - System

extension APIManager {
    func ping() -> AnyPublisher<MessageResponse, MoyaError> {
        requestObject(.ping, type: MessageResponse.self)
    }
}
