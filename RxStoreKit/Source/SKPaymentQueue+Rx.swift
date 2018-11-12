import RxSwift
import StoreKit

public extension Reactive where Base : SKPaymentQueue {

    public var transactions: Observable<[SKPaymentTransaction]> {
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

    private let observer: AnyObserver<[SKPaymentTransaction]>
    private var transactions = [SKPaymentTransaction]()

    init(observer: AnyObserver<[SKPaymentTransaction]>) {
        self.observer = observer
        super.init()
    }
}

extension SKPaymentQueueObserver: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var latestTransactions = self.transactions.filter { transaction in
            !transactions.contains(transaction)
        }
        latestTransactions += transactions

        self.transactions = latestTransactions

        observer.onNext(latestTransactions)
    }

    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        self.transactions = self.transactions.filter { transaction in
            !transactions.contains(transaction)
        }
        observer.onNext(self.transactions)
    }
}
