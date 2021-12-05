import RxSwift
import StoreKit

public extension Reactive where Base : SKPaymentQueue {

    var transactionsUpdated: Observable<[SKPaymentTransaction]> {
        return Observable.deferred {
            Observable.create { observer in
                let observable = TransactionsUpdatedObserver(observer: observer)
                self.base.add(observable)
                return Disposables.create {
                    self.base.remove(observable)
                }
            }
        }
    }

    func restoreCompletedTransactions() -> Single<[SKPaymentTransaction]> {
        .deferred {
            .create { observer in
                let observable = RestoreCompletedTransactionsObserver(observer: observer)
                self.base.add(observable)
                self.base.restoreCompletedTransactions()
                return Disposables.create {
                    self.base.remove(observable)
                }
            }
        }
    }
}

private class TransactionsUpdatedObserver: NSObject {

    private let observer: AnyObserver<[SKPaymentTransaction]>

    init(observer: AnyObserver<[SKPaymentTransaction]>) {
        self.observer = observer
        super.init()
    }
}

extension TransactionsUpdatedObserver: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        observer.onNext(transactions)
    }
}

private class RestoreCompletedTransactionsObserver: NSObject {

    private let observer: (Result<[SKPaymentTransaction], Error>) -> Void
    private var restoredTransactions = [SKPaymentTransaction]()

    init(observer: @escaping (Result<[SKPaymentTransaction], Error>) -> Void) {
        self.observer = observer
        super.init()
    }
}

extension RestoreCompletedTransactionsObserver: SKPaymentTransactionObserver {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        restoredTransactions += transactions
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        observer(.failure(error))
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        observer(.success(restoredTransactions))
    }
}
