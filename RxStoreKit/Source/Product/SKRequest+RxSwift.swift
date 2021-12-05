import RxSwift
import StoreKit

public extension Reactive where Base: SKRequest {

    var observe: Single<SKRequest> {
        .deferred {
            .create { observer in
                let observable = SKRequestObserver(observer: observer, request: self.base)
                observable.start()
                return Disposables.create {
                    observable.cancel()
                }
            }
        }
    }
}

private class SKRequestObserver: NSObject {

    private let observer: (Result<SKRequest, Error>) -> Void
    private let request: SKRequest

    init(observer: @escaping (Result<SKRequest, Error>) -> Void, request: SKRequest) {
        self.observer = observer
        self.request = request
        super.init()
    }

    func start() {
        request.delegate = self
        request.start()
    }

    func cancel() {
        request.cancel()
    }
}

extension SKRequestObserver: SKRequestDelegate {

    func requestDidFinish(_ request: SKRequest) {
        observer(.success(request))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        observer(.failure(error))
    }
}
