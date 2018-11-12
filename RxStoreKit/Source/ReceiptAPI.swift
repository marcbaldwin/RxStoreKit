import Moya

public enum ReceiptAPI {
    case verifyReciept(receiptData: Data, secret: String, production: Bool)
}

extension ReceiptAPI: TargetType {

    public var baseURL: URL {
        switch self {
        case let .verifyReciept(_, _, production):
            let prefix = production ? "buy" : "sandbox"
            return URL(string: "https://\(prefix).itunes.apple.com/")!
        }
    }

    public var path: String {
        return "verifyReceipt"
    }

    public var method: Moya.Method {
        return .post
    }

    public var sampleData: Data {
        return "".data(using: .utf8)!
    }

    public var task: Moya.Task {
        switch self {
        case let .verifyReciept(receiptData, secret, _):
            let params: [String: Any] = [
                "receipt-data": receiptData.base64EncodedString(options: []),
                "password": secret
            ]
            let data = try! JSONSerialization.data(withJSONObject: params, options: [])
            return .requestData(data)
        }
    }

    public var headers: [String: String]? {
        return nil
    }
}
