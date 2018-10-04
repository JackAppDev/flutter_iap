part of flutter_blue;

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');
  static Future<IAPResponse> _respond(String method, [args]) async =>
      IAPResponse.fromBuffer(await _channel.invokeMethod(method, args));

  /// Android only: Retrieve a list of products which have been purchased previously.
  static Future<IAPResponse> fetchInventory() async => _respond("inventory");

  /// Retrieve a list of products available for purchase.
  static Future<IAPResponse> fetchProducts(List<String> ids) async =>
      _respond("fetch", ids);

  /// Starts the purchase process
  static Future<IAPResponse> buy(String id) async => _respond("buy", id);

  /// Consumes a previously purchased item
  static Future<IAPResponse> consume(String purchaseToken) async =>
      _respond("consume", purchaseToken);

  /// iOS only: Restore previous purchases
  static Future<IAPResponse> restorePurchases() async => _respond("restore");
}
