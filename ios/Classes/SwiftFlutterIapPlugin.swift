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
      result(ProtobufMapper.buildInventoryResponse([]))
    case "fetch":
      IAPHandler.shared.purchaseStatusBlock = result
      
      if let args = call.arguments as? FlutterStandardTypedData,
        let request = try? IAPFetchProductsRequest(serializedData: args.data ) {

        IAPHandler.shared.fetchAvailableProducts(request.productIdentifier)
      } else {
        result(ProtobufMapper.simpleResponse(IAPResponseStatus.developerError))
      }
    case "buy":
      IAPHandler.shared.purchaseStatusBlock = result

      if let args = call.arguments as? FlutterStandardTypedData,
        let request = try? IAPPurchaseRequest(serializedData: args.data ) {

        IAPHandler.shared.purchaseMyProduct(request.productIdentifier)
      } else {
        result(ProtobufMapper.simpleResponse(IAPResponseStatus.developerError))
      }
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
  fileprivate var restoredIds : [SKPaymentTransaction] = []
  
  var purchaseStatusBlock: ((Any) -> Void)?
  
  func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
  
  func purchaseMyProduct(_ id: String) {
    if iapProducts.count == 0 {
      purchaseStatusBlock?(ProtobufMapper.simpleResponse(IAPResponseStatus.emptyProductList))
      return
    }
    
    if self.canMakePurchases() {
      let product = iapProducts[id]!
      let payment = SKPayment(product: product)
      SKPaymentQueue.default().add(self)
      SKPaymentQueue.default().add(payment)
      
      productID = product.productIdentifier
    } else {
      purchaseStatusBlock?(ProtobufMapper.simpleResponse(IAPResponseStatus.disabled))
    }
  }
  
  func restorePurchase() {
    restoredIds.removeAll()
    
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
  
  func fetchAvailableProducts(_ ids: [String]) {
    productsRequest = SKProductsRequest(productIdentifiers: Set(ids))
    productsRequest.delegate = self
    productsRequest.start()
  }
}

extension IAPHandler: SKProductsRequestDelegate {
  func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
    iapProducts.removeAll()
    for product in response.products {
      iapProducts[product.productIdentifier] = product
    }
    
    for ip in response.invalidProductIdentifiers {
      NSLog("invalid product identifier: \(ip)")
    }
    
    purchaseStatusBlock?(ProtobufMapper.buildProductResponse(response.products))
  }
}

extension IAPHandler: SKPaymentTransactionObserver {
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    purchaseStatusBlock?(ProtobufMapper.buildInventoryResponse(restoredIds))
    
    restoredIds.removeAll()
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
    purchaseStatusBlock?(ProtobufMapper.simpleResponse(IAPResponseStatus.error))

    restoredIds.removeAll()
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction:AnyObject in transactions {
      if let transaction = transaction as? SKPaymentTransaction {
        switch transaction.transactionState {
        case .purchased:
          SKPaymentQueue.default().finishTransaction(transaction)
          purchaseStatusBlock?(ProtobufMapper.buildInventoryResponse([transaction]))
          break
        case .failed:
          SKPaymentQueue.default().finishTransaction(transaction)
          purchaseStatusBlock?(ProtobufMapper.simpleResponse(IAPResponseStatus.error))
          break
        case .restored:
          SKPaymentQueue.default().finishTransaction(transaction)
          restoredIds.append(transaction)
          break
        default: 
          break
        }
      }
    }
  }  
}

