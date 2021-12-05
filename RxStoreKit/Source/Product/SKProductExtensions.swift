import StoreKit

public extension SKProduct {

    var localizedPrice: String? {
        let priceFormatter = NumberFormatter()
        priceFormatter.formatterBehavior = .behavior10_4
        priceFormatter.numberStyle = .currency
        priceFormatter.locale = priceLocale
        return priceFormatter.string(from: price)
    }
}
