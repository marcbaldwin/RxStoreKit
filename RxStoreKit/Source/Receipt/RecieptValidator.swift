import RxSwift
import StoreKit

public final class ReceiptValidator {

    private let secret: String
    private let receiptApi = ReceiptAPI()

    public init(secret: String) {
        self.secret = secret
    }

    public func verifySubscription(productIds: [String], forceRefresh: Bool = false, production: Bool = true) -> Single<ReceiptItem?> {
        receiptData(forceRefresh: forceRefresh)
            .flatMap { receipt in self.verify(receipt: receipt, production: production) }
            .flatMap { result -> Single<ReceiptItem?> in
                switch result.status {
                case 0:
                    return .just(result.latestReceipts?.latestValidReceipt(productIds: productIds))

                case 21007:
                    return self.verifySubscription(productIds: productIds, production: false)

                default:
                    throw ReceiptError.receiptVerificationFailed(statusCode: result.status)
                }
            }
    }

    private func receiptData(forceRefresh: Bool) -> Single<Data> {
        .deferred {
            if !forceRefresh, let receiptData = self.receiptData() {
                return .just(receiptData)
            } else {
                return SKReceiptRefreshRequest().rx.observe
                    .map { _ in
                        guard let receiptData = self.receiptData() else {
                            throw ReceiptError.receiptMissing
                        }
                        return receiptData
                    }
            }
        }
    }

    private func verify(receipt: Data, production: Bool) -> Single<ReceiptResult> {
        receiptApi.verifyReciept(receiptData: receipt, secret: secret, production: production)
    }

    private func receiptData() -> Data? {
        try? Data(contentsOf: Bundle.main.appStoreReceiptURL!)
    }
}

extension Array where Element == ReceiptItem {

    func latestValidReceipt(productIds: [String]) -> ReceiptItem? {
        filter { productIds.contains($0.productId) && $0.subscriptionExpiryDate != nil }
            .sorted { a, b in a.subscriptionExpiryDate! > b.subscriptionExpiryDate! }
            .first
    }
}
