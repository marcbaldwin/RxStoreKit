import RxSwift
import StoreKit

public extension Reactive where Base : SKPaymentQueue {

    public var transactions: Observable<SKPaymentTransaction> {
        return Observable.create { observer  in
            let observable = SKPaymentQueueObserver(observer: observer)
            self.base.add(observable)
            return Disposables.create {
                self.base.remove(observable)
            }
        }
    }
}

private class SKPaymentQueueObserver: NSObject {

    fileprivate let observer: AnyObserver<SKPaymentTransaction>

    init(observer: AnyObserver<SKPaymentTransaction>) {
        self.observer = observer
        super.init()
    }
}

extension SKPaymentQueueObserver: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            observer.onNext(transaction)
        }
    }
}
