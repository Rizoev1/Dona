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

    private func request(_ target: API) -> AnyPublisher<Any, MoyaError> {
        return networking.provider.requestPublisher(target)
            .mapJSON()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func requestWithoutMapping(_ target: API) -> AnyPublisher<Response, MoyaError> {
        return networking.provider.requestPublisher(target)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func requestObject<T: Decodable>(
        _ target: API,
        type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, MoyaError> {
        return networking.provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map(T.self, using: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func requestArray<T: Decodable>(
        _ target: API,
        type: T.Type,
        using decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<[T], MoyaError> {
        return networking.provider.requestPublisher(target)
            .filterSuccessfulStatusCodes()
            .map([T].self, using: decoder)
            .receive(on: DispatchQueue.main)
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
        return requestObject(.sendOtp(phone: phone), type: MessageResponse.self)
    }

    func verifyOtp(phone: String, code: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        return requestObject(.verifyOtp(phone: phone, code: code), type: AuthTokensResponse.self)
    }
    
    func setPin(sessionToken: String, pin: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        return requestObject(.setPin(sessionToken: sessionToken, pin: pin), type: AuthTokensResponse.self)
    }

    func verifyPin(sessionToken: String, pin: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        return requestObject(.verifyPin(sessionToken: sessionToken, pin: pin), type: AuthTokensResponse.self)
    }

    func refreshTokens(refreshToken: String) -> AnyPublisher<AuthTokensResponse, MoyaError> {
        return requestObject(.refreshTokens(refreshToken: refreshToken), type: AuthTokensResponse.self)
    }

    func logout(sessionToken: String) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.logout(sessionToken: sessionToken), type: MessageResponse.self)
    }
}

// MARK: - Profile

extension APIManager {
    func getProfile() -> AnyPublisher<ProfileResponse, MoyaError> {
        return requestObject(.getProfile, type: ProfileResponse.self)
    }

    func updateProfile(
        fullName: String? = nil,
        email: String? = nil,
        language: String? = nil
    ) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(
            .updateProfile(fullName: fullName, email: email, language: language),
            type: MessageResponse.self
        )
    }
}

// MARK: - Wallet

extension APIManager {
    func getWallet() -> AnyPublisher<WalletResponse, MoyaError> {
        return requestObject(.getWallet, type: WalletResponse.self)
    }

    func topUpWallet(paymentMethodId: Int, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(
            .topUpWallet(paymentMethodId: paymentMethodId, amount: amount),
            type: MessageResponse.self
        )
    }

    func sendWallet(phone: String, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.sendWallet(phone: phone, amount: amount), type: MessageResponse.self)
    }

    func getWalletActivity() -> AnyPublisher<TransactionListResponse, MoyaError> {
        return requestObject(.getWalletActivity, type: TransactionListResponse.self)
    }
}

// MARK: - Payment Methods

extension APIManager {
    func listPaymentMethods() -> AnyPublisher<PaymentMethodListResponse, MoyaError> {
        return requestObject(.listPaymentMethods, type: PaymentMethodListResponse.self)
    }

    func addPaymentMethod(
        cardSuffix: String,
        cardType: String,
        balance: Int? = nil
    ) -> AnyPublisher<PaymentMethodResponse, MoyaError> {
        return requestObject(
            .addPaymentMethod(cardSuffix: cardSuffix, cardType: cardType, balance: balance),
            type: PaymentMethodResponse.self
        )
    }

    func deletePaymentMethod(id: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.deletePaymentMethod(id: id), type: MessageResponse.self)
    }
}

// MARK: - Funds

extension APIManager {
    func createFund(name: String, apy: Double? = nil) -> AnyPublisher<FundResponse, MoyaError> {
        return requestObject(.createFund(name: name, apy: apy), type: FundResponse.self)
    }

    func listFunds() -> AnyPublisher<FundListResponse, MoyaError> {
        return requestObject(.listFunds, type: FundListResponse.self)
    }

    func getFund(id: Int) -> AnyPublisher<FundResponse, MoyaError> {
        return requestObject(.getFund(id: id), type: FundResponse.self)
    }

    func listFundMembers(fundId: Int) -> AnyPublisher<FundMemberListResponse, MoyaError> {
        return requestObject(.listFundMembers(fundId: fundId), type: FundMemberListResponse.self)
    }

    func inviteFundMember(fundId: Int, phone: String) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.inviteFundMember(fundId: fundId, phone: phone), type: MessageResponse.self)
    }

    func topUpFund(fundId: Int, amount: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.topUpFund(fundId: fundId, amount: amount), type: MessageResponse.self)
    }

    func getFundActivity(fundId: Int) -> AnyPublisher<TransactionListResponse, MoyaError> {
        return requestObject(.getFundActivity(fundId: fundId), type: TransactionListResponse.self)
    }

    func getFundReport(fundId: Int) -> AnyPublisher<ReportResponse, MoyaError> {
        return requestObject(.getFundReport(fundId: fundId), type: ReportResponse.self)
    }
}

// MARK: - Withdrawal Requests

extension APIManager {
    func createWithdrawal(
        fundId: Int,
        amount: Int,
        toPaymentId: Int? = nil
    ) -> AnyPublisher<WithdrawalRequestResponse, MoyaError> {
        return requestObject(
            .createWithdrawal(fundId: fundId, amount: amount, toPaymentId: toPaymentId),
            type: WithdrawalRequestResponse.self
        )
    }

    func listWithdrawals(fundId: Int) -> AnyPublisher<WithdrawalListResponse, MoyaError> {
        return requestObject(.listWithdrawals(fundId: fundId), type: WithdrawalListResponse.self)
    }

    func approveWithdrawal(fundId: Int, requestId: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(
            .approveWithdrawal(fundId: fundId, requestId: requestId),
            type: MessageResponse.self
        )
    }

    func rejectWithdrawal(fundId: Int, requestId: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(
            .rejectWithdrawal(fundId: fundId, requestId: requestId),
            type: MessageResponse.self
        )
    }
}

// MARK: - Notifications

extension APIManager {
    func listNotifications() -> AnyPublisher<NotificationListResponse, MoyaError> {
        return requestObject(.listNotifications, type: NotificationListResponse.self)
    }

    func markNotificationRead(id: Int) -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.markNotificationRead(id: id), type: MessageResponse.self)
    }
}

// MARK: - System

extension APIManager {
    func ping() -> AnyPublisher<MessageResponse, MoyaError> {
        return requestObject(.ping, type: MessageResponse.self)
    }
}
