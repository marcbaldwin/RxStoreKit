import RxSwift
import StoreKit

public extension SKProduct {

    class func fetch(_ productIds: [String]) -> Single<[SKProduct]> {
        .create { observer in
            let observable = ProductRequestObservable(productIds: productIds, observer: observer)
            return Disposables.create {
                observable.cancel()
            }
        }
    }

    func purchase() {
        SKPaymentQueue.default().add(SKPayment(product: self))
    }
}

private final class ProductRequestObservable: NSObject {

    private let request: SKProductsRequest
    private let observer: (Result<[SKProduct], Error>) -> Void

    init(productIds: [String], observer: @escaping (Result<[SKProduct], Error>) -> Void) {
        self.request = SKProductsRequest(productIdentifiers: Set(productIds))
        self.observer = observer
        super.init()
        request.delegate = self
        request.start()
    }

    func cancel() {
        request.delegate = nil
        request.cancel()
    }
}

extension ProductRequestObservable: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.invalidProductIdentifiers.isEmpty {
            observer(.success(response.products))
        } else {
            observer(.failure(NSError(domain: "Invalid", code: 0, userInfo: nil)))
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        observer(.failure(error))
    }
}
