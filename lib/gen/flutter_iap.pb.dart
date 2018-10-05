///
//  Generated code. Do not modify.
//  source: flutter_iap.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'flutter_iap.pbenum.dart';

export 'flutter_iap.pbenum.dart';

class IAPPurchaseRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IAPPurchaseRequest')
    ..aQS(1, 'productIdentifier')
    ..e<IAPProductType>(2, 'type', $pb.PbFieldType.QE, IAPProductType.iap, IAPProductType.valueOf, IAPProductType.values)
  ;

  IAPPurchaseRequest() : super();
  IAPPurchaseRequest.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IAPPurchaseRequest.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IAPPurchaseRequest clone() => new IAPPurchaseRequest()..mergeFromMessage(this);
  IAPPurchaseRequest copyWith(void Function(IAPPurchaseRequest) updates) => super.copyWith((message) => updates(message as IAPPurchaseRequest));
  $pb.BuilderInfo get info_ => _i;
  static IAPPurchaseRequest create() => new IAPPurchaseRequest();
  static $pb.PbList<IAPPurchaseRequest> createRepeated() => new $pb.PbList<IAPPurchaseRequest>();
  static IAPPurchaseRequest getDefault() => _defaultInstance ??= create()..freeze();
  static IAPPurchaseRequest _defaultInstance;
  static void $checkItem(IAPPurchaseRequest v) {
    if (v is! IAPPurchaseRequest) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get productIdentifier => $_getS(0, '');
  set productIdentifier(String v) { $_setString(0, v); }
  bool hasProductIdentifier() => $_has(0);
  void clearProductIdentifier() => clearField(1);

  IAPProductType get type => $_getN(1);
  set type(IAPProductType v) { setField(2, v); }
  bool hasType() => $_has(1);
  void clearType() => clearField(2);
}

class IAPPurchase extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IAPPurchase')
    ..aQS(1, 'productIdentifier')
    ..aQS(2, 'signature')
    ..aQS(3, 'originalJson')
    ..aQS(4, 'orderId')
    ..aQS(5, 'packageName')
    ..a<Int64>(6, 'purchaseTime', $pb.PbFieldType.Q6, Int64.ZERO)
    ..aQS(7, 'purchaseToken')
  ;

  IAPPurchase() : super();
  IAPPurchase.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IAPPurchase.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IAPPurchase clone() => new IAPPurchase()..mergeFromMessage(this);
  IAPPurchase copyWith(void Function(IAPPurchase) updates) => super.copyWith((message) => updates(message as IAPPurchase));
  $pb.BuilderInfo get info_ => _i;
  static IAPPurchase create() => new IAPPurchase();
  static $pb.PbList<IAPPurchase> createRepeated() => new $pb.PbList<IAPPurchase>();
  static IAPPurchase getDefault() => _defaultInstance ??= create()..freeze();
  static IAPPurchase _defaultInstance;
  static void $checkItem(IAPPurchase v) {
    if (v is! IAPPurchase) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get productIdentifier => $_getS(0, '');
  set productIdentifier(String v) { $_setString(0, v); }
  bool hasProductIdentifier() => $_has(0);
  void clearProductIdentifier() => clearField(1);

  String get signature => $_getS(1, '');
  set signature(String v) { $_setString(1, v); }
  bool hasSignature() => $_has(1);
  void clearSignature() => clearField(2);

  String get originalJson => $_getS(2, '');
  set originalJson(String v) { $_setString(2, v); }
  bool hasOriginalJson() => $_has(2);
  void clearOriginalJson() => clearField(3);

  String get orderId => $_getS(3, '');
  set orderId(String v) { $_setString(3, v); }
  bool hasOrderId() => $_has(3);
  void clearOrderId() => clearField(4);

  String get packageName => $_getS(4, '');
  set packageName(String v) { $_setString(4, v); }
  bool hasPackageName() => $_has(4);
  void clearPackageName() => clearField(5);

  Int64 get purchaseTime => $_getI64(5);
  set purchaseTime(Int64 v) { $_setInt64(5, v); }
  bool hasPurchaseTime() => $_has(5);
  void clearPurchaseTime() => clearField(6);

  String get purchaseToken => $_getS(6, '');
  set purchaseToken(String v) { $_setString(6, v); }
  bool hasPurchaseToken() => $_has(6);
  void clearPurchaseToken() => clearField(7);
}

class IAPProduct extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IAPProduct')
    ..e<IAPProductType>(1, 'type', $pb.PbFieldType.QE, IAPProductType.iap, IAPProductType.valueOf, IAPProductType.values)
    ..aQS(2, 'productIdentifier')
    ..aQS(3, 'localizedTitle')
    ..aQS(4, 'localizedDescription')
    ..aQS(5, 'price')
    ..aQS(6, 'priceLocale')
    ..aQS(7, 'localizedPrice')
    ..a<bool>(8, 'isDownloadable', $pb.PbFieldType.QB)
    ..aQS(9, 'downloadContentLengths')
    ..aQS(10, 'downloadContentVersion')
    ..aQS(11, 'freeTrialPeriod')
    ..aQS(20, 'subscriptionPeriod')
    ..aQS(21, 'introductoryPrice')
    ..aQS(22, 'introductoryPricePeriod')
    ..aQS(23, 'introductoryPriceCycles')
  ;

  IAPProduct() : super();
  IAPProduct.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IAPProduct.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IAPProduct clone() => new IAPProduct()..mergeFromMessage(this);
  IAPProduct copyWith(void Function(IAPProduct) updates) => super.copyWith((message) => updates(message as IAPProduct));
  $pb.BuilderInfo get info_ => _i;
  static IAPProduct create() => new IAPProduct();
  static $pb.PbList<IAPProduct> createRepeated() => new $pb.PbList<IAPProduct>();
  static IAPProduct getDefault() => _defaultInstance ??= create()..freeze();
  static IAPProduct _defaultInstance;
  static void $checkItem(IAPProduct v) {
    if (v is! IAPProduct) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  IAPProductType get type => $_getN(0);
  set type(IAPProductType v) { setField(1, v); }
  bool hasType() => $_has(0);
  void clearType() => clearField(1);

  String get productIdentifier => $_getS(1, '');
  set productIdentifier(String v) { $_setString(1, v); }
  bool hasProductIdentifier() => $_has(1);
  void clearProductIdentifier() => clearField(2);

  String get localizedTitle => $_getS(2, '');
  set localizedTitle(String v) { $_setString(2, v); }
  bool hasLocalizedTitle() => $_has(2);
  void clearLocalizedTitle() => clearField(3);

  String get localizedDescription => $_getS(3, '');
  set localizedDescription(String v) { $_setString(3, v); }
  bool hasLocalizedDescription() => $_has(3);
  void clearLocalizedDescription() => clearField(4);

  String get price => $_getS(4, '');
  set price(String v) { $_setString(4, v); }
  bool hasPrice() => $_has(4);
  void clearPrice() => clearField(5);

  String get priceLocale => $_getS(5, '');
  set priceLocale(String v) { $_setString(5, v); }
  bool hasPriceLocale() => $_has(5);
  void clearPriceLocale() => clearField(6);

  String get localizedPrice => $_getS(6, '');
  set localizedPrice(String v) { $_setString(6, v); }
  bool hasLocalizedPrice() => $_has(6);
  void clearLocalizedPrice() => clearField(7);

  bool get isDownloadable => $_get(7, false);
  set isDownloadable(bool v) { $_setBool(7, v); }
  bool hasIsDownloadable() => $_has(7);
  void clearIsDownloadable() => clearField(8);

  String get downloadContentLengths => $_getS(8, '');
  set downloadContentLengths(String v) { $_setString(8, v); }
  bool hasDownloadContentLengths() => $_has(8);
  void clearDownloadContentLengths() => clearField(9);

  String get downloadContentVersion => $_getS(9, '');
  set downloadContentVersion(String v) { $_setString(9, v); }
  bool hasDownloadContentVersion() => $_has(9);
  void clearDownloadContentVersion() => clearField(10);

  String get freeTrialPeriod => $_getS(10, '');
  set freeTrialPeriod(String v) { $_setString(10, v); }
  bool hasFreeTrialPeriod() => $_has(10);
  void clearFreeTrialPeriod() => clearField(11);

  String get subscriptionPeriod => $_getS(11, '');
  set subscriptionPeriod(String v) { $_setString(11, v); }
  bool hasSubscriptionPeriod() => $_has(11);
  void clearSubscriptionPeriod() => clearField(20);

  String get introductoryPrice => $_getS(12, '');
  set introductoryPrice(String v) { $_setString(12, v); }
  bool hasIntroductoryPrice() => $_has(12);
  void clearIntroductoryPrice() => clearField(21);

  String get introductoryPricePeriod => $_getS(13, '');
  set introductoryPricePeriod(String v) { $_setString(13, v); }
  bool hasIntroductoryPricePeriod() => $_has(13);
  void clearIntroductoryPricePeriod() => clearField(22);

  String get introductoryPriceCycles => $_getS(14, '');
  set introductoryPriceCycles(String v) { $_setString(14, v); }
  bool hasIntroductoryPriceCycles() => $_has(14);
  void clearIntroductoryPriceCycles() => clearField(23);
}

class IAPResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('IAPResponse')
    ..e<IAPResponseStatus>(1, 'status', $pb.PbFieldType.QE, IAPResponseStatus.ok, IAPResponseStatus.valueOf, IAPResponseStatus.values)
    ..aOS(2, 'statusMessage')
    ..pp<IAPPurchase>(3, 'purchases', $pb.PbFieldType.PM, IAPPurchase.$checkItem, IAPPurchase.create)
    ..pp<IAPProduct>(4, 'products', $pb.PbFieldType.PM, IAPProduct.$checkItem, IAPProduct.create)
  ;

  IAPResponse() : super();
  IAPResponse.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  IAPResponse.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  IAPResponse clone() => new IAPResponse()..mergeFromMessage(this);
  IAPResponse copyWith(void Function(IAPResponse) updates) => super.copyWith((message) => updates(message as IAPResponse));
  $pb.BuilderInfo get info_ => _i;
  static IAPResponse create() => new IAPResponse();
  static $pb.PbList<IAPResponse> createRepeated() => new $pb.PbList<IAPResponse>();
  static IAPResponse getDefault() => _defaultInstance ??= create()..freeze();
  static IAPResponse _defaultInstance;
  static void $checkItem(IAPResponse v) {
    if (v is! IAPResponse) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  IAPResponseStatus get status => $_getN(0);
  set status(IAPResponseStatus v) { setField(1, v); }
  bool hasStatus() => $_has(0);
  void clearStatus() => clearField(1);

  String get statusMessage => $_getS(1, '');
  set statusMessage(String v) { $_setString(1, v); }
  bool hasStatusMessage() => $_has(1);
  void clearStatusMessage() => clearField(2);

  List<IAPPurchase> get purchases => $_getList(2);

  List<IAPProduct> get products => $_getList(3);
}

