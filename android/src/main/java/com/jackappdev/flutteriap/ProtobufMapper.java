package com.jackappdev.flutteriap;

import android.support.annotation.Nullable;
import android.util.Log;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.SkuDetails;

import java.util.List;

import static com.android.billingclient.api.BillingClient.SkuType.INAPP;
import static com.android.billingclient.api.BillingClient.SkuType.SUBS;

/**
 */
class ProtobufMapper {
  private static final String TAG = "FlutterIapPlugin";

  @Nullable
  static FlutterIap.IAPPurchaseRequest mapPurchaseRequest(Object source) {
    try {
      return FlutterIap.IAPPurchaseRequest.parseFrom((byte[]) source);
    } catch (Throwable e) {
      Log.e(TAG, "Can not read purchase request!", e);
      return null;
    }
  }

  static byte[] buildProductResponse(List<SkuDetails> products) {
    FlutterIap.IAPResponse.Builder inventoryBuilder =
        FlutterIap.IAPResponse.newBuilder();

    inventoryBuilder.setStatus(FlutterIap.IAPResponseStatus.ok);

    for (SkuDetails p: products) {
      inventoryBuilder.addProducts(FlutterIap.IAPProduct.newBuilder()
          .setType(mapIapProductType(p.getType()))
          .setProductIdentifier(p.getSku())
          .setLocalizedTitle(p.getTitle())
          .setLocalizedDescription(p.getDescription())
          .setPrice(p.getPrice())
          .setPriceLocale(p.getPriceCurrencyCode())
          .setLocalizedPrice(p.getPrice())
          .setSubscriptionPeriod(p.getSubscriptionPeriod())
          .setIntroductoryPrice(p.getIntroductoryPrice())
          .setIntroductoryPriceCycles(p.getIntroductoryPriceCycles())
          .setIntroductoryPricePeriod(p.getIntroductoryPricePeriod())
          .build());
    }

    return inventoryBuilder.build().toByteArray();
  }

  private static FlutterIap.IAPProductType mapIapProductType(@BillingClient.SkuType String type) {
    switch (type) {
      case INAPP:
        return FlutterIap.IAPProductType.iap;
      case SUBS:
        return FlutterIap.IAPProductType.subscription;
    }

    Log.e(TAG, "Unknown SkuType, returning default IAP: " + type);
    return FlutterIap.IAPProductType.iap;
  }

  static byte[] buildInventoryResponse(List<Purchase> purchases) {
    FlutterIap.IAPResponse.Builder inventoryBuilder =
        FlutterIap.IAPResponse.newBuilder();

    inventoryBuilder.setStatus(FlutterIap.IAPResponseStatus.ok);

    for (Purchase p : purchases) {
      inventoryBuilder.addPurchases(FlutterIap.IAPPurchase.newBuilder()
          .setProductIdentifier(p.getSku())
          .setOriginalJson(p.getOriginalJson())
          .setSignature(p.getSignature())
          .setOrderId(p.getOrderId())
          .setPackageName(p.getPackageName())
          .setPurchaseTime(p.getPurchaseTime())
          .setPurchaseToken(p.getPurchaseToken())
          .build());
    }

    return inventoryBuilder.build().toByteArray();
  }

  static byte[] simpleResponse(FlutterIap.IAPResponseStatus status) {
    return FlutterIap.IAPResponse.newBuilder()
        .setStatus(status)
        .build()
        .toByteArray();
  }
}
