import Foundation

public struct ReceiptResult: Decodable {

    public let status: Int
    public let latestReceipts: [ReceiptItem]?

    enum CodingKeys: String, CodingKey {
        case status
        case latestReceipts = "latest_receipt_info"
    }
}

public struct ReceiptItem: Decodable {

    public let productId: String
    public let quantity: String
    public let transactionId: String
    public let originalTransactionId: String
    public let purchaseDateInterval: String
    public let originalPurchaseDateInterval: String
    public let subscriptionExpiryDateInterval: String?
    public let cancellationDateInterval: String?
    public let isTrialPeriod: String
    public let webOrderLineItemId: String?

    public var subscriptionExpiryDate: Date? {
        guard
            let timeIntervalString = subscriptionExpiryDateInterval,
            let expiryTimeInterval = Double(timeIntervalString)
        else { return nil }
        return Date(timeIntervalSince1970: expiryTimeInterval / 1000)
    }

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case quantity = "quantity"
        case transactionId = "transaction_id"
        case originalTransactionId = "original_transaction_id"
        case purchaseDateInterval = "purchase_date_ms"
        case originalPurchaseDateInterval = "original_purchase_date_ms"
        case subscriptionExpiryDateInterval = "expires_date_ms"
        case cancellationDateInterval = "cancellation_date_ms"
        case isTrialPeriod = "is_trial_period"
        case webOrderLineItemId = "web_order_line_item_id"
    }
}
