import RxSwift
import StoreKit

public extension SKProduct {

    class func fetch(_ productIds: [String]) -> Observable<[SKProduct]> {
        return Observable.create { observer in
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
    private let observer: AnyObserver<[SKProduct]>

    init(productIds: [String], observer: AnyObserver<[SKProduct]>) {
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
            observer.onNext(response.products)
            observer.onCompleted()
        } else {
            observer.onError(NSError(domain: "Invalid", code: 0, userInfo: nil))
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        observer.onError(error)
    }
}
