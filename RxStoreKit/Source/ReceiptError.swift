import Foundation

public enum ReceiptError: Error {
    case receiptMissing
    case receiptVerificationFailed(statusCode: Int)
}
