///
//  Generated code. Do not modify.
//  source: flutter_iap.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const IAPResponseStatus$json = const {
  '1': 'IAPResponseStatus',
  '2': const [
    const {'1': 'ok', '2': 0},
    const {'1': 'error', '2': 1},
    const {'1': 'emptyProductList', '2': 2},
    const {'1': 'disabled', '2': 3},
    const {'1': 'userCanceled', '2': 4},
    const {'1': 'serviceUnavailable', '2': 5},
    const {'1': 'billingUnavailable', '2': 6},
    const {'1': 'itemUnavailable', '2': 7},
    const {'1': 'developerError', '2': 8},
    const {'1': 'itemAlreadyOwned', '2': 9},
    const {'1': 'itemNotOwned', '2': 10},
  ],
};

const IAPProductType$json = const {
  '1': 'IAPProductType',
  '2': const [
    const {'1': 'iap', '2': 0},
    const {'1': 'subscription', '2': 1},
  ],
};

const IntroductoryPricePaymentMode$json = const {
  '1': 'IntroductoryPricePaymentMode',
  '2': const [
    const {'1': 'payAsYouGo', '2': 0},
    const {'1': 'payUpFront', '2': 1},
    const {'1': 'freeTrial', '2': 2},
  ],
};

const IAPPurchase$json = const {
  '1': 'IAPPurchase',
  '2': const [
    const {'1': 'productIdentifier', '3': 1, '4': 2, '5': 9, '10': 'productIdentifier'},
    const {'1': 'signature', '3': 2, '4': 2, '5': 9, '10': 'signature'},
    const {'1': 'originalJson', '3': 3, '4': 2, '5': 9, '10': 'originalJson'},
    const {'1': 'orderId', '3': 4, '4': 2, '5': 9, '10': 'orderId'},
    const {'1': 'packageName', '3': 5, '4': 2, '5': 9, '10': 'packageName'},
    const {'1': 'purchaseTime', '3': 6, '4': 2, '5': 3, '10': 'purchaseTime'},
    const {'1': 'purchaseToken', '3': 7, '4': 2, '5': 9, '10': 'purchaseToken'},
  ],
};

const IAPProduct$json = const {
  '1': 'IAPProduct',
  '2': const [
    const {'1': 'type', '3': 1, '4': 2, '5': 14, '6': '.IAPProductType', '10': 'type'},
    const {'1': 'productIdentifier', '3': 2, '4': 2, '5': 9, '10': 'productIdentifier'},
    const {'1': 'localizedTitle', '3': 3, '4': 2, '5': 9, '10': 'localizedTitle'},
    const {'1': 'localizedDescription', '3': 4, '4': 2, '5': 9, '10': 'localizedDescription'},
    const {'1': 'price', '3': 5, '4': 2, '5': 9, '10': 'price'},
    const {'1': 'priceLocale', '3': 6, '4': 2, '5': 9, '10': 'priceLocale'},
    const {'1': 'localizedPrice', '3': 7, '4': 2, '5': 9, '10': 'localizedPrice'},
    const {'1': 'isDownloadable', '3': 8, '4': 2, '5': 8, '10': 'isDownloadable'},
    const {'1': 'downloadContentLengths', '3': 9, '4': 2, '5': 9, '10': 'downloadContentLengths'},
    const {'1': 'downloadContentVersion', '3': 10, '4': 2, '5': 9, '10': 'downloadContentVersion'},
    const {'1': 'freeTrialPeriod', '3': 11, '4': 2, '5': 9, '10': 'freeTrialPeriod'},
    const {'1': 'subscriptionPeriod', '3': 20, '4': 2, '5': 9, '10': 'subscriptionPeriod'},
    const {'1': 'introductoryPrice', '3': 21, '4': 2, '5': 9, '10': 'introductoryPrice'},
    const {'1': 'introductoryPricePeriod', '3': 22, '4': 2, '5': 9, '10': 'introductoryPricePeriod'},
    const {'1': 'introductoryPriceCycles', '3': 23, '4': 2, '5': 9, '10': 'introductoryPriceCycles'},
  ],
};

const IAPResponse$json = const {
  '1': 'IAPResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 2, '5': 14, '6': '.IAPResponseStatus', '10': 'status'},
    const {'1': 'statusMessage', '3': 2, '4': 1, '5': 9, '10': 'statusMessage'},
    const {'1': 'purchases', '3': 3, '4': 3, '5': 11, '6': '.IAPPurchase', '10': 'purchases'},
    const {'1': 'products', '3': 4, '4': 3, '5': 11, '6': '.IAPProduct', '10': 'products'},
  ],
};

