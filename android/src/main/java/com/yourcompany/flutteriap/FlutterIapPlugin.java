package com.yourcompany.flutteriap;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.Purchase;

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
                billingManager.destroy();
            }
        });
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {
        if (call.method.equals("buy")) {
            billingManager = new BillingManager(activity, new BillingManager.BillingUpdatesListener() {
                @Override
                public void onBillingClientSetupFinished() {
                    billingManager.initiatePurchaseFlow((String) call.arguments, BillingClient.SkuType.INAPP);
                }

                @Override
                public void onConsumeFinished(String token, @BillingClient.BillingResponse int result) {

                }

                @Override
                public void onPurchasesUpdated(List<Purchase> purchases) {
                    for (Purchase p : purchases) {
                        Log.e("Consuming", p.getSku());
                        billingManager.consumeAsync(p.getPurchaseToken());
                    }
                    result.success(purchases);
                }
            });
        }


    }


}
