
# RxStoreKit
RxSwift wrapper for StoreKit.

#### Fetch products

```Swift
SKProduct.fetch(["my.product.id", "my.other.product.id"])
    .subscribe(
      onNext: { products: [SKProduct] in
        // display products
      },
      onError: { error in
        // handle the error
      }
    )
    .disposed(by: disposeBag)
```

#### Observe the payment queue

```Swift
SKPaymentQueue.default().rx.transactionsUpdated
    .subscribe(onNext: { transactions: [SKPaymentTransaction] in
        // Unlock content?
    })
    .disposed(by: disposeBag)
```

#### Observe restore completed transactions

```Swift
SKPaymentQueue.default().rx.restoreCompletedTransactions()
    .subscribe(onNext: { transactions: [SKPaymentTransaction] in
        // Unlock content?
    })
    .disposed(by: disposeBag)
```

#### Verify receipts

```Swift
let receiptValidator = ReceiptValidator(secret: "my_secret_key")
receiptValidator.verifySubscription(productIds: ["my.product.id"])
    .subscribe(
      onNext: { receipt in
        // check expiry date of receipt
      },
      onError: { error in
        // handle the error
      }
    )
    .disposed(by: disposeBag)
```
