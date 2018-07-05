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
> This example will not work unless you do the above

```dart
import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';

void main() {
  runApp(new MyApp());
}

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
    IAPResponse response = await FlutterIap.fetchProducts(["com.example.testiap"]);
    List<IAPProduct> productIds = response.products;
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
          title: new Text('IAP example app'),
        ),
        body: new Center(
          child: new Text('Fetched: ${_productIds.map<String>((product) => "${product.productIdentifier}-${product.localizedPrice}").toList()}\n'),
        ),
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.monetization_on),
          onPressed: () {
            FlutterIap.buy(_productIds.first.productIdentifier);
          },
        ),
      ),
    );
  }
}
```
