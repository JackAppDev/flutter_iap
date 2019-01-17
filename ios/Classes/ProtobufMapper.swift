import StoreKit

class ProtobufMapper {
  
  static func buildProductResponse(_ products: [SKProduct]) -> Any {
    var r = IAPResponse()
    r.status = IAPResponseStatus.ok
    r.products = []
    
    let numberFormatter = NumberFormatter()
    numberFormatter.formatterBehavior = .behavior10_4
    numberFormatter.numberStyle = .currency
    
    for product in products {
      numberFormatter.locale = product.priceLocale
      
      var p = IAPProduct()
      if #available(iOS 11.2, *) {
        p.type = product.subscriptionPeriod != nil ? IAPProductType.subscription : IAPProductType.iap
      } else {
        NSLog("Can not determine the type of this SKProduct \(product), fallback to iap.")
        p.type = IAPProductType.iap
      }
      p.localizedDescription = product.localizedDescription
      p.localizedTitle = product.localizedTitle
      p.price = product.price.stringValue
      p.priceLocale = product.priceLocale.identifier
      p.localizedPrice = numberFormatter.string(from: product.price) ?? ""
      
      if #available(iOS 11.2, *) {
        // This needs to be clarified, not correct at the moment.
        if let ip = product.introductoryPrice {
          numberFormatter.locale = ip.priceLocale
          p.introductoryPrice = numberFormatter.string(from: ip.price) ?? ""
          p.introductoryPricePeriod = "\(ip.numberOfPeriods)"
          p.introductoryPriceCycles = "\(ip.subscriptionPeriod)"
        }
      } else {
        // Fallback on earlier versions
      }
      
      p.productIdentifier = product.productIdentifier
      p.isDownloadable = product.isDownloadable
      p.downloadContentLengths = product.downloadContentLengths.map({ (n) -> String in
        return n.stringValue
      }).joined(separator: ",")
      p.downloadContentVersion = product.downloadContentVersion
      
      r.products.append(p)
    }
    
    do {
      return try r.serializedData()
    } catch {
      return FlutterError(code: "buildProductResponse", message: error.localizedDescription, details: r)
    }
  }
  
  static func simpleResponse(_ status: IAPResponseStatus) -> Any {
    var r = IAPResponse()
    r.status = status
    
    do {
      return try r.serializedData()
    } catch {
      return FlutterError(code: "simpleResponse", message: error.localizedDescription, details: r)
    }
  }
  
  
  static func buildInventoryResponse(_ transactions: [SKPaymentTransaction]) -> Any {
    var r = IAPResponse()
    r.status = IAPResponseStatus.ok
    r.purchases = []
    
    for transaction in transactions {
      var p = IAPPurchase()
      p.productIdentifier = transaction.payment.productIdentifier
      r.purchases.append(p)
    }
    
    do {
      return try r.serializedData()
    } catch {
      return FlutterError(code: "buildInventoryResponse", message: error.localizedDescription, details: r)
    }
  }
  
}
