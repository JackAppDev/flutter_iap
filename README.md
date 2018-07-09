# flutter_iap

Add _In-App Payments_ to your Flutter app with this plugin.

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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> _productIds = [];

  @override initState() {
    super.initState();
    init();
  }

  init() async {
    List<String> productIds = ["com.example.testiap"];

    if (Platform.isIOS) {
      IAPResponse response = await FlutterIap.fetchProducts(productIds);
      productIds = response.products.map((IAPProduct product) => product.productIdentifier).toList();
    }

    if (!mounted)
      return;

    setState(() {
      _productIds = productIds;
    });
  }

  @override Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("flutter_iap example app"),
        ),
        body: new Center(
          child: new Text(_productIds.isNotEmpty
            ? "Fetched: $_productIds"
            : "Not working?\n"
              "Check that you set up in app purchases in\n"
              "iTunes Connect / Google Play Console",
            textAlign: TextAlign.center,
            textScaleFactor: 1.25,
          ),
        ),
        floatingActionButton: _productIds.isNotEmpty
          ? new FloatingActionButton(
            child: new Icon(Icons.monetization_on),
            onPressed: () {
              FlutterIap.buy(_productIds.first);
            },
          ) : new Container(),
      ),
    );
  }
}
```
