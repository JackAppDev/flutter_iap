import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');

  static Future<IAPResponse> fetchProducts(List<String> ids) async {
    String result = await _channel.invokeMethod("fetch", ids);
    return stringToResponse(result);
  }

  static Future<IAPResponse> buy(String id) async {
    String result = await _channel.invokeMethod("buy", id);
    return stringToResponse(result);
  }

  static Future<IAPResponse> restorePurchases() async {
    String result = await _channel.invokeMethod("restore");
    return stringToResponse(result);
  }

  static IAPResponse stringToResponse(String response) {
    Map<String, dynamic> mapResponse = json.decode(response);
    return new IAPResponse.fromJSON(mapResponse);
  }
}

class IAPResponse {
  String status;
  List<IAPProduct> products;

  IAPResponse.fromJSON(Map<String, dynamic> json) : status = json['status'] {
    if (json['products'] != null) {
      products = json['products']
          .map<IAPProduct>((product) => new IAPProduct.fromJSON(product))
          .toList();
    }
  }
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
