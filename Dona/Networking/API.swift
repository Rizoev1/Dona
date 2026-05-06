//
//  API.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Moya
import Foundation
import UIKit
import Alamofire

enum API {
    case sendOtp(phone: String)
    case verifyOtp(phone: String, code: String)
    case getProfile
    case updateProfile(fullName: String?, email: String?, language: String?)
    case getWallet
    case topUpWallet(paymentMethodId: Int, amount: Int)
    case sendWallet(phone: String, amount: Int)
    case getWalletActivity
    case listPaymentMethods
    case addPaymentMethod(cardSuffix: String, cardType: String, balance: Int?)
    case deletePaymentMethod(id: Int)
    case createFund(name: String, apy: Double?)
    case listFunds
    case getFund(id: Int)
    case listFundMembers(fundId: Int)
    case inviteFundMember(fundId: Int, phone: String)
    case topUpFund(fundId: Int, amount: Int)
    case getFundActivity(fundId: Int)
    case getFundReport(fundId: Int)
    case createWithdrawal(fundId: Int, amount: Int, toPaymentId: Int?)
    case listWithdrawals(fundId: Int)
    case approveWithdrawal(fundId: Int, requestId: Int)
    case rejectWithdrawal(fundId: Int, requestId: Int)
    case listNotifications
    case markNotificationRead(id: Int)
    case ping
}

extension API: TargetType {
    var baseURL: URL { URL(string: "https://api.donaapp.tj/api")! }

    var path: String {
        switch self {
        case .sendOtp:
            return "/auth/otp/send"
        case .verifyOtp:
            return "/auth/otp/verify"
        case .getProfile, .updateProfile:
            return "/profile"
        case .getWallet:
            return "/wallet"
        case .topUpWallet:
            return "/wallet/topup"
        case .sendWallet:
            return "/wallet/send"
        case .getWalletActivity:
            return "/wallet/activity"
        case .listPaymentMethods, .addPaymentMethod:
            return "/payment-methods"
        case .deletePaymentMethod(let id):
            return "/payment-methods/\(id)"
        case .createFund, .listFunds:
            return "/funds"
        case .getFund(let id):
            return "/funds/\(id)"
        case .listFundMembers(let fundId):
            return "/funds/\(fundId)/members"
        case .inviteFundMember(let fundId, _):
            return "/funds/\(fundId)/invite"
        case .topUpFund(let fundId, _):
            return "/funds/\(fundId)/topup"
        case .getFundActivity(let fundId):
            return "/funds/\(fundId)/activity"
        case .getFundReport(let fundId):
            return "/funds/\(fundId)/report"
        case .createWithdrawal(let fundId, _, _), .listWithdrawals(let fundId):
            return "/funds/\(fundId)/requests"
        case .approveWithdrawal(let fundId, let requestId):
            return "/funds/\(fundId)/requests/\(requestId)/approve"
        case .rejectWithdrawal(let fundId, let requestId):
            return "/funds/\(fundId)/requests/\(requestId)/reject"
        case .listNotifications:
            return "/notifications"
        case .markNotificationRead(let id):
            return "/notifications/\(id)/read"
        case .ping:
            return "/ping"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProfile, .getWallet, .getWalletActivity, .listPaymentMethods,
             .listFunds, .getFund, .listFundMembers, .getFundActivity,
             .getFundReport, .listWithdrawals, .listNotifications, .ping:
            return .get

        case .sendOtp, .verifyOtp, .topUpWallet, .sendWallet, .addPaymentMethod,
             .createFund, .inviteFundMember, .topUpFund, .createWithdrawal:
            return .post

        case .updateProfile, .approveWithdrawal, .rejectWithdrawal, .markNotificationRead:
            return .put

        case .deletePaymentMethod:
            return .delete
        }
    }

    var task: Moya.Task {
        let jsonEncoding = JSONEncoding.default
        let queryEncoding = URLEncoding.queryString

        switch self {
        // Parameterless
        case .getProfile, .getWallet, .getWalletActivity, .listPaymentMethods,
             .listFunds, .getFund, .listFundMembers, .getFundActivity,
             .getFundReport, .listWithdrawals, .listNotifications,
             .deletePaymentMethod, .approveWithdrawal, .rejectWithdrawal,
             .markNotificationRead, .ping:
            return .requestPlain

        case let .sendOtp(phone):
            return .requestParameters(
                parameters: ["phone": phone],
                encoding: jsonEncoding
            )

        case let .verifyOtp(phone, code):
            return .requestParameters(
                parameters: ["phone": phone, "code": code],
                encoding: jsonEncoding
            )

        case let .updateProfile(fullName, email, language):
            var params: [String: Any] = [:]
            if let fullName { params["full_name"] = fullName }
            if let email { params["email"] = email }
            if let language { params["language"] = language }
            return params.isEmpty ? .requestPlain : .requestParameters(parameters: params, encoding: jsonEncoding)

        case let .topUpWallet(paymentMethodId, amount):
            return .requestParameters(
                parameters: ["payment_method_id": paymentMethodId, "amount": amount],
                encoding: jsonEncoding
            )

        case let .sendWallet(phone, amount):
            return .requestParameters(
                parameters: ["phone": phone, "amount": amount],
                encoding: jsonEncoding
            )

        case let .addPaymentMethod(cardSuffix, cardType, balance):
            var params: [String: Any] = ["card_suffix": cardSuffix, "card_type": cardType]
            if let balance { params["balance"] = balance }
            return .requestParameters(parameters: params, encoding: jsonEncoding)

        case let .createFund(name, apy):
            var params: [String: Any] = ["name": name]
            if let apy { params["apy"] = apy }
            return .requestParameters(parameters: params, encoding: jsonEncoding)

        case let .inviteFundMember(_, phone):
            return .requestParameters(
                parameters: ["phone": phone],
                encoding: jsonEncoding
            )

        case let .topUpFund(_, amount):
            return .requestParameters(
                parameters: ["amount": amount],
                encoding: jsonEncoding
            )

        case let .createWithdrawal(_, amount, toPaymentId):
            var params: [String: Any] = ["amount": amount]
            if let toPaymentId { params["to_payment_id"] = toPaymentId }
            return .requestParameters(parameters: params, encoding: jsonEncoding)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
