import Flutter
import UIKit
    
public class SwiftFlutterIapPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_iap", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterIapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "inventory":
      result("{\"status\":\"loaded\",\"purchases\":[]}")
    case "fetch":
      IAPHandler.shared.purchaseStatusBlock = result
      IAPHandler.shared.fetchAvailableProducts(call.arguments as! [String], result)
    case "buy":
      IAPHandler.shared.purchaseStatusBlock = result
      IAPHandler.shared.purchaseMyProduct(call.arguments as! String)
    case "restore":
        IAPHandler.shared.purchaseStatusBlock = result
        IAPHandler.shared.restorePurchase()
    default:
      break
    }
  }
}

import StoreKit

class IAPHandler: NSObject {
  static var shared = IAPHandler()
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
  fileprivate var iapProducts = [String : SKProduct]()
    
    // temporary variable to hold the restored IDs.
  fileprivate var restoredIds : [String] = []
    
  var purchaseStatusBlock: ((String) -> Void)?
  
  func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
  
  func purchaseMyProduct(_ id: String) {
    if iapProducts.count == 0 {
      purchaseStatusBlock?(jsonFromString(status: "emptyProducts"))
      return
    }
    
    if self.canMakePurchases() {
      let product = iapProducts[id]!
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)
      
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?(jsonFromString(status: "disabled"))
    }
  }
  
  func restorePurchase() {
    restoredIds.removeAll()
    
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func fetchAvailableProducts(_ ids: [String], _ completion: ([Any]) -> ()) {
    productsRequest = SKProductsRequest(productIdentifiers: Set(ids))
    productsRequest.delegate = self
    productsRequest.start()
  }
    
    func jsonFromString(status: String) -> String{
        return "{\"status\":\"\(status)\"}"
    }
    
    func jsonFromError(_ error: Error) -> String{
        return "{\"status\":\"failed\",\"message\":\"\(error.localizedDescription)\"}"
    }
    
    func jsonFromProduct(product: SKProduct) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        let formattedPrice = numberFormatter.string(from: product.price) ?? ""
        
        var result: String =  "{\"localizedDescription\":\"\(product.localizedDescription)\""
        result.append(",\"localizedTitle\":\"\(product.localizedTitle)\"")
        result.append(",\"price\":\"\(product.price)\"")
        result.append(",\"priceLocale\":\"\(product.priceLocale)\"")
        result.append(",\"localizedPrice\":\"\(formattedPrice)\"")
        result.append(",\"productIdentifier\":\"\(product.productIdentifier)\"")
        result.append(",\"downloadContentLengths\":\"\(product.downloadContentLengths)\"")
        result.append(",\"downloadContentVersion\":\"\(product.downloadContentVersion)\"}")
        return result
    }
}

extension IAPHandler: SKProductsRequestDelegate {
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        var products: [String] = []
        for product in response.products {
            iapProducts[product.productIdentifier] = product
            products.append(jsonFromProduct(product: product))
        }
        for ip in response.invalidProductIdentifiers {
            NSLog("invalid product identifier: \(ip)")
        }
        
        purchaseStatusBlock?("{\"status\":\"loaded\",\"products\":[\(products.joined(separator: ","))]}")
    }
}

extension IAPHandler: SKPaymentTransactionObserver {
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    purchaseStatusBlock?("{\"status\":\"loaded\",\"purchases\":[" + restoredIds.joined(separator: ",") + "]}")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        purchaseStatusBlock?(jsonFromError(error))
    }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction:AnyObject in transactions {
      if let trans = transaction as? SKPaymentTransaction {
        switch trans.transactionState {
          case .purchased:
            SKPaymentQueue.default().finishTransaction(trans)

            let productIds = [ "{\"productIdentifier\": \"\(trans.payment.productIdentifier)\"}" ]

            purchaseStatusBlock?("{\"status\":\"loaded\",\"purchases\":[" + productIds.joined(separator: ",") + "]}")
            break
          case .failed:
            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
            purchaseStatusBlock?(jsonFromString(status: "failed"))
            break
          case .restored:
            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
            restoredIds.append("{\"productIdentifier\": \"\(trans.payment.productIdentifier)\"}")
            break
        default: 
          break
        }
      }
    }
  }
}

