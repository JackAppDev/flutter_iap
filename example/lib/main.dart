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

    List<String> purchased = await FlutterIap.fetchInventory();

    if (!mounted) return;

    setState(() {
      _productIds = productIds;
      _alreadyPurchased = purchased;
    });
  }

  @override
  Widget build(BuildContext context) {
    String nextPurchase =
        _productIds.firstWhere((id) => !_alreadyPurchased.contains(id));

    List<Text> list = [];
    _alreadyPurchased.forEach((productId) {
      list.add(Text(productId));
    });

    if (list.isEmpty) {
      list.add(Text("No previous purchases found."));
    }

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("flutter_iap example app"),
        ),
        body: new Center(
          child: Column(
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
                  SizedBox(
                    height: 24.0,
                  ),
                  Text("Already purchased:"),
                ] +
                list,
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
