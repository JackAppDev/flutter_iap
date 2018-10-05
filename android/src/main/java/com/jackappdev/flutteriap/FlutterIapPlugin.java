package com.jackappdev.flutteriap;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.util.Log;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsResponseListener;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterIapPlugin
 */
public class FlutterIapPlugin implements MethodCallHandler {
  private static final String TAG = "FlutterIapPlugin";

  private final Activity activity;
  private BillingManager billingManager;


  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_iap");
    channel.setMethodCallHandler(new FlutterIapPlugin(registrar.activity()));
  }

  private FlutterIapPlugin(final Activity activity) {
    this.activity = activity;
    activity.getApplication()
        .registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
          @Override
          public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

          }

          @Override
          public void onActivityStarted(Activity activity) {

          }

          @Override
          public void onActivityResumed(Activity activity) {

          }

          @Override
          public void onActivityPaused(Activity activity) {

          }

          @Override
          public void onActivityStopped(Activity activity) {

          }

          @Override
          public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

          }

          @Override
          public void onActivityDestroyed(Activity activity) {
            if (billingManager != null) {
              billingManager.destroy();
              billingManager = null;
            }
          }
        });
  }


  @Override
  public void onMethodCall(final MethodCall call, final Result result) {
    if (billingManager != null) {
      billingManager.destroy();
      billingManager = null;
    }

    // gets skus
    // gets products info
    if ("inventory".equals(call.method)) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished(@BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            billingManager.queryPurchases();
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases, @BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            result.success(ProtobufMapper.buildInventoryResponse(purchases));
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }
      }, null);

    } else if ("buy".equals(call.method)) {
      final FlutterIap.IAPPurchaseRequest request = ProtobufMapper.mapPurchaseRequest(call.arguments);
      if (request == null) {
        result.success(ProtobufMapper.simpleResponse(FlutterIap.IAPResponseStatus.developerError));
        return;
      }

      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished(@BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            billingManager.initiatePurchaseFlow(request.getProductIdentifier(), googleProductType(request.getType()));
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases, @BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            result.success(ProtobufMapper.buildInventoryResponse(purchases));
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }
      }, null);

    } else if ("consume".equals(call.method)) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished(@BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            billingManager.consumeAsync((String) call.arguments);
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            result.success(ProtobufMapper.simpleResponse(FlutterIap.IAPResponseStatus.ok));
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases, @BillingClient.BillingResponse int responseCode) {
        }
      }, null);

    } else if ("fetch".equals(call.method)) {
      final FlutterIap.IAPFetchProductsRequest request = ProtobufMapper.mapFetchRequest(call.arguments);
      if (request == null) {
        result.success(ProtobufMapper.simpleResponse(FlutterIap.IAPResponseStatus.developerError));
        return;
      }

      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished(@BillingClient.BillingResponse int responseCode) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            billingManager.querySKUProducts(request.getProductIdentifierList());
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases, @BillingClient.BillingResponse int responseCode) {
        }
      }, new SkuDetailsResponseListener() {
        @Override
        public void onSkuDetailsResponse(@BillingClient.BillingResponse int responseCode, List<SkuDetails> skuDetailsList) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            result.success(ProtobufMapper.buildProductResponse(skuDetailsList));
          } else {
            result.success(ProtobufMapper.simpleResponse(mapGoogleResponseCode(responseCode)));
          }
        }

      });
    } else {
      result.notImplemented();
    }
  }

  @BillingClient.SkuType
  private static String googleProductType(FlutterIap.IAPProductType type) {
    switch (type) {
      case iap:
        return BillingClient.SkuType.INAPP;
      case subscription:
        return BillingClient.SkuType.SUBS;
    }

    return BillingClient.SkuType.INAPP;
  }

  private static FlutterIap.IAPResponseStatus mapGoogleResponseCode(@BillingClient.BillingResponse int responseCode) {
    Log.e(TAG, "mapping response code: " + responseCode);
    switch (responseCode) {
      case BillingClient.BillingResponse.BILLING_UNAVAILABLE:
        return FlutterIap.IAPResponseStatus.billingUnavailable;
      case BillingClient.BillingResponse.DEVELOPER_ERROR:
        return FlutterIap.IAPResponseStatus.developerError;
      case BillingClient.BillingResponse.ERROR:
        return FlutterIap.IAPResponseStatus.error;
      case BillingClient.BillingResponse.FEATURE_NOT_SUPPORTED:
        return FlutterIap.IAPResponseStatus.featureNotSupported;
      case BillingClient.BillingResponse.ITEM_ALREADY_OWNED:
        return FlutterIap.IAPResponseStatus.itemAlreadyOwned;
      case BillingClient.BillingResponse.ITEM_NOT_OWNED:
        return FlutterIap.IAPResponseStatus.itemNotOwned;
      case BillingClient.BillingResponse.ITEM_UNAVAILABLE:
        return FlutterIap.IAPResponseStatus.itemUnavailable;
      case BillingClient.BillingResponse.OK:
        return FlutterIap.IAPResponseStatus.ok;
      case BillingClient.BillingResponse.SERVICE_DISCONNECTED:
        return FlutterIap.IAPResponseStatus.serviceDisconnected;
      case BillingClient.BillingResponse.SERVICE_UNAVAILABLE:
        return FlutterIap.IAPResponseStatus.serviceUnavailable;
      case BillingClient.BillingResponse.USER_CANCELED:
        return FlutterIap.IAPResponseStatus.userCanceled;
      default:
        Log.e(TAG, "Unknown response code: " + responseCode);
        return FlutterIap.IAPResponseStatus.error;
    }
  }
}
