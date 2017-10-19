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
    case "fetch":
      IAPHandler.shared.fetchResult = result
      IAPHandler.shared.fetchAvailableProducts(call.arguments as! [String], result)
    case "buy":
      IAPHandler.shared.purchaseStatusBlock = result
      IAPHandler.shared.purchaseMyProduct(call.arguments as! String)
    default:
      break
    }
  }
}

import StoreKit

class IAPHandler: NSObject {
  static var shared = IAPHandler()
  fileprivate var fetchResult : (([Any]) -> ())?
  fileprivate var productID = ""
  fileprivate var productsRequest = SKProductsRequest()
  fileprivate var iapProducts = [String : SKProduct]()
  
  var purchaseStatusBlock: ((String) -> Void)?
  
  func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
  
  func purchaseMyProduct(_ id: String) {
    if iapProducts.count == 0 {
      purchaseStatusBlock?("emptyProducts")
      return
    }
    
    if self.canMakePurchases() {
      let product = iapProducts[id]!
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)
      
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?("disabled")
    }
  }
  
  func restorePurchase() {
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func fetchAvailableProducts(_ ids: [String], _ completion: ([Any]) -> ()) {
    let productIdentifiers = NSSet(array: ids)
    
    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
    productsRequest.delegate = self
    productsRequest.start()
  }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
  func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
    if (response.products.count > 0) {
      var result : [String] = []
      for product in response.products {
        iapProducts[product.productIdentifier] = product
        result.append(product.productIdentifier)
      }
      if let fetchResult = fetchResult {
        fetchResult(result)
      }
      fetchResult = nil
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    purchaseStatusBlock?("restored")
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction:AnyObject in transactions {
      if let trans = transaction as? SKPaymentTransaction {
        switch trans.transactionState {
          case .purchased:
            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
            purchaseStatusBlock?("purchased")
            break
          case .failed:
            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
            purchaseStatusBlock?("failed")
            break
          case .restored:
            SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
            break
        default: 
          break
        }
      }
    }
  }
}

