package com.jackappdev.flutteriap;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

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
        public void onBillingClientSetupFinished() {
          billingManager.queryPurchases();
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
          result.success(ProtobufMapper.buildInventoryResponse(purchases));
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
        public void onBillingClientSetupFinished() {
          billingManager.initiatePurchaseFlow(request.getProductIdentifier(), googleProductType(request.getType()));
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
          if (purchases.size() > 0) {
            result.success(ProtobufMapper.buildInventoryResponse(purchases));
          } else {
            // TODO: Should this be a "success" response but simply with the status flag set correctly?
            result.error("ERROR", "Failed to buy", null);
          }
        }
      }, null);

    } else if ("consume".equals(call.method)) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {
          billingManager.consumeAsync((String) call.arguments);
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
          switch (responseCode) {
            case BillingClient.BillingResponse.OK:
              result.success(ProtobufMapper.simpleResponse(FlutterIap.IAPResponseStatus.ok));
              break;
            default:
              result.error("ERROR", "google_play", responseCode);
          }
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
        }
      }, null);

    } else if ("fetch".equals(call.method)) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {
          billingManager.querySKUProducts((List<String>) call.arguments);
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
        }
      }, new SkuDetailsResponseListener() {
        @Override
        public void onSkuDetailsResponse(@BillingClient.BillingResponse int responseCode, List<SkuDetails> skuDetailsList) {
          if (responseCode == BillingClient.BillingResponse.OK) {
            result.success(ProtobufMapper.buildProductResponse(skuDetailsList));
          } else {
            result.error("ERROR", "google_play", responseCode);
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

}
