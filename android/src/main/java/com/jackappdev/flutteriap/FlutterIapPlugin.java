package com.jackappdev.flutteriap;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.util.Log;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsParams;
import com.android.billingclient.api.SkuDetailsResponseListener;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
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
    activity.getApplication().registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
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

    if (call.method.equals("inventory")) { // gets skus
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {}

        @Override
        public void onConsumeFinished(String token, @BillingClient.BillingResponse int result) {
          Log.e("token", token);
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
          StringBuilder sb = new StringBuilder("[");

          if (purchases != null) {
            for (Purchase p : purchases) {
              if (sb.length() > 1) {
                sb.append(",");
              }
              sb.append("{");
              sb.append("\"signature\":\"" + p.getSignature() + "\",");
              sb.append("\"originalJson\":\"" + p.getOriginalJson() + "\",");
              sb.append("\"sku\":\"" + p.getSku() + "\"");
              sb.append("}");
            }
          }
          sb.append("]");
          result.success("{\"status\":\"loaded\",\"purchases\":" + sb.toString() + "}");
        }
      }, null);
    } else if (call.method.equals("buy")) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {
          billingManager.initiatePurchaseFlow((String) call.arguments, BillingClient.SkuType.INAPP);
        }

        @Override
        public void onConsumeFinished(String token, @BillingClient.BillingResponse int result) {
          Log.e("token", token);
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
          Log.e("purchases", purchases.toString());
          if (purchases.size() > 0) {
            Purchase p = purchases.get(0);
            Log.e("Consuming", p.getSku());
            billingManager.consumeAsync(p.getPurchaseToken());

            StringBuilder sb = new StringBuilder("{");
            sb.append("\"signature\":\"" + p.getSignature() + "\",");
            sb.append("\"originalJson\":\"" + p.getOriginalJson() + "\",");
            sb.append("\"productIdentifier\":\"" + p.getSku() + "\"");
            sb.append("}");

            result.success("{\"status\":\"loaded\",\"products\":" + sb.toString() + "}");
          } else {
            result.error("ERROR", "Failed to buy", null);
          }
        }
      }, null);
    } else if (call.method.equals("fetch")) { // gets products info
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {
          billingManager.querySKUProducts((List<String>) call.arguments);
        }

        @Override
        public void onConsumeFinished(String token, int result) {}

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {}
      }, new SkuDetailsResponseListener() {
        @Override
        public void onSkuDetailsResponse(int responseCode, List<SkuDetails> skuDetailsList) {
          StringBuilder sb = new StringBuilder("[");
          if (skuDetailsList != null) {
            for (SkuDetails details : skuDetailsList) {
              if (sb.length() > 1) {
                sb.append(",");
              }
              sb.append("{");
              sb.append("\"localizedDescription\":\"" + details.getDescription() + "\",");
              sb.append("\"localizedTitle\":\"" + details.getTitle() + "\",");
              sb.append("\"price\":\"" + details.getPrice() + "\",");
              sb.append("\"priceLocale\":\"" + details.getPriceCurrencyCode() + "\",");
              sb.append("\"localizedPrice\":\"" + details.getPrice() + "\",");
              sb.append("\"productIdentifier\":\"" + details.getSku() + "\"");
              sb.append("}");
            }
          }
          sb.append("]");
          result.success("{\"status\":\"loaded\",\"products\":" + sb.toString() + "}");
        }

      });
    } else {
      result.notImplemented();
    }
  }

  public String jsonFromString(String status) {
    return "{\"status\":\"" + status + "\"}";
  }
}
