///
//  Generated code. Do not modify.
//  source: flutter_iap.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class IAPResponseStatus extends $pb.ProtobufEnum {
  static const IAPResponseStatus ok = const IAPResponseStatus._(0, 'ok');
  static const IAPResponseStatus error = const IAPResponseStatus._(1, 'error');
  static const IAPResponseStatus emptyProductList = const IAPResponseStatus._(2, 'emptyProductList');
  static const IAPResponseStatus disabled = const IAPResponseStatus._(3, 'disabled');
  static const IAPResponseStatus userCanceled = const IAPResponseStatus._(4, 'userCanceled');
  static const IAPResponseStatus serviceUnavailable = const IAPResponseStatus._(5, 'serviceUnavailable');
  static const IAPResponseStatus billingUnavailable = const IAPResponseStatus._(6, 'billingUnavailable');
  static const IAPResponseStatus itemUnavailable = const IAPResponseStatus._(7, 'itemUnavailable');
  static const IAPResponseStatus developerError = const IAPResponseStatus._(8, 'developerError');
  static const IAPResponseStatus itemAlreadyOwned = const IAPResponseStatus._(9, 'itemAlreadyOwned');
  static const IAPResponseStatus itemNotOwned = const IAPResponseStatus._(10, 'itemNotOwned');

  static const List<IAPResponseStatus> values = const <IAPResponseStatus> [
    ok,
    error,
    emptyProductList,
    disabled,
    userCanceled,
    serviceUnavailable,
    billingUnavailable,
    itemUnavailable,
    developerError,
    itemAlreadyOwned,
    itemNotOwned,
  ];

  static final Map<int, IAPResponseStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IAPResponseStatus valueOf(int value) => _byValue[value];
  static void $checkItem(IAPResponseStatus v) {
    if (v is! IAPResponseStatus) $pb.checkItemFailed(v, 'IAPResponseStatus');
  }

  const IAPResponseStatus._(int v, String n) : super(v, n);
}

class IAPProductType extends $pb.ProtobufEnum {
  static const IAPProductType iap = const IAPProductType._(0, 'iap');
  static const IAPProductType subscription = const IAPProductType._(1, 'subscription');

  static const List<IAPProductType> values = const <IAPProductType> [
    iap,
    subscription,
  ];

  static final Map<int, IAPProductType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IAPProductType valueOf(int value) => _byValue[value];
  static void $checkItem(IAPProductType v) {
    if (v is! IAPProductType) $pb.checkItemFailed(v, 'IAPProductType');
  }

  const IAPProductType._(int v, String n) : super(v, n);
}

class IntroductoryPricePaymentMode extends $pb.ProtobufEnum {
  static const IntroductoryPricePaymentMode payAsYouGo = const IntroductoryPricePaymentMode._(0, 'payAsYouGo');
  static const IntroductoryPricePaymentMode payUpFront = const IntroductoryPricePaymentMode._(1, 'payUpFront');
  static const IntroductoryPricePaymentMode freeTrial = const IntroductoryPricePaymentMode._(2, 'freeTrial');

  static const List<IntroductoryPricePaymentMode> values = const <IntroductoryPricePaymentMode> [
    payAsYouGo,
    payUpFront,
    freeTrial,
  ];

  static final Map<int, IntroductoryPricePaymentMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IntroductoryPricePaymentMode valueOf(int value) => _byValue[value];
  static void $checkItem(IntroductoryPricePaymentMode v) {
    if (v is! IntroductoryPricePaymentMode) $pb.checkItemFailed(v, 'IntroductoryPricePaymentMode');
  }

  const IntroductoryPricePaymentMode._(int v, String n) : super(v, n);
}

