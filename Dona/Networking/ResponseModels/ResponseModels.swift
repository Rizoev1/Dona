//
//  ResponseModels.swift
//  Dona
//
//  Created by Damir.Rizoev on 06/05/26.
//

import Foundation

// ─────────────────────────────────────────────
// MARK: - Shared
// ─────────────────────────────────────────────

struct MessageResponse: Decodable {
    let message: String
    let payload: String?
}

// ─────────────────────────────────────────────
// MARK: - Auth
// ─────────────────────────────────────────────

enum PinCommand: String, Decodable {
    case setPin   = "SET_PIN"
    case checkPin = "CHECK_PIN"
}

// Returned by verifyOtp — temporary token used for setPin / verifyPin
struct OtpVerifyResponse: Decodable {
    let message: String
    let payload: Payload

    struct Payload: Decodable {
        let command: PinCommand
        let sessionToken: String

        enum CodingKeys: String, CodingKey {
            case command
            case sessionToken = "session_token"
        }
    }
}

// Returned by setPin / verifyPin / refreshTokens
struct AuthTokensResponse: Decodable {
    let message: String
    let payload: AuthTokens

    struct AuthTokens: Decodable {
        let accessToken: String
        let refreshToken: String

        enum CodingKeys: String, CodingKey {
            case accessToken  = "access_token"
            case refreshToken = "refresh_token"
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Profile
// ─────────────────────────────────────────────

struct ProfileResponse: Decodable {
    let message: String
    let payload: Profile

    struct Profile: Decodable {
        let id: Int
        let phone: String
        let fullName: String
        let email: String
        let avatarUrl: String
        let language: String

        enum CodingKeys: String, CodingKey {
            case id
            case phone
            case fullName  = "full_name"
            case email
            case avatarUrl = "avatar_url"
            case language
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Wallet
// ─────────────────────────────────────────────

struct WalletResponse: Decodable {
    let message: String
    let payload: Wallet

    struct Wallet: Decodable {
        /// Баланс в дирамах (1 TJS = 100 дирам)
        let balance: Int
        /// Последние 4 цифры кошелька
        let cardSuffix: String

        enum CodingKeys: String, CodingKey {
            case balance
            case cardSuffix = "card_suffix"
        }
    }
}

struct TransactionListResponse: Decodable {
    let message: String
    let payload: [Transaction]

    struct Transaction: Decodable {
        let id: Int
        let type: TransactionType
        /// Сумма в дирамах
        let amount: Int
        let fee: Int
        let senderType: String
        let senderId: Int
        let receiverType: String
        let receiverId: Int
        let description: String
        let createdAt: String

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case amount
            case fee
            case senderType   = "sender_type"
            case senderId     = "sender_id"
            case receiverType = "receiver_type"
            case receiverId   = "receiver_id"
            case description
            case createdAt    = "created_at"
        }
    }

    enum TransactionType: String, Decodable {
        case topup        = "topup"
        case send         = "send"
        case contribution = "contribution"
        case disbursement = "disbursement"
    }
}

// ─────────────────────────────────────────────
// MARK: - Payment Methods
// ─────────────────────────────────────────────

struct PaymentMethodListResponse: Decodable {
    let message: String
    let payload: [PaymentMethod]
}

struct PaymentMethodResponse: Decodable {
    let message: String
    let payload: PaymentMethod
}

struct PaymentMethod: Decodable {
    let id: Int
    let userId: Int
    /// Последние 4 цифры карты
    let cardSuffix: String
    let cardType: CardType
    /// Баланс в дирамах
    let balance: Int
    let isDefault: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId     = "user_id"
        case cardSuffix = "card_suffix"
        case cardType   = "card_type"
        case balance
        case isDefault  = "is_default"
        case createdAt  = "created_at"
    }

    enum CardType: String, Decodable {
        case visa       = "visa"
        case mastercard = "mastercard"
    }
}

// ─────────────────────────────────────────────
// MARK: - Funds
// ─────────────────────────────────────────────

struct FundResponse: Decodable {
    let message: String
    let payload: Fund
}

struct FundListResponse: Decodable {
    let message: String
    let payload: [Fund]
}

struct Fund: Decodable, Hashable {
    let id: Int
    let name: String
    let balance: Int
    let apy: Double
    let status: String
    let memberCount: Int
    let role: FundRole

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case balance
        case apy
        case status
        case memberCount = "member_count"
        case role
    }

    enum FundRole: String, Decodable {
        case admin  = "admin"
        case member = "member"
    }
}

extension Fund: Identifiable {
    var balanceFormatted: String {
        String(format: "%.2f", Double(balance) / 100.0)
    }

    var apyFormatted: String {
        String(format: "Earns %.1f%% APY", apy)
    }
}

struct FundMemberListResponse: Decodable {
    let message: String
    let payload: [FundMember]

    struct FundMember: Decodable {
        let userId: Int
        let fullName: String
        let phone: String
        let role: Fund.FundRole

        enum CodingKeys: String, CodingKey {
            case userId   = "user_id"
            case fullName = "full_name"
            case phone
            case role
        }
    }
}

struct ReportResponse: Decodable {
    let message: String
    let payload: Report

    struct Report: Decodable {
        let contributions: Int
        let disbursements: Int
        let netGrowth: Int
        let growthPercent: Double

        enum CodingKeys: String, CodingKey {
            case contributions
            case disbursements
            case netGrowth     = "net_growth"
            case growthPercent = "growth_percent"
        }
    }
}

// ─────────────────────────────────────────────
// MARK: - Withdrawal Requests
// ─────────────────────────────────────────────

struct WithdrawalRequestResponse: Decodable {
    let message: String
    let payload: WithdrawalRequest
}

struct WithdrawalListResponse: Decodable {
    let message: String
    let payload: [WithdrawalRequest]
}

struct WithdrawalRequest: Decodable {
    let id: Int
    let fundId: Int
    let userId: Int
    let toPaymentId: Int
    let amount: Int
    let fee: Int
    let status: WithdrawalStatus
    let reviewedBy: Int?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case fundId      = "fund_id"
        case userId      = "user_id"
        case toPaymentId = "to_payment_id"
        case amount
        case fee
        case status
        case reviewedBy  = "reviewed_by"
        case createdAt   = "created_at"
        case updatedAt   = "updated_at"
    }

    enum WithdrawalStatus: String, Decodable {
        case pending  = "pending"
        case approved = "approved"
        case rejected = "rejected"
    }
}

extension WithdrawalRequest {
    var amountFormatted: String {
        String(format: "%.2f", Double(amount) / 100.0)
    }

    var feeFormatted: String {
        String(format: "%.2f TJS", Double(fee) / 100.0)
    }

    var shortDate: String {
        let withFractional = ISO8601DateFormatter()
        withFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let standard = ISO8601DateFormatter()
        standard.formatOptions = [.withInternetDateTime]
        let date = withFractional.date(from: createdAt) ?? standard.date(from: createdAt)
        guard let date else { return createdAt }
        let fmt = DateFormatter()
        fmt.dateFormat = "dd.MM"
        return fmt.string(from: date)
    }
}

// ─────────────────────────────────────────────
// MARK: - Notifications
// ─────────────────────────────────────────────

struct NotificationListResponse: Decodable {
    let message: String
    let payload: [AppNotification]
}

struct AppNotification: Decodable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    let isRead: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId    = "user_id"
        case title
        case body
        case isRead    = "is_read"
        case createdAt = "created_at"
    }
}
