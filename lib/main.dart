import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/pages/cart_page.dart';
import 'package:shop_flutter/providers/orders.dart';
import 'providers/cart.dart';

import 'pages/product_detail_page.dart';
import 'pages/products_overview_page.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Color.fromRGBO(90, 70, 150, 1),
            accentColor: Color.fromRGBO(230, 140, 90, 1),
            fontFamily: 'Lato'),
        home: ProductsOverviesPage(),
        routes: {
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
        },
      ),
    );
  }
}
