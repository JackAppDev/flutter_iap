part of flutter_iap;

class FlutterIap {
  static const MethodChannel _channel = const MethodChannel('flutter_iap');
  static Future<IAPResponse> _respond(String method, [args]) async =>
      IAPResponse.fromBuffer(await _channel.invokeMethod(method, args));

  /// Android only: Retrieve a list of previously purchased products.
  static Future<IAPResponse> fetchInventory() async => _respond("inventory");

  /// Retrieve a list of products available for purchase.
  ///
  /// The list of [ids] must contain a list of valid product identifiers.
  static Future<IAPResponse> fetchProducts(List<String> ids) async {
    assert(ids.isNotEmpty);

    final request = IAPFetchProductsRequest.create();
    request.productIdentifier.addAll(ids);

    return _respond("fetch", request.writeToBuffer());
  }

  /// Starts the purchase process for a specific product [id] of [type].
  static Future<IAPResponse> buy(
    @required String id, {
    @required IAPProductType type = IAPProductType.iap,
  }) async {
    final request = IAPPurchaseRequest.create();
    request.productIdentifier = id;
    request.type = type;

    return _respond("buy", request.writeToBuffer());
  }

  /// Consumes a previously purchased item
  static Future<IAPResponse> consume(String purchaseToken) async =>
      _respond("consume", purchaseToken);

  /// iOS only: Restore previous purchases
  static Future<IAPResponse> restorePurchases() async => _respond("restore");
}
