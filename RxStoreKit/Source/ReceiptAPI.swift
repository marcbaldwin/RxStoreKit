import Alamofire
import RxSwift

final class ReceiptAPI {

    func verifyReciept(receiptData: Data, secret: String, production: Bool) -> Single<ReceiptResult> {
        let prefix = production ? "buy" : "sandbox"
        let path = URL(string: "https://\(prefix).itunes.apple.com/verifyReceipt")!

        let params: [String: Any] = [
            "receipt-data": receiptData.base64EncodedString(options: []),
            "password": secret
        ]

//        let data = try! JSONSerialization.data(withJSONObject: params, options: [])
//        return .requestData(data)

        return Alamofire.Session.default
            .request(
                path,
                method: .post,
                parameters: params
            )
            .rx.responseData()
            .map { response in
                try JSONDecoder().decode(ReceiptResult.self, from: response.data)
            }
    }
}
