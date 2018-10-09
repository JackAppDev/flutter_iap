# flutter_iap

Add _In-App Payments_ to your Flutter app with this plugin.

- You can retrieve a list of previously purchased IAP product IDs (only Android)
- You can fetch IAP products from Google Play and App Store
- You can buy an IAP product
- You can consume a IAP product (only Android)
- You can restore purchases from App Store (only iOS)

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/platform-plugins/#edit-code).

## Install

Add ```flutter_iap``` as a dependency in pubspec.yaml

For help on adding as a dependency, view the [documentation](https://flutter.io/using-packages/).

## Example

> Note: You must set up billing information in your developer account corresponding with the platform you are testing (iTunes Connect / Google Play Console)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _productIds = [];
  List<String> _alreadyPurchased = [];

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    // Android testers: You can use "android.test.purchased" to simulate a successful flow.
    List<String> productIds = ["com.example.testiap"];

    IAPResponse products = await FlutterIap.fetchProducts(productIds);
    if (products.status != IAPResponseStatus.ok) {
      print("Products not retrieved, error: ${products.status}");
      return;
    }

    IAPResponse purchased = await FlutterIap.fetchInventory();
    if (purchased.status != IAPResponseStatus.ok) {
      print("Inventory not retrieved, error: ${purchased.status}");
      return;
    }

    productIds = products.products
        .map((IAPProduct product) => product.productIdentifier)
        .toList();

    List<String> purchasedIds = purchased.purchases
        .map((IAPPurchase purchase) => purchase.productIdentifier)
        .toList();

    if (!mounted) return;

    setState(() {
      _productIds = productIds;
      _alreadyPurchased = purchasedIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    String nextPurchase = _productIds.firstWhere(
      (id) => !_alreadyPurchased.contains(id),
      orElse: () => null,
    );

    List<Text> list = [];
    _alreadyPurchased.forEach((productId) {
      list.add(Text(productId));
    });

    if (list.isEmpty) {
      list.add(Text("No previous purchases found."));
    } else {
      list.insert(0, Text("Already purchased:"));
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("flutter_iap example app"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _productIds.isNotEmpty
                    ? "Available Products to purchase: $_productIds"
                    : "Not working?\n"
                    "Check that you set up in app purchases in\n"
                    "iTunes Connect / Google Play Console",
                textAlign: TextAlign.center,
                textScaleFactor: 1.25,
              ),
              SizedBox(height: 24.0),
            ].followedBy(list).toList(),
          ),
        ),
        floatingActionButton: nextPurchase != null
            ? FloatingActionButton(
                child: Icon(Icons.monetization_on),
                onPressed: () async {
                  IAPResponse response = await FlutterIap.buy(nextPurchase);
                  if (response.purchases != null) {
                    List<String> purchasedIds = response.purchases
                        .map((IAPPurchase purchase) =>
                            purchase.productIdentifier)
                        .toList();

                    setState(() {
                      _alreadyPurchased = purchasedIds;
                    });
                  }
                },
              )
            : Container(),
      ),
    );
  }
}
```

## Contributing

This project welcomes PRs to fix issues and improve functionality.

To get started, clone the git repository to a local directory (`flutter_iap`), and run:

```
$ flutter create --template=plugin --ios-language=swift .
```

You can then use `flutter run` as usual in the `example` directory to get started.
