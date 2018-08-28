import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');
  static Future<IAPResponse> _respond(String method, [args]) async =>
      new IAPResponse(await _channel.invokeMethod(method, args));

  /// Android only: Retrieve a list of products which have been purchased previously.
  static Future<IAPResponse> fetchInventory() async => _respond("inventory");

  /// Retrieve a list of products available for purchase.
  static Future<IAPResponse> fetchProducts(List<String> ids) async =>
      _respond("fetch", ids);

  /// Starts the purchase process
  static Future<IAPResponse> buy(String id) async => _respond("buy", id);

  /// Consumes a previously purchased item
  static Future<IAPResponse> consume(String purchaseToken) async => _respond("consume", purchaseToken);

  /// iOS only: Restore previous purchases
  static Future<IAPResponse> restorePurchases() async => _respond("restore");
}

class IAPResponse {
  final String status;
  List<IAPProduct> products;
  List<IAPPurchase> purchases;

  factory IAPResponse(String source) =>
      new IAPResponse.fromJSON(json.decode(source));

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
  final String type;

  IAPProduct.fromJSON(Map<String, dynamic> json)
      : localizedDescription = json['localizedDescription'],
        localizedTitle = json['localizedTitle'],
        price = json['price'],
        priceLocale = json['priceLocale'],
        localizedPrice = json['localizedPrice'],
        productIdentifier = json['productIdentifier'],
        isDownloadable = json['isDownloadable'],
        downloadContentLengths = json['downloadContentLengths'],
        downloadContentVersion = json['downloadContentVersion'],
        type = json["type"];
}
