import 'dart:async';

import 'package:flutter/services.dart';

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');

  static Future<List<String>> fetchProducts(List<String> ids) => _channel.invokeMethod("fetch", ids);
  static Future<String> buy(String id) => _channel.invokeMethod("buy", id);
}
