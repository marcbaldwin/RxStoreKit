import Moya
import RxSwift
import StoreKit

public final class ReceiptValidator {

    private var receiptData: Data? {
        return try? Data(contentsOf: Bundle.main.appStoreReceiptURL!)
    }

    private var receiptDataObservable: Observable<Data> {
        if let receiptData = receiptData {
            return .just(receiptData)
        } else {
            return SKReceiptRefreshRequest().rx.observe
                .map { _ in
                    guard let receiptData = self.receiptData else {
                        throw ReceiptError.receiptMissing
                    }
                    return receiptData
                }
        }
    }

    private let secret: String
    private let receiptApi = MoyaProvider<ReceiptAPI>()

    public init(secret: String) {
        self.secret = secret
    }

    public func verifySubscription(productId: String, production: Bool = true) -> Observable<ReceiptItem?> {
        return receiptDataObservable
            .flatMap { [receiptApi] receiptData in
                receiptApi.rx.request(.verifyReciept(receiptData: receiptData, secret: self.secret, production: production))
            }
            .asObservable()
            .filterSuccessfulStatusCodes()
            .flatMap { response -> Observable<ReceiptItem?> in
                let result = try JSONDecoder().decode(ReceiptResult.self, from: response.data)

                if result.status == 21007 {
                    return self.verifySubscription(productId: productId, production: false)
                }

                guard result.status == 0 else {
                    throw ReceiptError.receiptVerificationFailed(statusCode: result.status)
                }

                let latestReceipt = result.latestReceipts?
                    .filter { $0.productId == productId && $0.subscriptionExpiryDate != nil }
                    .sorted { a, b in a.subscriptionExpiryDate! > b.subscriptionExpiryDate! }
                    .first

                return .just(latestReceipt)
            }
    }
}
