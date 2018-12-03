import Moya
import RxSwift
import StoreKit

public final class ReceiptValidator {

    private let secret: String
    private let receiptApi = MoyaProvider<ReceiptAPI>()

    public init(secret: String) {
        self.secret = secret
    }

    public func verifySubscription(productIds: [String], forceRefresh: Bool = false, production: Bool = true) -> Observable<ReceiptItem?> {
        return receiptData(forceRefresh: forceRefresh)
            .flatMap { receipt in self.verify(receipt: receipt, production: production) }
            .flatMap { result -> Observable<ReceiptItem?> in
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

    private func receiptData(forceRefresh: Bool) -> Observable<Data> {
        if !forceRefresh, let receiptData = receiptData() {
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

    private func verify(receipt: Data, production: Bool) -> Observable<ReceiptResult> {
        return receiptApi.rx.request(.verifyReciept(receiptData: receipt, secret: secret, production: production))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .map { response in try JSONDecoder().decode(ReceiptResult.self, from: response.data) }
    }

    private func receiptData() -> Data? {
        return try? Data(contentsOf: Bundle.main.appStoreReceiptURL!)
    }
}

extension Array where Element == ReceiptItem {

    func latestValidReceipt(productIds: [String]) -> ReceiptItem? {
        return filter { productIds.contains($0.productId) && $0.subscriptionExpiryDate != nil }
            .sorted { a, b in a.subscriptionExpiryDate! > b.subscriptionExpiryDate! }
            .first
    }
}
