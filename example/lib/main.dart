import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<IAPProduct> _productIds = [];

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
    List<String> summaries = _productIds.map<String>((product) => "${product.productIdentifier}-${product.localizedPrice}").toList();
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("flutter_iap example app"),
        ),
        body: new Center(
          child: new Text(summaries.isNotEmpty 
            ? "Fetched: $summaries"
            : "Not working?\n"
              "Check that you set up in app purchases in\n"
              "iTunes Connect / Google Play Console",
            textAlign: TextAlign.center,
            textScaleFactor: 1.25,
          ),
        ),
        floatingActionButton: summaries.isNotEmpty 
          ? new FloatingActionButton(
            child: new Icon(Icons.monetization_on),
            onPressed: () {
              FlutterIap.buy(_productIds.first.productIdentifier);
            },
          ) : new Container(),
      ),
    );
  }
}
