import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');

  /// Android only: Retrieve a list of products which have been purchased previously.
  static Future<IAPResponse> fetchInventory() async {
    String result = await _channel.invokeMethod("inventory");
    return new IAPResponse(result);
  }

  /// Retrieve a list of products available for purchase.
  static Future<IAPResponse> fetchProducts(List<String> ids) async {
    String result = await _channel.invokeMethod("fetch", ids);
    return new IAPResponse(result);
  }

  /// Starts the purchase process
  static Future<IAPResponse> buy(String id) async {
    String result = await _channel.invokeMethod("buy", id);
    return new IAPResponse(result);
  }

  /// iOS only: Restore previous purchases
  static Future<IAPResponse> restorePurchases() async {
    String result = await _channel.invokeMethod("restore");
    return new IAPResponse(result);
  }
}

class IAPResponse {
  final String status;
  List<IAPProduct> products;
  List<IAPPurchase> purchases;

  factory IAPResponse(String source) => new IAPResponse.fromJSON(json.decode(source));

  IAPResponse.fromJSON(Map<String, dynamic> json) : status = json['status'] {
    if (json['products'] != null) {
      products = json['products']
          .map<IAPProduct>((product) => new IAPProduct.fromJSON(product))
          .toList();
    }
    if (json['purchases'] != null) {
      purchases = json['purchases']
          .map<IAPPurchase>((purchase) => new IAPPurchase.fromJSON(purchase))
          .toList();
    }
  }
}

class IAPPurchase {
  final String productIdentifier;
  final String signature;
  final String originalJson;

  IAPPurchase.fromJSON(Map<String, dynamic> json)
      : productIdentifier = json['productIdentifier'],
        signature = json['signature'],
        originalJson = json['originalJson'];
}

class IAPProduct {
  final String localizedDescription;
  final String localizedTitle;
  final String price;
  final String priceLocale;
  final String localizedPrice;
  final String productIdentifier;
  final bool isDownloadable;
  final String downloadContentLengths;
  final String downloadContentVersion;

  IAPProduct.fromJSON(Map<String, dynamic> json)
      : localizedDescription = json['localizedDescription'],
        localizedTitle = json['localizedTitle'],
        price = json['price'],
        priceLocale = json['priceLocale'],
        localizedPrice = json['localizedPrice'],
        productIdentifier = json['productIdentifier'],
        isDownloadable = json['isDownloadable'],
        downloadContentLengths = json['downloadContentLengths'],
        downloadContentVersion = json['downloadContentVersion'];
}
