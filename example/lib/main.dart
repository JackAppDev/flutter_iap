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
