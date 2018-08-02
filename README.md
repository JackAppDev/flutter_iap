# flutter_iap

Add _In-App Payments_ to your Flutter app with this plugin.

- You can retrieve a list of previously purchased IAP product IDs (only Android)
- You can fetch IAP products from Google Play and App Store
- You can buy an IAP product
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

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
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
    List<String> productIds = ["com.example.testiap"];

    IAPResponse response = await FlutterIap.fetchProducts(productIds);
    productIds = response.products
        .map((IAPProduct product) => product.productIdentifier)
        .toList();

    IAPResponse purchased = await FlutterIap.fetchInventory();
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
      list.add(new Text(productId));
    });

    if (list.isEmpty) {
      list.add(new Text("No previous purchases found."));
    } else {
      list.insert(0, new Text("Already purchased:"));
    }

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("flutter_iap example app"),
        ),
        body: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                _productIds.isNotEmpty
                    ? "Fetched: $_productIds"
                    : "Not working?\n"
                    "Check that you set up in app purchases in\n"
                    "iTunes Connect / Google Play Console",
                textAlign: TextAlign.center,
                textScaleFactor: 1.25,
              ),
              new SizedBox(
                height: 24.0,
              ),
            ].followedBy(list),
          ),
        ),
        floatingActionButton: nextPurchase != null
            ? new FloatingActionButton(
                child: new Icon(Icons.monetization_on),
                onPressed: () {
                  FlutterIap.buy(nextPurchase);
                },
              )
            : new Container(),
      ),
    );
  }
}
```
