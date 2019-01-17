import 'package:flutter/material.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_iap/gen/flutter_iap.pb.dart';

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
                  IAPResponse response = await FlutterIap.buy(
                    nextPurchase,
                    type: IAPProductType.iap,
                  );
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
