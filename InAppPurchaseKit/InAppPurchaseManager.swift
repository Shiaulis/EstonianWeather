//
//  InAppPurchaseManager.swift
//  EstonianWeather
//
//  Created by Andrius Shiaulis on 23.02.2021.
//

import StoreKit
import LoggerKit

public struct Product {
    public var localizedTitle: String { self.storeKitProduct.localizedTitle }
    public var localizedPrice: String { self.storeKitProduct.localizedPrice }

    fileprivate let storeKitProduct: SKProduct

    init(product: SKProduct) {
        self.storeKitProduct = product
    }
}

public final class InAppPurchaseManager: NSObject {

    public typealias ProductRequestCompletion = (Result<[Product], Swift.Error>) -> Void
    public typealias ProductPurchaseCompletion = (Swift.Error?) -> Void

    private let inAppPurchaseIdentifiers: Set<String>
    private let logger: Logger

    private var productRequestCompletion: ProductRequestCompletion?

    public init(inAppPurchaseIdentifiers: [String], logger: Logger) {
        self.inAppPurchaseIdentifiers = Set(inAppPurchaseIdentifiers)
        self.logger = logger
        super.init()
    }

    public func getProducts(completion: @escaping ProductRequestCompletion) {
        guard self.productRequestCompletion == nil else {
            completion(.failure(Error.anotherPurchaseInProgress))
            return
        }

        self.productRequestCompletion = completion
        let request = SKProductsRequest(productIdentifiers: self.inAppPurchaseIdentifiers)
        request.delegate = self
        request.start()
    }

    public func purchase(product: Product, completion: ProductPurchaseCompletion) {
        guard SKPaymentQueue.canMakePayments() else {
            completion(Error.storeKitQueueCannotMakePurchase)
            return
        }

        SKPaymentQueue.default().add(.init(product: product.storeKitProduct))
    }

}

extension InAppPurchaseManager {
    public enum Error: Swift.Error {
        case anotherPurchaseInProgress
        case storeKitQueueCannotMakePurchase
    }
}

extension InAppPurchaseManager: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let completion = self.productRequestCompletion else {
            assertionFailure("No expected callback while completion is nil")
            return
        }

        let incorrectProducts = response.invalidProductIdentifiers
        let correctProducts = response.products

        if !correctProducts.isEmpty {
            self.logger.log(information: "Found \(correctProducts.count) available purchases", module: .purchases)
        }
        else {
            self.logger.log(information: "Didn't found any available purchases", module: .purchases)
        }

        if !incorrectProducts.isEmpty {
            self.logger.log(information: "Found \(incorrectProducts.count) unavailable purchases", module: .purchases)
        }

        completion(.success(correctProducts.map { .init(product: $0) }))
    }

    public func request(_ request: SKRequest, didFailWithError error: Swift.Error) {
        guard let completion = self.productRequestCompletion else {
            assertionFailure("No expected callback while completion is nil")
            return
        }

        completion(.failure(error))
        self.logger.log(message: "Failed request product request", error: error, module: .purchases)
    }

    public func requestDidFinish(_ request: SKRequest) {
        self.logger.log(information: "Request product finished", module: .purchases)
    }

}

extension SKProduct {

    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }

}
