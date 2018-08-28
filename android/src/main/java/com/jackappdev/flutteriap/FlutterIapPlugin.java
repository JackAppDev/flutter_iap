package com.jackappdev.flutteriap;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsResponseListener;
import org.json.JSONObject;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

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
//    if (billingManager != null) {
//      billingManager.destroy();
//      billingManager = null;
//    }

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
          result
              .success("{\"status\":\"loaded\",\"purchases\":" + generateJsonArray(purchases) + "}");
        }
      }, null);

    } else if ("buy".equals(call.method)) {
      billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
        @Override
        public void onBillingClientSetupFinished() {
          billingManager
              .initiatePurchaseFlow((String) call.arguments, BillingClient.SkuType.INAPP);
        }

        @Override
        public void onConsumeFinished(String token,
                                      @BillingClient.BillingResponse int responseCode) {
        }

        @Override
        public void onPurchasesUpdated(List<Purchase> purchases) {
          Log.e("purchases", purchases.toString());
          if (purchases.size() > 0) {
            // TODO: Dry the code (see above).
            StringBuilder sb = new StringBuilder("[");

            for (Purchase p : purchases) {
              if (sb.length() > 1) {
                sb.append(",");
              }
              sb.append("{");
              sb.append("\"signature\":\"").append(p.getSignature()).append("\",");
              sb.append("\"purchaseToken\":\"").append(p.getPurchaseToken()).append("\",");
              sb.append("\"originalJson\":").append(JSONObject.quote(p.getOriginalJson()))
                  .append(",");
              sb.append("\"productIdentifier\":\"").append(p.getSku()).append("\"");
              sb.append("}");
            }
            sb.append("]");

            result.success("{\"status\":\"loaded\",\"purchases\":" + sb.toString() + "}");
          } else {
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
              result.success(jsonFromString("OK"));
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
        public void onSkuDetailsResponse(int responseCode, List<SkuDetails> skuDetailsList) {
          StringBuilder sb = new StringBuilder("[");
          if (skuDetailsList != null) {
            for (SkuDetails details : skuDetailsList) {
              if (sb.length() > 1) {
                sb.append(",");
              }
              sb.append("{");
              sb.append("\"localizedDescription\":\"").append(details.getDescription())
                  .append("\",");
              sb.append("\"localizedTitle\":\"").append(details.getTitle()).append("\",");
              sb.append("\"price\":\"").append(details.getPrice()).append("\",");
              sb.append("\"priceLocale\":\"").append(details.getPriceCurrencyCode())
                  .append("\",");
              sb.append("\"localizedPrice\":\"").append(details.getPrice()).append("\",");
              sb.append("\"type\":\"").append(details.getType()).append("\",");
              sb.append("\"productIdentifier\":\"").append(details.getSku()).append("\"");
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

  private String generateJsonArray(List<Purchase> purchases) {
    List<String> tmp = new ArrayList<>();

    if (purchases != null) {
      for (Purchase p : purchases) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"signature\":\"").append(p.getSignature()).append("\",");
        sb.append("\"purchaseToken\":\"").append(p.getPurchaseToken()).append("\",");
        sb.append("\"originalJson\":").append(JSONObject.quote(p.getOriginalJson())).append(",");
        sb.append("\"productIdentifier\":\"").append(p.getSku()).append("\"");
        sb.append("}");
        tmp.add(sb.toString());
      }
    }

    return String.format(Locale.US, "[%s]", TextUtils.join(",", tmp));
  }

  private String jsonFromString(String status) {
    return "{\"status\":\"" + status + "\"}";
  }
}
